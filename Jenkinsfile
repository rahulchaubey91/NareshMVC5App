pipeline {
    agent { label "windows" }

    environment {
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
                SET "MSBUILD_PATH=C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe"
                IF NOT EXIST "%MSBUILD_PATH%" (
                    ECHO ERROR: MSBuild not found at %MSBUILD_PATH%
                    EXIT /B 1
                )
                ECHO MSBuild found at %MSBUILD_PATH%

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
            when {
                expression { fileExists('C:\\PublishedApp\\NareshMVC5App\\') }
            }
            steps {
                bat '''
                echo === Deploying to IIS ===
                xcopy /E /Y /I "C:\\PublishedApp\\NareshMVC5App\\" "C:\\inetpub\\wwwroot\\NareshMVC5App\\"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                bat '''
                docker build -t nareshmvc5app:v1 .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Skipping push as registry is not configured'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
