import java.util.Properties
import java.io.FileInputStream
import com.android.build.api.variant.FilterConfiguration

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Per-ABI APKs are produced only when assembling a release, keeping debug builds single-APK.
val abiSplitsEnabled = gradle.startParameter.taskNames.any { it.contains("Release") }

android {
    namespace = "com.thehelloworldwriter.sixteen_million_taps"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.thehelloworldwriter.sixteenmilliontaps"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }

    // Emit per-ABI APKs plus a universal one, but only for release assembly, so `flutter run` and
    // debug stay single-APK and fast. Driving the split through Gradle (instead of
    // `flutter build apk --split-per-abi`) keeps the Flutter plugin from applying its own
    // `abiIndex * 1000 + base` versionCode offset, leaving the scheme below as the final word.
    splits {
        abi {
            isEnable = abiSplitsEnabled
            reset()
            include("armeabi-v7a", "arm64-v8a", "x86_64")
            isUniversalApk = true
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

// Per-ABI versionCode scheme: the real build number occupies the high digits and the ABI the low
// digit, so the real version always dominates ordering - an older split can never outrank a newer
// build, and the base is not capped under 1000. Every output, the universal included (suffix 0),
// shares one monotonic range. The Gradle-driven split above keeps Flutter from applying its own
// offset, so this onVariants value is final.
val abiVersionSuffix = mapOf("armeabi-v7a" to 1, "arm64-v8a" to 2, "x86_64" to 4)
val baseVersionCode = flutter.versionCode
androidComponents {
    onVariants { variant ->
        variant.outputs.forEach { output ->
            val abi = output.filters
                .find { it.filterType == FilterConfiguration.FilterType.ABI }
                ?.identifier
            output.versionCode.set(baseVersionCode * 10 + (abiVersionSuffix[abi] ?: 0))
        }
    }
}
