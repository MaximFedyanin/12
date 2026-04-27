# === TensorFlow Lite & GPU Delegate ===
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-keep class org.tensorflow.lite.nnapi.** { *; }
-keep class org.tensorflow.lite.support.** { *; }
-dontwarn org.tensorflow.lite.**

# === Сохраняем нативные модели и токенизаторы ===
-keep class * implements org.tensorflow.lite.Interpreter$Options { *; }

# === Isar & Hive (опционально, но рекомендуется для стабильности) ===
-keep class io.isar.** { *; }
-keep class com.hive.** { *; }

# === Общее для R8 ===
-keepattributes Signature, InnerClasses, EnclosingMethod
-dontnote com.google.android.exoplayer2.**
-dontwarn org.conscrypt.**

# Isar-specific rules
-keep class **.$Isar** { *; }
-keep class **.$IsarCollection** { *; }
-keep class * extends com.isar.core.IsarCollection { *; }

# Keep model classes (замените com.yourapp.models на ваш пакет моделей)
-keep class com.yourapp.models.** { *; }

# Keep constructors for reflection
-keepclassmembers class * {
    <init>(...);
}

# Keep enum fields
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Flutter plugin bindings
-keep class io.flutter.plugin.** { *; }
