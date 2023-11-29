FROM amazoncorretto:21-alpine
RUN apk add --no-cache maven
ENV PATH $PATH:/usr/share/maven/bin
WORKDIR /api
COPY pom.xml /api
COPY . /api
RUN mvn clean install
EXPOSE 8080
CMD ["java", "-jar", "/api/target/words.jar"]


