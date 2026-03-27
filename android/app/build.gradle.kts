plugins {
    id("com.android.application")
    id("kotlin-android")
    id ("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "inc.futuretechnologies.presidentftinc.freelance.flutter.future_pos"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.2.12479018"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_21.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "inc.futuretechnologies.presidentftinc.freelance.flutter.future_pos"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    dependencies {
        // ...
        // Use this dependency to bundle the model with your app
        implementation ("com.google.mlkit:barcode-scanning:17.3.0")
        // Use this dependency to use the dynamically downloaded model in Google Play Services
        implementation(platform("com.google.firebase:firebase-bom:33.13.0"))
        implementation("com.google.firebase:firebase-analytics")
        implementation ("com.google.firebase:firebase-auth")
        implementation ("com.google.firebase:firebase-firestore")
        implementation ("com.google.android.gms:play-services-mlkit-barcode-scanning:18.3.1")
        implementation ("com.google.android.gms:play-services-location:21.3.0")
    }
}

flutter {
    source = "../.."
}
