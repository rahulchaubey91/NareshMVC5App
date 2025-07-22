pipeline {
    agent { label 'windows' }

    environment {
        IMAGE_NAME = 'rahulchaubey/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred'
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

                if not exist "%%MSBUILD_PATH%%" (
                    echo ERROR: MSBuild not found at %%MSBUILD_PATH%%
                    exit /b 1
                )
                echo MSBuild found at %%MSBUILD_PATH%%

                echo === Ensure Microsoft.WebApplication.targets workaround ===
                set "WEBAPP_DIR=C:\\Program Files (x86)\\MSBuild\\Microsoft\\VisualStudio\\v14.0\\WebApplications"
                set "WEBAPP_TARGETS=%%WEBAPP_DIR%%\\Microsoft.WebApplication.targets"

                if not exist "%%WEBAPP_TARGETS%%" (
                    echo Creating workaround targets folder...
                    mkdir "%%WEBAPP_DIR%%"
                    curl -L -o "%%WEBAPP_TARGETS%%" https://raw.githubusercontent.com/rahulchaubey91/NareshMVC5App/main/Microsoft.WebApplication.targets
                )

                echo === Building and Publishing the MVC5 App ===
                "%%MSBUILD_PATH%%" NareshMVC5App\\NareshMVC5App.csproj ^
                    /p:Configuration=Release ^
                    /p:DeployOnBuild=true ^
                    /p:WebPublishMethod=FileSystem ^
                    /p:PublishProvider=FileSystem ^
                    /p:PublishDir=C:\\PublishedApp\\ ^
                    /p:VisualStudioVersion=14.0 ^
                    /target:PipelinePreDeployCopyAllFilesToOneFolder
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                echo === Deploying to IIS ===
                xcopy /s /e /y "C:\\PublishedApp\\*" "C:\\inetpub\\wwwroot\\NareshMVC5App\\"
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
