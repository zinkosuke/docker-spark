FROM openjdk:8-jre-slim

ARG HADOOP_VERSION=3.2.2
ARG SPARK_VERSION=3.1.1

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV SPARK_HOME=/opt/spark
ENV SPARK_CONF_DIR=${SPARK_HOME}/conf
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}$:${HADOOP_HOME}/lib/native
ENV PATH=${PATH}:${HADOOP_HOME}/bin:${SPARK_HOME}/bin

RUN set -eux \
 && apt-get update -yqq \
 && apt-get upgrade -yqq \
 && apt-get install -yqq --no-install-recommends \
        gnupg \
        wget \
 && echo "deb https://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list \
 && wget -q -O- --tries=10 --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 \
        "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" \
    | apt-key add \
 && apt-get update -yqq \
 && apt-get install -yqq --no-install-recommends \
        sbt \
 && useradd -ms /bin/bash hadoop \
 && useradd -ms /bin/bash spark \
 && wget -q -O- --tries=10 --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 \
        "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    | tar xz -C /opt/ \
 && rm -rf ${HADOOP_HOME}/share/doc \
 && chown -R hadoop:hadoop ${HADOOP_HOME} \
 && mkdir ${SPARK_HOME} \
 && wget -q -O- --tries=10 --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 \
        "http://mirrors.advancedhosters.com/apache/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION%.*}.tgz" \
    | tar xz --strip 1 -C ${SPARK_HOME}/ \
 && chown -R spark:spark ${SPARK_HOME}

WORKDIR ${SPARK_HOME}
USER spark
