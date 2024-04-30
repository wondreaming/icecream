pipeline {
    agent any

    environment {
        HOME_PATH = '/home/ubuntu'
    }

    stages {
        // 빌드
        stage('Build BE') {
            steps {
                echo 'Building BE'
                // 백엔드 소스코드가 있는 경로로 이동
                dir('BE/icecream') {
                    // Docker 이미지 빌드 명령어
                    sh 'docker build --no-cache -t icecream .'
                }
            }
        }

        // 테스트
        stage('Test') {
            steps {
                // 테스트 관련 작업을 여기에 추가
                echo 'Test는 일단 패스'
            }
        }

        // 배포
        stage('Deploy BEank') {
            steps {
                // 배포 관련 작업을 여기에 추가
                echo 'Deploying Bank...'
                // 빌드가 진행되면 기존의 컨테이너 중지 및 제거 & 컨테이너가 없어도 실패하지 않고계속 수행
                sh 'docker stop icecream || true'
                sh 'docker rm icecream || true'
                // 백엔드 이미지 실행
                sh 'docker run -d -p 8080:8080 --name icecream icecream'
            }
        }
    }
}
