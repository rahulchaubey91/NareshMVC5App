pipeline {
    agent { label 'windows' }

    environment {
        IMAGE_NAME = 'rahulchaubey/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred'
        MSBUILD_PATH = '"C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe"'
        PUBLISH_DIR = 'C:\\PublishedApp\\'
        IIS_DEPLOY_DIR = 'C:\\inetpub\\wwwroot\\NareshMVC5App\\'
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
                echo === Checking MSBuild path ===
                if not exist "C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe" (
                    echo ERROR: MSBuild not found at C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe
                    exit /b 1
                )
                echo MSBuild found!
                '''
            }
        }

        stage('Build and Publish') {
            steps {
                bat '''
                "C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe" ^
                NareshMVC5App\\NareshMVC5App.csproj ^
                /p:Configuration=Release ^
                /p:DeployOnBuild=true ^
                /p:PublishDir=C:\\PublishedApp\\
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                if not exist "C:\\inetpub\\wwwroot\\NareshMVC5App\\" mkdir "C:\\inetpub\\wwwroot\\NareshMVC5App\\"
                xcopy /s /e /y "C:\\PublishedApp\\*" "C:\\inetpub\\wwwroot\\NareshMVC5App\\"
                iisreset
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t rahulchaubey/mvc5app ."
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
                    docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                    docker push rahulchaubey/mvc5app
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
