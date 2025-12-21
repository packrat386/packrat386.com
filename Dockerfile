FROM caddy:2-alpine

COPY out/ /srv/

WORKDIR /srv

EXPOSE 8080

CMD ["caddy", "file-server", "--listen", "0.0.0.0:8080"]
