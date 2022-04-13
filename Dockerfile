FROM golang:1.17.8-alpine3.15 as builder

RUN apk add make gcc musl-dev binutils-gold

COPY ./test-plugin/ /test-plugin
RUN cd /test-plugin && go build -buildmode=plugin -o test-plugin.so .


FROM devopsfaith/krakend:2

COPY --from=builder /test-plugin/test-plugin.so /etc/krakend/plugins/
COPY krakend.json /etc/krakend/krakend.json

EXPOSE 8080
CMD ["run", "-c", "/etc/krakend/krakend.json"]
