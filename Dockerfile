FROM openjdk:8-jdk-alpine
COPY ./target/*.war app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
