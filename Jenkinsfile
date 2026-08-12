pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('System Health Check') {
            steps {
                sh '''
                    chmod +x system_health_monitor.sh
                    ./system_health_monitor.sh
                '''
            }
        }
    }

    post {
        success {
            echo 'System health check completed successfully.'
        }

        failure {
            echo 'System health check failed.'
        }

        always {
            echo 'Pipeline execution completed.'
        }
    }
}
