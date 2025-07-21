pipeline {
    agent { label 'windows' } // Windows Jenkins agent

    environment {
        IMAGE_NAME = 'rahulchaubey/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred' // Jenkins credentials ID
        BUILD_PATH = 'NareshMVC5App\\NareshMVC5App.csproj'
        MSBUILD_PATH = 'C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe'
        PUBLISH_DIR = 'C:\\PublishedApp\\'
        DEPLOY_DIR = 'C:\\inetpub\\wwwroot\\NareshMVC5App\\'
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
                echo === Checking MSBuild path ===
                if not exist "%MSBUILD_PATH%" (
                    echo ERROR: MSBuild not found at %MSBUILD_PATH%
                    exit /b 1
                )

                echo === Creating publish directory if not exists ===
                if not exist "%PUBLISH_DIR%" mkdir "%PUBLISH_DIR%"

                echo === Building the project ===
                "%MSBUILD_PATH%" %BUILD_PATH% ^
                    /p:Configuration=Release ^
                    /p:DeployOnBuild=true ^
                    /p:PublishDir=%PUBLISH_DIR%
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                echo === Deploying to IIS ===
                if not exist "%DEPLOY_DIR%" mkdir "%DEPLOY_DIR%"
                xcopy /s /e /y "%PUBLISH_DIR%*" "%DEPLOY_DIR%"
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
                ]) {
                    bat '''
                    echo === Logging in to DockerHub ===
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
