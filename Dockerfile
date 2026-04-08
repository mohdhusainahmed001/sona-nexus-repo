# Use a lightweight JRE image
FROM eclipse-temurin:17-jre-alpine

# Set working directory
WORKDIR /app

# Copy the jar file that Jenkins built in the target folder
# Note: Ensure the name matches your pom.xml artifactId-version
COPY target/devops-app-1.0-SNAPSHOT.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
