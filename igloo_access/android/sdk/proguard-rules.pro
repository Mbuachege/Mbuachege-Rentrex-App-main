# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
-renamesourcefileattribute SourceFile

-keeppackagenames
-keepattributes *Annotation*

# Public classes
-keep class co.igloo.access.sdk.IglooPlugin { public *; }
-keepclassmembers class co.igloo.access.sdk.IglooPlugin { public*; }
-keep class co.igloo.access.sdk.Scope { public *; }
-keep class co.igloo.access.sdk.SyncResult { public *; }
-keep class co.igloo.access.sdk.UnwrappedActivityLog { public *; }

# Exception
-keep class co.igloo.access.sdk.exception.* { public *; }
-keep public class * extends co.igloo.access.sdk.exception.IglooAccessException { public *; }
-keep class co.igloo.access.sdk.exception.ExceptionKt { public *; }

# Connection
-keep class co.igloo.access.sdk.connection.LockConnectionService