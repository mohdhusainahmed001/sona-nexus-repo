pipeline {
    agent any

    environment {
        // --- Nexus Configuration ---
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        // Use the IP of your Ubuntu machine or Docker gateway (172.17.0.1)
        NEXUS_URL = "10.30.40.102:8081" 
        NEXUS_REPOSITORY = "maven-releases"
        NEXUS_CREDENTIAL_ID = "nexus-creds"
        
        // --- Git Configuration ---
        GIT_CREDENTIAL_ID = "Git"
        REPO_URL = "https://github.com/mohdhusainahmed001/onextel-devops.git"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Cloning repository..."
                git credentialsId: "${GIT_CREDENTIAL_ID}", 
                    url: "${REPO_URL}", 
                    branch: 'main'
            }
        }

        stage('Build & Package') {
            steps {
                echo "Building Java application with Maven..."
                // Ensures we have a clean jar file in the target folder
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Push to Nexus') {
            steps {
                script {
                    echo "Uploading Artifact to Nexus Repository: ${NEXUS_REPOSITORY}"
                    
                    // Automatically reads info from your pom.xml
                    def pom = readMavenPom file: 'pom.xml'
                    
                    nexusArtifactUploader(
                        nexusVersion: "${NEXUS_VERSION}",
                        protocol: "${NEXUS_PROTOCOL}",
                        nexusUrl: "${NEXUS_URL}",
                        groupId: "${pom.groupId}",
                        version: "${pom.version}",
                        repository: "${NEXUS_REPOSITORY}",
                        credentialsId: "${NEXUS_CREDENTIAL_ID}",
                        artifacts: [
                            [artifactId: "${pom.artifactId}",
                             classifier: '',
                             file: "target/${pom.artifactId}-${pom.version}.jar",
                             type: 'jar']
                        ]
                    )
                }
            }
        }
    }

    post {
        success {
            echo "--- Deployment Successful ---"
            echo "Artifact is now available at http://${NEXUS_URL}/#browse/browse:${NEXUS_REPOSITORY}"
        }
        failure {
            echo "--- Deployment Failed ---"
            echo "Please check: 1. Nexus Container status, 2. Network connectivity, 3. 'nexus-creds' permissions."
        }
    }
}
