pipeline {
    agent { label 'windows' }

    environment {
        IMAGE_NAME = 'rahulchaubey/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred'
        MSBUILD_PATH = 'C:\\Progra~2\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe'
        PUBLISH_DIR = 'C:\\PublishedApp\\'
        IIS_TARGET_DIR = 'C:\\inetpub\\wwwroot\\NareshMVC5App\\'
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
                echo === Checking MSBuild path ===
                if not exist "%MSBUILD_PATH%" (
                    echo ERROR: MSBuild not found at %MSBUILD_PATH%
                    exit /b 1
                )
                echo MSBuild found at %MSBUILD_PATH%

                echo === Workaround for missing WebApplication.targets ===
                set "WEBAPP_TARGETS=C:\\Program Files (x86)\\MSBuild\\Microsoft\\VisualStudio\\v14.0\\WebApplications\\Microsoft.WebApplication.targets"
                if not exist "%WEBAPP_TARGETS%" (
                    mkdir "C:\\Program Files (x86)\\MSBuild\\Microsoft\\VisualStudio\\v14.0\\WebApplications"
                    curl -L -o "%WEBAPP_TARGETS%" https://raw.githubusercontent.com/rahulchaubey91/NareshMVC5App/main/Microsoft.WebApplication.targets
                )

                echo === Building and Publishing ===
                "%MSBUILD_PATH%" NareshMVC5App\\NareshMVC5App.csproj ^
                    /p:Configuration=Release ^
                    /p:DeployOnBuild=true ^
                    /p:WebPublishMethod=FileSystem ^
                    /p:PublishProvider=FileSystem ^
                    /p:PublishDir=%PUBLISH_DIR% ^
                    /p:VisualStudioVersion=14.0
                """
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat """
                echo === Deploying to IIS ===
                if not exist "%IIS_TARGET_DIR%" mkdir "%IIS_TARGET_DIR%"
                xcopy /s /e /y "%PUBLISH_DIR%*" "%IIS_TARGET_DIR%"
                iisreset
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                bat """
                echo === Building Docker Image ===
                docker build -t %IMAGE_NAME% .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDENTIALS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat """
                    echo === Logging into DockerHub ===
                    docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                    echo === Pushing Docker Image ===
                    docker push %IMAGE_NAME%
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace..."
            cleanWs()
        }
    }
}
