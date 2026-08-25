import com.android.build.gradle.BaseExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    afterEvaluate {
        if (name == "otp_autofill") {
            val helperFile = file(
                "src/main/kotlin/ru/surfstudio/otp_autofill/AppSignatureHelper.kt",
            )
            if (helperFile.exists()) {
                val broken = ").signatures\n            signatures.mapNotNull"
                val fixed = ").signatures ?: arrayOf()\n            signatures.mapNotNull"
                val text = helperFile.readText()
                if (text.contains(broken)) {
                    helperFile.writeText(text.replace(broken, fixed))
                }
            }
        }

        extensions.findByType(BaseExtension::class.java)?.apply {
            compileSdkVersion(36)
        }
    }

    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
