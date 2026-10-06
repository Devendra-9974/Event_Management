# Multi-stage Dockerfile for Arya College ClubSphere
# Stage 1: Build the WAR artifact using Maven and Eclipse Temurin JDK 17
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy POM and download dependencies for caching
COPY pom.xml .
RUN mvn dependency:go-offline -B || true

# Copy source code and compile production WAR
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Production runtime with Apache Tomcat 10.1 on JDK 17
FROM tomcat:10.1-jdk17
LABEL maintainer="Arya College of Engineering & IT, Jaipur"

# Clean default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy packaged application as ROOT.war so it is mounted at root context path /
COPY --from=builder /app/target/aryaClgClubSphere.war /usr/local/tomcat/webapps/ROOT.war

# Expose default HTTP port
EXPOSE 8080

# Launch Tomcat
CMD ["catalina.sh", "run"]
