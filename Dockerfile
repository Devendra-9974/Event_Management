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

# Disable Tomcat's shutdown port (-1 disables the shutdown socket completely so it never binds to TCP)
RUN sed -i 's/<Server port="8005"/<Server port="-1"/' /usr/local/tomcat/conf/server.xml

# Copy packaged application as ROOT.war so it is mounted at root context path /
COPY --from=builder /app/target/aryaClgClubSphere.war /usr/local/tomcat/webapps/ROOT.war

# Default fallback port for local container testing
ENV PORT=8080
EXPOSE 8080

# Launch Tomcat:
# 1. Guarantee shutdown port is disabled (-1) so no shutdown socket exists in container
# 2. Dynamically bind HTTP Connector to Render's $PORT (fallback 8080)
# 3. Start Tomcat in foreground
CMD ["sh", "-c", "sed -i 's/<Server port=\"[0-9]*\"/<Server port=\"-1\"/' /usr/local/tomcat/conf/server.xml && sed -i 's/Connector port=\"[0-9]*\"/Connector port=\"'\"${PORT:-8080}\"'\"/' /usr/local/tomcat/conf/server.xml && catalina.sh run"]
