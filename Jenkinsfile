pipeline {
    agent { label 'windows' }

    environment {
        PUBLISH_DIR = "C:\\PublishedApp\\NareshMVC5App\\"
        MSBUILD_EXE = "\"C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe\""
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
                echo === Checking MSBUILD path ===
                if not exist %MSBUILD_EXE% (
                    echo ERROR: MSBuild not found at %MSBUILD_EXE%
                    exit /b 1
                )
                echo === Building with MSBuild ===
                %MSBUILD_EXE% NareshMVC5App\\NareshMVC5App.csproj ^
                  /p:Configuration=Release ^
                  /p:DeployOnBuild=true ^
                  /p:WebPublishMethod=FileSystem ^
                  /p:PublishDir=${PUBLISH_DIR} ^
                  /p:VisualStudioVersion=14.0
                """
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat """
                echo === Copying Published Files to IIS ===
                xcopy /E /Y /I ${PUBLISH_DIR} "C:\\inetpub\\wwwroot\\NareshMVC5App\\"
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t mvc5-app-image .'
            }
        }

        stage('Push Docker Image') {
            steps {
                bat '''
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
