FROM ubuntu:latest
LABEL maintainer="seglh"
RUN apt-get update && apt-get install -y \
    && apt-get -y install curl \
    && apt-get -y install jq \
    && apt-get -y install yajl-tools \
    && rm -rf /var/lib/apt/lists/*
COPY ./main.sh /
RUN chmod +x /main.sh
ENTRYPOINT ["/main.sh"]
CMD ["path", "pw", "job_name", "protocol_id"]