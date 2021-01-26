FROM alpine
WORKDIR /srv/streamlink-service
ENV COLUMNS=116
ENV PORT=8000
EXPOSE $PORT
ADD main.py .
RUN apk update &&                                                                     \
    apk add python3 py-pip uwsgi-python uwsgi-http py-flask gcc musl-dev ffmpeg curl; \
    pip3 install streamlink;                                                          \
    apk del gcc musl-dev;                                                             \
    rm -vfr /root/.cache /var/cache/apk/*
CMD uwsgi --http-socket 0.0.0.0:$PORT \
          --plugin python,http        \
          --wsgi-file main.py         \
          --lock-engine ipcsem        \
          --callable app              \
          --workers 4                 \
          --threads 4                 \
          --uid uwsgi                 \
          --vacuum                    \
          --disable-logging           \
          --die-on-term               \
          --master
