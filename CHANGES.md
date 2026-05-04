# Build Resolutions and Version Conflicts

During the build process, several environment/version conflict errors were encountered and resolved:

## 1. JDK 25 and Gradle Kotlin DSL Incompatibility
**Error:** `java.lang.IllegalArgumentException: 25.0.3-ea`
**Reason:** The system environment provided `OpenJDK 25-ea`, which the embedded Gradle Kotlin compiler (in AGP 8.11.1) fails to parse due to the `-ea` suffix and major version `69`.
**Resolution:**
- Modified the Gradle files from `.kts` (Kotlin DSL) to `.gradle` (Groovy DSL) because Groovy handles the evaluation differently, removing the Kotlin compiler crash.
- Installed `openjdk-21-jdk` (Java 21) via `apt-get` and ran the build with `JAVA_HOME` pointing to it because the Groovy parser itself does not yet support Java major version 69.

## 2. Core Library Desugaring Requirement
**Error:** `Dependency ':flutter_local_notifications' requires core library desugaring to be enabled for :app.`
**Reason:** The `flutter_local_notifications` package required Java 8+ features under Android API levels lower than 26, necessitating desugaring.
**Resolution:**
- Enabled `coreLibraryDesugaringEnabled true` inside the `compileOptions` block in `android/app/build.gradle`.
- Added the dependency `coreLibraryDesugaring "com.android.tools:desugar_jdk_libs:2.0.4"`.
