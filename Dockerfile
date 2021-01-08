FROM openjdk:8u212-jre-slim-stretch
ENV KELPIE_VERSION 1.1.0

RUN apt-get update && apt-get install wget unzip -y && \
    wget -O /tmp/kelpie.zip https://github.com/scalar-labs/kelpie/releases/download/${KELPIE_VERSION}/kelpie-${KELPIE_VERSION}.zip && \
    unzip /tmp/kelpie.zip && \
    mv /kelpie-${KELPIE_VERSION}/bin/kelpie /usr/local/bin/kelpie && \
    mv /kelpie-${KELPIE_VERSION}/lib/* /usr/local/lib/ && \
    rm -rf /tmp/kelpie.zip kelpie-${KELPIE_VERSION} /var/lib/apt/lists/*

RUN mkdir -p /lamb/build/libs/

COPY kelpie-lamb-all.jar /lamb/build/libs/
COPY sample-keys /lamb/sample-keys
COPY entrypoint.sh /lamb/

RUN chmod +x /lamb/entrypoint.sh
ENTRYPOINT ["/lamb/entrypoint.sh"]
