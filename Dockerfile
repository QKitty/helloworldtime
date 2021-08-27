FROM openjdk:11
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN brew install gradle
RUN gradle jar
ENTRYPOINT ["java", "-jar", "/usr/src/myapp/build/libs/HelloWorldTime-1.0-SNAPSHOT.jar"]
