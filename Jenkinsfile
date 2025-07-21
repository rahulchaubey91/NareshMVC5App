pipeline {
    agent { label 'windows' } // Must be a Windows agent

    environment {
        IMAGE_NAME = 'rahulchaubey/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred' // Jenkins credential ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/rahulchaubey91/NareshMVC5App.git', branch: 'main'
            }
        }

        stage('Build and Publish') {
            steps {
                bat '''
                    "C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe" ^
                    NareshMVC5App\\NareshMVC5App.csproj ^
                    /p:Configuration=Release ^
                    /p:DeployOnBuild=true ^
                    /p:PublishDir="C:\\PublishedApp\\"
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                    xcopy /s /e /y "C:\\PublishedApp\\*" "C:\\inetpub\\wwwroot\\NareshMVC5App\\"
                    iisreset
                '''
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
