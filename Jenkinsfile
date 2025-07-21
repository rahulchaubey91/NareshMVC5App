pipeline {
    agent { label 'windows' }

    environment {
        IMAGE_NAME = 'rahulchaubey391/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred'
        PUBLISH_DIR = 'C:\\Jenkins\\PublishedApp\\'
        IIS_DEPLOY_DIR = 'C:\\inetpub\\wwwroot\\NareshMVC5App\\'
        MSBUILD_PATH = 'C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe'
    }

    stages {
        stage('Prepare Environment') {
            steps {
                bat '''
                echo Checking Git...
                where git || (
                    echo Git not found. Installing...
                    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; `
                    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
                    choco install git -y
                )

                echo Checking MSBuild...
                if not exist "%MSBUILD_PATH%" (
                    echo MSBuild not found. Installing...
                    powershell -Command "Invoke-WebRequest -Uri https://aka.ms/vs/17/release/vs_BuildTools.exe -OutFile vs_BuildTools.exe; `
                    Start-Process .\\vs_BuildTools.exe -ArgumentList '--quiet --wait --norestart --nocache --installPath C:\\BuildTools `
                    --add Microsoft.VisualStudio.Workload.WebBuildTools' -Wait"
                )
                '''
            }
        }

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/rahulchaubey91/NareshMVC5App.git', branch: 'main'
            }
        }

        stage('Build and Publish') {
            steps {
                bat """
                "${MSBUILD_PATH}" NareshMVC5App\\NareshMVC5App.csproj ^
                /p:Configuration=Release ^
                /p:DeployOnBuild=true ^
                /p:PublishDir=${PUBLISH_DIR}
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
