pipeline {
    agent { label 'windows' }

    environment {
        IMAGE_NAME = 'rahulchaubey/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred'
        PUBLISH_DIR = 'C:\\PublishedApp\\NareshMVC5App\\'
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
                bat '''
                echo === Setting MSBUILD path ===
                set "MSBUILD_PATH=C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe"
                if not exist "%MSBUILD_PATH%" (
                    echo ERROR: MSBuild not found at %MSBUILD_PATH%
                    exit /b 1
                )
                echo MSBuild found at %MSBUILD_PATH%

                echo === Ensure Microsoft.WebApplication.targets workaround ===
                set "WEBAPP_DIR=C:\\Program Files (x86)\\MSBuild\\Microsoft\\VisualStudio\\v14.0\\WebApplications"
                set "WEBAPP_TARGETS=%WEBAPP_DIR%\\Microsoft.WebApplication.targets"
                if not exist "%WEBAPP_TARGETS%" (
                    mkdir "%WEBAPP_DIR%"
                    curl -L -o "%WEBAPP_TARGETS%" https://raw.githubusercontent.com/rahulchaubey91/NareshMVC5App/main/Microsoft.WebApplication.targets
                )

                echo === Ensure Microsoft.Web.Publishing.targets workaround ===
                set "WEBPUBLISH_TARGETS=C:\\Program Files (x86)\\MSBuild\\Microsoft\\VisualStudio\\v14.0\\Web\\Microsoft.Web.Publishing.targets"
                if not exist "%WEBPUBLISH_TARGETS%" (
                    mkdir "C:\\Program Files (x86)\\MSBuild\\Microsoft\\VisualStudio\\v14.0\\Web"
                    curl -L -o "%WEBPUBLISH_TARGETS%" https://raw.githubusercontent.com/rahulchaubey91/NareshMVC5App/main/Microsoft.Web.Publishing.targets
                )

                echo === Building and Publishing the MVC5 App ===
                "%MSBUILD_PATH%" NareshMVC5App\\NareshMVC5App.csproj ^
                    /p:Configuration=Release ^
                    /p:DeployOnBuild=true ^
                    /p:WebPublishMethod=FileSystem ^
                    /p:PublishProvider=FileSystem ^
                    /p:PublishDir=%PUBLISH_DIR% ^
                    /p:VisualStudioVersion=14.0

                echo === Listing Published Files ===
                dir /s "%PUBLISH_DIR%"
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                echo === Deploying to IIS ===
                if not exist "%IIS_TARGET_DIR%" mkdir "%IIS_TARGET_DIR%"
                xcopy /s /e /y "%PUBLISH_DIR%*" "%IIS_TARGET_DIR%"
                start /wait %SystemRoot%\\System32\\iisreset.exe
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
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDENTIALS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
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
