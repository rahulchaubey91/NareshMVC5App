pipeline {
    agent { label 'windows' } // Windows node required

    environment {
        IMAGE_NAME = 'rahulchaubey/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred' // Jenkins Credentials ID
        PUBLISH_DIR = 'C:\\Jenkins\\PublishedApp\\'
        IIS_DEPLOY_DIR = 'C:\\inetpub\\wwwroot\\NareshMVC5App\\'
        MSBUILD_EXE = '"C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe"'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/rahulchaubey91/NareshMVC5App.git', branch: 'main'
            }
        }

        stage('Build and Publish') {
            steps {
                bat """
                ${MSBUILD_EXE} NareshMVC5App\\NareshMVC5App.csproj /p:Configuration=Release /p:DeployOnBuild=true /p:PublishDir=${PUBLISH_DIR}
                """
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat """
                if not exist "${IIS_DEPLOY_DIR}" mkdir "${IIS_DEPLOY_DIR}"
                xcopy /s /e /y "${PUBLISH_DIR}*" "${IIS_DEPLOY_DIR}"
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
                    bat """
                    docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                    docker push %IMAGE_NAME%
                    """
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
