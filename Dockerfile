## build Go executables
FROM golang:1.19-alpine as go-build

## create repo directory
RUN mkdir -p /pico/pico-cs

## install git
RUN apk update && apk upgrade && apk add git

WORKDIR /pico/pico-cs

## clone repo
RUN git clone -b main https://github.com/pico-cs/mqtt-gateway.git

WORKDIR /pico/pico-cs/mqtt-gateway/cmd/gateway

## build for target os architecture
RUN GOOS=linux   GOARCH="amd64" go build -v -o /build/linux/amd64/
RUN GOOS=linux   GOARCH="arm64" go build -v -o /build/linux/arm64/
RUN GOOS=darwin  GOARCH="amd64" go build -v -o /build/darwin/amd64/
RUN GOOS=darwin  GOARCH="arm64" go build -v -o /build/darwin/arm64/
RUN GOOS=windows GOARCH="amd64" go build -v -o /build/windows/amd64/
RUN GOOS=windows GOARCH="arm64" go build -v -o /build/windows/arm64/
### Raspberry Pi on Raspberry Pi OS
RUN GOOS=linux GOARCH=arm GOARM=7 go build -v -o /build/raspos/

## build Raspberry Pi Pico firmware
FROM debian as firmware-build

ARG PICO_CS_WIFI_SSID="MyWifiName"
ENV PICO_CS_WIFI_SSID ${PICO_CS_WIFI_SSID}

ARG PICO_CS_WIFI_PASSWORD="MyPassword"
ENV PICO_CS_WIFI_PASSWORD ${PICO_CS_WIFI_PASSWORD}

ARG PICO_CS_TCP_PORT=4242
ENV PICO_CS_TCP_PORT ${PICO_CS_TCP_PORT}

WORKDIR /

## install Raspberry Pi Pico toolchain
RUN su -
RUN apt update
RUN apt install -y git
RUN apt install -y cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential
RUN apt install -y python3
RUN exit

## install SDK
RUN mkdir -p build/firmware
RUN mkdir -p pico
RUN cd pico; git clone -b master https://github.com/raspberrypi/pico-sdk.git
RUN cd pico/pico-sdk; git submodule update --init

## build firmware
RUN mkdir pico/pico-cs
RUN cd pico/pico-cs; git clone -b main https://github.com/pico-cs/firmware.git
RUN mkdir /pico/pico-cs/firmware/src/pico_build
RUN export PICO_SDK_PATH=/pico/pico-sdk; cd /pico/pico-cs/firmware/src/pico_build; cmake .. -DPICO_BOARD=pico; make
RUN mkdir /pico/pico-cs/firmware/src/pico_w_build
RUN export PICO_SDK_PATH=/pico/pico-sdk; cd /pico/pico-cs/firmware/src/pico_w_build; cmake .. -DPICO_BOARD=pico_w; make

## copy to build directory
RUN cp /pico/pico-cs/firmware/src/pico_build/cs.uf2 /build/firmware/
RUN cp /pico/pico-cs/firmware/src/pico_w_build/cs_w.uf2 /build/firmware/

## copy build artefacts to local host
## DOCKER_BUILDKIT=1 docker build --output type=local,dest=. .
FROM scratch as artefact

COPY --from=go-build       /build ./build/
COPY --from=firmware-build /build ./build/
