allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// CẤU HÌNH THƯ MỤC BUILD CHUẨN CHO FLUTTER
// Chúng ta chỉ đặt thư mục build cho App chính để Flutter CLI tìm thấy APK.
// Các plugin sẽ để Gradle tự quản lý tại thư mục mặc định của chúng (tránh lỗi different roots).
subprojects {
    if (project.name == "app") {
        project.layout.buildDirectory.set(file("${project.projectDir}/../../build/app"))
    }
}

subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            
            // Sửa lỗi "Namespace not specified" cho các plugin cũ khi dùng AGP 8.0+
            if (android.namespace == null) {
                android.namespace = project.group.toString()
            }

            android.compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
        }

        // Ép Kotlin cũng phải dùng JVM Target 17 để khớp với Java
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            kotlinOptions {
                jvmTarget = "17"
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
