pipeline {
    agent any

    stages {

        stage('Build APK for Andrioid  ') {
            steps {
                script {
                    docker.image('cirrusci/flutter:stable').inside {
                        dir('FE/icecream') {
                            sh 'flutter pub get'
                            sh 'flutter build apk'
                        }
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