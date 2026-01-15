# Stage 1: Build the JAR
FROM maven:3.9.2-eclipse-temurin-17 AS build

WORKDIR /app

# Copy only pom.xml first to download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src

# Build the JAR (skip tests to speed up)
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Set environment variable for API key (can also set in Render dashboard)
ENV WEATHER_API_KEY b09ccde6ecc04551811212248260501

# Run the app
ENTRYPOINT ["java","-jar","/app/app.jar"]
