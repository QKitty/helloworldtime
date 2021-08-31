FROM docker.devops.stp.hmlr.zone/gradle:6.7.1-jdk11 AS build
COPY --chown=gradle:gradle . /home/gradle/src

# We can't use the root user to run the embedded postgres instance for the integration tests
USER gradle

WORKDIR /home/gradle/src

#RUN gradle build bootJar --no-daemon -x checkstyleMain -x checkstyleTest -x spotbugsMain -x spotbugsTest -x jacocoTestCoverageVerification
RUN gradle jar

FROM docker.devops.stp.hmlr.zone/hmlandregistry/dev_base_java:5.1-11

RUN mkdir /app

COPY --from=build /home/gradle/src/build/libs/HelloWorldTime-1.0-SNAPSHOT.jar /app/HelloWorldTime.jar

#Insane to do this just to see file structure...
#RUN mkdir /tmp/build/
# Add context to /tmp/build/
#COPY . /tmp/build/

#ENV APP_NAME=correspondence-data-ms \
#    LOG_LEVEL=DEBUG \
#    SERVER_PORT=8080 \
#    APPLICATION_VALIDATE_RECIPIENT_ADDRESSES=false \
#    SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/correspondence_data \
#    SPRING_DATASOURCE_USERNAME=correspondence_data_app \
#    SPRING_DATASOURCE_PASSWORD=password \
#    SPRING_FLYWAY_URL=jdbc:postgresql://postgres:5432/correspondence_data \
#    SPRING_FLYWAY_USER=correspondence_data \
#    SPRING_FLYWAY_PASSWORD=password \
#    CORRESPONDENCE_TYPES_URL=http://correspondence-types-ms:8080 \
#    CORRESPONDENCE_ITEMS_URL=http://correspondence-items-ms:8080 \
#    SPRING_RABBITMQ_HOST=rabbitmq \
#    CHECK_PROXY_API_URL=http://check-proxy:8080

ENTRYPOINT ["java", "-Xms50m", "-Xmx150m", "-jar","/app/HelloWorldTime.jar"]
