# ProGuardの設定例

# アプリ全体の最適化、シュリンク、オブスクフィケーションを有効にする
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
-verbose
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

# プロガードが特定のクラスやメソッドを縮小しないようにする
-keep class * {
    public protected *;
}

# プロジェクトライブラリのクラスを保持
-keep class com.example.** { *; }