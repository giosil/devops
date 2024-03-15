FROM eclipse-temurin:11

RUN mkdir -p /etc/cas

COPY cas /etc/cas

COPY cas.war /root

EXPOSE 8444

ENTRYPOINT ["/opt/java/openjdk/bin/java", "-jar", "/root/cas.war"]
