pipeline {
    agent { label 'windows' }

    environment {
        IMAGE_NAME = 'rahulchaubey/mvc5app'
        DOCKERHUB_CREDENTIALS = 'dockerHubWinCred' // Your Jenkins credentials ID
        MSBUILD_PATH = 'C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe'
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
                echo === Checking MSBuild path ===
                set "MSBUILD_PATH=C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe"
                if not exist "%MSBUILD_PATH%" (
                    echo ERROR: MSBuild not found at %MSBUILD_PATH%
                    exit /b 1
                )
                echo MSBuild found at %MSBUILD_PATH%
                "%MSBUILD_PATH%" NareshMVC5App\\NareshMVC5App.csproj /p:Configuration=Release /p:DeployOnBuild=true /p:PublishDir="C:\\PublishedApp\\"
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                echo === Deploying to IIS ===
                if not exist "C:\\PublishedApp\\" (
                    echo ERROR: Publish directory not found!
                    exit /b 1
