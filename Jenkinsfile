pipeline {
    agent { label 'windows' }

    environment {
        MSBUILD_PATH = '"C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe"'
        PUBLISH_DIR = "C:\\PublishedApp\\NareshMVC5App\\"
        IIS_SITE_PATH = "C:\\inetpub\\wwwroot\\NareshMVC5App\\"
        DOCKER_PATH = '"C:\\Program Files\\Docker\\docker.exe"'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/rahulchaubey91/NareshMVC5App.git'
            }
        }

        stage('Build and Publish') {
            steps {
                bat '''
                echo === Checking MSBUILD path ===
                if not exist %MSBUILD_PATH% (
                    echo ERROR: MSBuild not found at %MSBUILD_PATH%
                    exit /b 1
                )

                echo === Creating Publish Directory if not exists ===
                if not exist "%PUBLISH_DIR%" mkdir "%PUBLISH_DIR%"

                echo === Building with MSBuild ===
                %MSBUILD_PATH% NareshMVC5App\\NareshMVC5App.csproj ^
                    /p:Configuration=Release ^
                    /p:DeployOnBuild=true ^
                    /p:WebPublishMethod=FileSystem ^
                    /p:PublishDir=%PUBLISH_DIR% ^
                    /p:VisualStudioVersion=14.0

                echo === Removing unnecessary files to reduce Docker image size ===
                del /q /s "%PUBLISH_DIR%*.pdb"
                del /q /s "%PUBLISH_DIR%*.xml"
                del /q /s "%PUBLISH_DIR%*.config"
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                echo === Copying Published Files to IIS ===
                if exist "%PUBLISH_DIR%" (
                    xcopy /E /Y /I "%PUBLISH_DIR%" "%IIS_SITE_PATH%"
                ) else (
                    echo ERROR: Publish directory "%PUBLISH_DIR%" does not exist.
                    exit /b 1
                )
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (fileExists('Dockerfile')) {
                        bat '''
                        echo === Copying publish content to Docker context ===
                        xcopy /E /Y /I "%PUBLISH_DIR%" .

                        echo === Building Docker image ===
                        %DOCKER_PATH% build -t nareshmvc5app .
                        '''
                    } else {
                        echo 'Skipping Docker build: Dockerfile not found.'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            when {
                expression { fileExists('Dockerfile') }
            }
            steps {
                bat '%DOCKER_PATH% push nareshmvc5app'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
