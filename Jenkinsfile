pipeline {
    agent { label 'windows' }

    environment {
        MSBUILD_PATH = 'C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe'
        PUBLISH_DIR = 'C:\\PublishedApp\\'
        IIS_DIR = 'C:\\inetpub\\wwwroot\\NareshMVC5App\\'
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
                set "MSBUILD_PATH=%MSBUILD_PATH%"

                if not exist "%MSBUILD_PATH%" (
                    echo ERROR: MSBuild not found at %MSBUILD_PATH%
                    exit /b 1
                )
                echo MSBuild found at %MSBUILD_PATH%

                echo === Ensure Microsoft.WebApplication.targets workaround ===
                set "WEBAPP_DIR=C:\\Program Files (x86)\\MSBuild\\Microsoft\\VisualStudio\\v14.0\\WebApplications"
                set "WEBAPP_TARGETS=%WEBAPP_DIR%\\Microsoft.WebApplication.targets"

                if not exist "%WEBAPP_TARGETS%" (
                    echo Creating workaround targets folder...
                    mkdir "%WEBAPP_DIR%"
                    curl -L -o "%WEBAPP_TARGETS%" https://raw.githubusercontent.com/rahulchaubey91/NareshMVC5App/main/Microsoft.WebApplication.targets
                )

                echo === Building and Publishing the MVC5 App ===
                "%MSBUILD_PATH%" NareshMVC5App\\NareshMVC5App.csproj ^
                  /p:Configuration=Release ^
                  /p:Platform="Any CPU" ^
                  /p:DeployOnBuild=true ^
                  /p:WebPublishMethod=FileSystem ^
                  /p:PublishProvider=FileSystem ^
                  /p:PublishDir=%PUBLISH_DIR% ^
                  /p:VisualStudioVersion=14.0 ^
                  /target:PipelinePreDeployCopyAllFilesToOneFolder
                '''
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                echo === Copying files to IIS directory ===
                if not exist "%PUBLISH_DIR%*" (
                    echo ERROR: No files found in publish directory: %PUBLISH_DIR%
                    exit /b 1
                )

                mkdir "%IIS_DIR%" >nul 2>&1

                xcopy /s /e /y "%PUBLISH_DIR%*" "%IIS_DIR%"

                echo === Restarting IIS ===
                where iisreset >nul 2>&1
                if %errorlevel%==0 (
                    iisreset
                ) else (
                    echo WARNING: 'iisreset' not found. Make sure IIS is installed and available in PATH.
                )
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Skipping for now or add your docker build step here.'
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Skipping for now or add your docker push step here.'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
