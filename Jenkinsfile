pipeline {
    agent { label 'windows' }

    environment {
        IMAGE_NAME = 'rahulchaubey391/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/rahulchaubey91/NareshMVC5App.git', branch: 'main'
            }
        }

        stage('Verify MSBuild') {
            steps {
                bat '''
@echo off
set "MSBUILD_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
echo === Checking MSBuild path ===
if not exist "%MSBUILD_PATH%" (
    echo ERROR: MSBuild not found at "%MSBUILD_PATH%"
    exit /b 1
)
echo MSBuild path verified: %MSBUILD_PATH%
                '''
            }
        }

        stage('Build and Publish') {
            steps {
                bat '''
@echo off
set "MSBUILD_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
"%MSBUILD_PATH%" NareshMVC5App\NareshMVC5App.csproj /p:Configuration=Release /p:DeployOnBuild=true /p:PublishDir="C:\PublishedApp\"
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
@echo off
xcopy /s /e /y "C:\PublishedApp\*" "C:\inetpub\wwwroot\NareshMVC5App\"
iisreset
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME% .'
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
@echo off
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
