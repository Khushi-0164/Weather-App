# Stage 1: Build the JAR using Maven
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml first (for caching dependencies)
COPY pom.xml .
COPY src ./src

# Build the JAR (skip tests to speed up)
RUN mvn clean package -DskipTests

# Stage 2: Run the app
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port Spring Boot runs on
EXPOSE 8080

# Start the app
ENTRYPOINT ["java","-jar","/app.jar"]

