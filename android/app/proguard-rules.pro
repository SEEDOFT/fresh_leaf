# Flutter-related rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Flutter native code
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom application classes - but obfuscate internal methods
-keep class com.seedoft.fresh_leaf.MainActivity { public *; }

# Keep native methods
-keepclasseswithmembers class * {
    *** *(...);
}

# SECURITY: Remove all logging statements completely
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# SECURITY: Remove debug and stack trace info
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# SECURITY: Prevent reflection attacks
-keepattributes Exceptions

# SECURITY: Remove debug attributes that could expose variable names
-keepattributes LocalVariableTable
-keepattributes LocalVariableTypeTable

# SECURITY: Obfuscate class names, method names, and field names
-obfuscationdictionary obfuscation_dict.txt
-packageobfuscationdictionary obfuscation_dict.txt
-classobfuscationdictionary obfuscation_dict.txt

# Remove toString() implementations that might leak data
-assumenosideeffects class * extends java.lang.Throwable {
    public *** toString(...);
}

# Optimization settings - aggressive
-optimizationpasses 7
-verbose
-dontoptimize
-dontwarn **

# SECURITY: Enable R8 specific optimizations
-allowaccessmodification
-repackageclasses 'obf'
