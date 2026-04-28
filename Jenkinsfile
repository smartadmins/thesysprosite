pipeline {
    agent any

    environment {
        DOCKERHUB_CREDS = credentials('docker-hub-ksudhy')
        IMAGE_NAME = "ksudhy/thesysprosite"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/smartadmins/thesysprosite.git']])
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

         stage('Trivy Filesystem Scan') {
            steps {
                sh """
                    trivy fs --format table --severity HIGH,CRITICAL .
                """
            }
        }

        stage('Login to DockerHub') {
            steps {
                sh """
                echo ${DOCKERHUB_CREDS_PSW} | docker login \
                -u ${DOCKERHUB_CREDS_USR} --password-stdin
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                docker push ${IMAGE_NAME}:${IMAGE_TAG}
                docker push ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }
 
    post {
        always {
            sh 'docker logout || true'
            sh 'docker system prune -f || true'
        }

        success {
            echo "Image pushed successfully: ${IMAGE_NAME}:${IMAGE_TAG}"
        }

        failure {
            echo "Pipeline failed. Check logs."
        }
    }
}
