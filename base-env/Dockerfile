FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    openssh-server \
    sudo \
    curl \
    wget \
    git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Jupyter
RUN pip3 install --no-cache-dir \
    jupyter 

WORKDIR /opt/notebooks