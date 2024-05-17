pipeline {
    agent any
        environment {
        ANDROID_HOME = '/home/ubuntu/android-studio/'
    }

    stages {
        stage('Env Prepare') {
            steps {
                withCredentials([
                    file(credentialsId: 'FLUTTER_ENV', variable: 'FLUTTER_ENV')
                    ]) {

                script{
                    sh 'cp "${FLUTTER_ENV}" FE/icecream/.env'
                    }
                }   
            }
        }            
        stage('Build APK for Andrioid  ') {
            steps {
                script {
 
                    dir('FE/icecream') {
                        sh 'git config --global --add safe.directory /var/flutter'
                        sh '/var/flutter/bin/flutter pub get'
                        sh '/var/flutter/bin/flutter build apk --release --target-platform=android-arm64'
                    }
                }
            }
        }
        
        stage('Upload APK to EC2 ') {
            steps {
                script {
                dir('FE/icecream') {
                    sh "cp -f build/app/outputs/flutter-apk/app-release.apk /home/ubuntu/icecream/icecream.apk"
                    }
                }
            }
        }

    }
}