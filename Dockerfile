FROM golang:1.4

CMD /go/bin/app-server-errors

EXPOSE 5000

RUN go get github.com/tools/godep

WORKDIR /go/src/github.com/aledbf/app-server-errors

ADD . /go/src/github.com/aledbf/app-server-errors

RUN CGO_ENABLED=0 godep go build -a -installsuffix cgo -ldflags '-s' .

RUN cp app-server-errors /go/bin/app-server-errors

