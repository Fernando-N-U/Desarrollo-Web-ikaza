# Etapa 1: Render usa Maven para compilar tu proyecto
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Etapa 2: Render enciende Tomcat y coloca tu proyecto
FROM tomcat:10-jdk17
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war