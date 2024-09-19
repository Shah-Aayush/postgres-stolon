ARG PGVERSION

# base build image
FROM golang:1.16-buster AS build_base

RUN echo "Debug1: Printing current directory contents"
RUN pwd
RUN ls -la

WORKDIR /stolon

# only copy go.mod and go.sum
# COPY go.mod .
# COPY go.sum .

RUN echo "Debug2: Printing current directory contents"
RUN pwd
RUN ls -la

# RUN go mod download

#######
####### Build the stolon binaries
#######

RUN echo "Debug3: Printing current directory contents"
RUN pwd
RUN ls -la


FROM build_base AS builder

RUN echo "Debug4: Printing current directory contents"
RUN pwd
RUN ls -la

# copy all the sources
# COPY . .

RUN echo "Debug5: Printing current directory contents"
RUN pwd
RUN ls -la

# RUN make

RUN echo "Debug6: Printing current directory contents"
RUN pwd
RUN ls -la

#######
####### Build the final image
#######
FROM postgres:15

RUN echo "Debug7: Printing current directory contents"
RUN pwd
RUN ls -la

RUN useradd -ms /bin/bash stolon

RUN echo "Debug8: Printing current directory contents"
RUN pwd
RUN ls -la

EXPOSE 5432

# copy the agola-web dist
COPY --from=builder /stolon/bin/ /usr/local/bin

RUN echo "Debug9: Printing current directory contents"
RUN pwd
RUN ls -la

RUN chmod +x /usr/local/bin/stolon-keeper /usr/local/bin/stolon-sentinel /usr/local/bin/stolon-proxy /usr/local/bin/stolonctl
