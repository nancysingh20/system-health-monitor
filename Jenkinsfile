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
        echo 'SYSTEM HEALTH: HEALTHY'
        echo 'System health check completed successfully.'

        archiveArtifacts artifacts: 'health_report.txt',
                         fingerprint: true
    }

    failure {
        echo 'SYSTEM HEALTH: CRITICAL'
        echo 'System health check failed.'

        emailext(
            subject: "CRITICAL: System Health Check Failed - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: """
System Health Monitor detected a critical condition.

Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
Build URL: ${env.BUILD_URL}

Please check the Jenkins console output and health report.
""",
            to: "ishu200107@gmail.com"
        )
    }

    always {
        echo 'Pipeline execution completed.'
    }
}
}
