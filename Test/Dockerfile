FROM ubuntu:latest

RUN apt update

# Instala Python y pip
RUN apt install -y python3 python3-pip

WORKDIR /usr/app/src

COPY requirements.txt ./

RUN pip install -r requirements.txt

COPY print.py ./

CMD [ "python3", "./print.py" ]