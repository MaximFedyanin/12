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
