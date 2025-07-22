pipeline {
    agent { label 'windows' }

    environment {
        PROJECT_NAME = "NareshMVC5App"
        BUILD_CONFIGURATION = "Release"
        MSBUILD_PATH = "C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe"
        PUBLISH_DIR = "C:\\PublishedApp\\NareshMVC5App\\"
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
                set MSBUILD_PATH=C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe

                if not exist "%MSBUILD_PATH%" (
                    echo ERROR: MSBuild not found at %MSBUILD_PATH%
                    exit /b 1
                )

                echo MSBuild found at %MSBUILD_PATH%

                "%MSBUILD_PATH%" NareshMVC5App\\NareshMVC5App.csproj ^
                    /p:Configuration=Release ^
                    /p:DeployOnBuild=true ^
                    /p:WebPublishMethod=FileSystem ^
                    /p:PublishDir=C:\\PublishedApp\\NareshMVC5App\\ ^
                    /p:VisualStudioVersion=14.0
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                echo === Deploying to IIS ===
                xcopy /E /Y /I C:\\PublishedApp\\NareshMVC5App\\ "C:\\inetpub\\wwwroot\\NareshMVC5App\\"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                bat '''
                echo === Building Docker Image ===
                docker build -t mvc5-app-image .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                bat '''
                echo === Pushing Docker Image ===
                docker tag mvc5-app-image your-dockerhub-username/mvc5-app-image
                docker push your-dockerhub-username/mvc5-app-image
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
