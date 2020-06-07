FROM java:8-jdk-alpine
COPY app.jar /usr/app/
WORKDIR /usr/app
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]