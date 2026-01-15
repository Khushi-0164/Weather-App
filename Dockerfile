# Stage 1 – Build the app
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Copy Maven files
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
RUN chmod +x mvnw

# Download dependencies (cached)
RUN ./mvnw dependency:go-offline

# Copy source code
COPY src ./src

# Build jar
RUN ./mvnw clean package -DskipTests

# Stage 2 – Run the app
FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
