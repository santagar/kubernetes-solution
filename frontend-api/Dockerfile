FROM openjdk:8-jdk-alpine
ENV MICROSERVICE_URL http://localhost:5000
ADD target/frontend-api-0.0.1-SNAPSHOT.jar /
EXPOSE 8080
CMD ["java", "-jar", "frontend-api-0.0.1-SNAPSHOT.jar", "--endpoints.microservice.url=${MICROSERVICE_URL}"]
