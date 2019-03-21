FROM python:2.7-alpine
RUN apk update && \
    apk add python python-dev linux-headers libffi-dev gcc make musl-dev py-pip mysql-client git openssl-dev

WORKDIR /opt/CTFd
RUN mkdir -p /opt/CTFd

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . /opt/CTFd
RUN chmod -R 777 /opt/CTFd


VOLUME ["/opt/CTFd"]

RUN for d in CTFd/plugins/*; do \
      if [ -f "$d/requirements.txt" ]; then \
        pip install -r $d/requirements.txt; \
      fi; \
    done;

RUN chmod +x /opt/CTFd/docker-entrypoint.sh

USER 1001

EXPOSE 8080

ENTRYPOINT ["/opt/CTFd/docker-entrypoint.sh"]
