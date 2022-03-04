# Alpine is chosen for its small footprint
# compared to Ubuntu
FROM golang:1.17 AS build_base

LABEL maintainer="jose.ramirez@kpn.com"

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -v -o /checkcerts 


## Deploy image

FROM  golang:1.17-alpine

WORKDIR /app

COPY --from=build_base  /checkcerts .

COPY hosts .
COPY run.sh .
# CMD [ "./checkcerts --hosts="./hosts"" ] 
RUN chmod +x ./run.sh

# RUN apk add bash
# CMD [ "./checkcerts --hosts="./hosts"" ]
CMD [ "./run.sh" ]

