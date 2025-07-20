pipeline {
    agent { label 'windows' }

    environment {
        IMAGE_NAME = 'rahulchaubey/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred' // Jenkins credentials ID
        PUBLISH_DIR = 'C:\\PublishedApp\\'
    }

    stages {
        stage('Ensure Tools Are Installed') {
            steps {
                bat '''
                where git || choco install git -y
                where java || choco install jdk8 -y
                where docker || choco install docker-cli -y
                if not exist "C:\\BuildTools" (
                    choco install visualstudio2019buildtools -y --package-parameters "--add Microsoft.VisualStudio.Workload.MSBuildTools"
                )
                '''
            }
        }

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/rahulchaubey91/NareshMVC5App.git', branch: 'main'
            }
        }

        stage('Build with MSBuild') {
            steps {
                bat """
                \"C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe\" NareshMVC5App\\NareshMVC5App.csproj /p:Configuration=Release /p:DeployOnBuild=true /p:PublishDir=${PUBLISH_DIR}
                """
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat """
                xcopy /s /e /y "${PUBLISH_DIR}*" "C:\\inetpub\\wwwroot\\NareshMVC5App\\"
                iisreset
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %IMAGE_NAME% ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${DOCKERHUB_CREDENTIALS}",
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    bat '''
                    docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                    docker push %IMAGE_NAME%
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
