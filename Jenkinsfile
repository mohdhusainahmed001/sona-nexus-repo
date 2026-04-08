pipeline {
    agent any
    
    tools {
        // This MUST match the name you gave in Manage Jenkins -> Tools
        maven 'Maven3' 
    }

    environment {
        // --- Nexus Configuration Updated ---
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "10.30.40.102:9000" 
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
                echo "Building Java application..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Push to Nexus') {
            steps {
                script {
                    echo "Uploading Artifact to Nexus at ${NEXUS_URL}"
                    
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
            echo "Successfully deployed to: http://${NEXUS_URL}"
        }
        failure {
            echo "Deployment failed. Please verify if http://10.30.40.102:9000 is reachable from the Jenkins server."
        }
    }
}
