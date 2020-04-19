# Step : Test and package
FROM 3.6.3-jdk-11-slim as target
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src/ /build/src/
RUN mvn package

# Step : Package image
FROM openjdk:11.0.4-jre-slim-buster
EXPOSE 8080
CMD exec java $JAVA_OPTS -jar /app/my-app.jar
COPY --from=target /build/target/chat-0.0.1-SNAPSHOT.jar /app/chat.jar
ENTRYPOINT ["java","-jar","/app/chat.jar"]
