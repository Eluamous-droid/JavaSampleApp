FROM java:8-jdk-alpine
COPY ./build/libs/JavaSampleApp* /usr/app/
WORKDIR /usr/app
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "JavaSampleApp*"]