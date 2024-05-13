pipeline {
    agent any

    environment {
        HOME_PATH = '/home/ubuntu'
    }

    stages {
        // env 적용
        stage('ELK Env Prepare') {
            steps {
                withCredentials([
                    file(credentialsId: 'ENV-ELK', variable: 'ENV_ELK'),
                    file(credentialsId: 'ELK_COF', variable: 'ELK_COF')
                    ]) {

                    script {
                        sh 'cp "${ENV_ELK}" ELK/.env'
                        sh 'cp "${ELK_COF}" ELK/logstash.conf'
                    }
                }   
            }
        }

        // 배포
        stage('Deploy ELK') {
            steps {
                dir('ELK') {
                    script {
                        sh '''
                            # Build custom Logstash image with the provided logstash.conf
                            cat <<EOF > Dockerfile.logstash
                            FROM docker.elastic.co/logstash/logstash:7.10.2
                            COPY logstash.conf /usr/share/logstash/pipeline/logstash.conf
                            EOF

                            # Build the custom Logstash image
                            docker build -t custom-logstash:latest -f Dockerfile.logstash .

                            # Stop and remove existing containers if any
                            docker-compose down || true

                            # Deploy using Docker Compose
                            docker-compose up -d
                        '''
                    }
                }
            }
        }
    }
}