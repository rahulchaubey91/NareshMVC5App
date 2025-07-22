pipeline {
    agent {
        label 'windows'
    }

    environment {
        PUBLISH_DIR = "C:\\PublishedApp\\"
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
                set MSBUILD_PATH=C:\\Progra~2\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe

                if not exist "%MSBUILD_PATH%" (
                    echo ERROR: MSBuild not found at %MSBUILD_PATH%
                    exit /b 1
                )
                echo MSBuild found at %MSBUILD_PATH%

                echo === Building and Publishing the MVC5 App ===
                "%MSBUILD_PATH%" NareshMVC5App\\NareshMVC5App.csproj ^
                    /p:Configuration=Release ^
                    /p:DeployOnBuild=true ^
                    /p:WebPublishMethod=FileSystem ^
                    /p:PublishProvider=FileSystem ^
                    /p:PublishDir=%PUBLISH_DIR% ^
                    /p:VisualStudioVersion=14.0
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                echo 'IIS Deployment stage placeholder.'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Docker image build placeholder.'
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Docker push stage placeholder.'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
