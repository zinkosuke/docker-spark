#!/bin/sh

usage() {
    cat << EOS
Usage: ./runserver.sh <command> [options]

Commands:
  master: Start master.
  worker: Start worker.

Environment variables:
  SPARK_HOME: Spark home directory (required).
EOS
    exit 1
}

[ "${SPARK_HOME}" = "" ] && usage

case "${1}" in
    master)
        shift 1
        exec "${SPARK_HOME}/bin/spark-class" "org.apache.spark.deploy.master.Master" "$@"
        ;;
    worker)
        shift 1
        exec "${SPARK_HOME}/bin/spark-class" "org.apache.spark.deploy.worker.Worker" "$@"
        ;;
    *)
        usage
        ;;
esac
