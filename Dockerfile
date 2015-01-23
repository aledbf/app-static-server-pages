FROM golang:1.4

CMD /go/bin/app-server-errors

EXPOSE 5000

RUN go get github.com/tools/godep

WORKDIR /go/src/github.com/aledbf/app-server-errors

ADD . /go/src/github.com/aledbf/app-server-errors

RUN CGO_ENABLED=0 godep go build -a -ldflags '-s' /go/src/github.com/aledbf/app-server-errors/main.go

RUN cp main /go/bin/app-server-errors
