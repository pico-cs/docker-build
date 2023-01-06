# pico-cs docker-build
[![REUSE status](https://api.reuse.software/badge/github.com/pico-cs/docker-build)](https://api.reuse.software/info/github.com/pico-cs/docker-build)
![](https://github.com/pico-cs/docker-build/workflows/build/badge.svg)

## Why docker-build

As a pico-cs user you might only be interested in installing the neccessary software
- [Pico / Pico W firmware](https://github.com/pico-cs/firmware) and
- the [MQTT gateway](https://github.com/pico-cs/mqtt-gateway)

instead of dealing with the different SDKs and toolchains needed to build on your local environment.

So we are using the nice [Docker build capabilities](https://www.docker.com/) to get things done.

## Usage

To use the pico-cs docker-build you need to have
- [git](https://git-scm.com/) installed on your local computer.
- a running [docker](https://www.docker.com/) environment. For install instructions please consult the [installation](https://docs.docker.com/engine/install/).

After cloning this repository the docker build can be started:

```
git clone https://github.com/pico-cs/docker-build.git
cd docker-build
DOCKER_BUILDKIT=1 docker build --output type=local,dest=. --build-arg PICO_CS_WIFI_SSID="YourWiFiSSID" --build-arg PICO_CS_WIFI_PASSWORD="YourWiFiPassword" --no-cache .
```

Please be aware that the dot at the end is part of the command and please replace the WiFi build arguments SSID and password with your wlan configuration settings. Changing the TCP port is supported via the additional build argument PICO_CS_TCP_PORT (if not defined, the default port 4242 is used):

```
cd docker-build
DOCKER_BUILDKIT=1 docker build --output type=local,dest=. --build-arg PICO_CS_WIFI_SSID="YourWiFiSSID" --build-arg PICO_CS_WIFI_PASSWORD="YourWiFiPassword" --build-arg PICO_CS_TCP_PORT=4242 --no-cache .
```

The build is creating a subdirectory 'build' where the binaries can be found:

```
build/
├── firmware                // firmware
│   ├── cs.uf2              // - Raspberry Pi Pico
│   └── cs_w.uf2            // - Raspberry Pi Pico W
└── gateway                 // MQTT gateway
    ├── darwin
    │   ├── amd64
    │   │   └── gateway     // - MacOS
    │   └── arm64
    │       └── gateway     // - ARM based Mac (M1, M2, ...)
    ├── linux
    │   ├── amd64
    │   │   └── gateway     // - Linux
    │   └── arm64
    │       └── gateway     // - ARM based Linux
    ├── raspos
    │   └── gateway         // - Raspberry Pi OS
    └── windows
        ├── amd64
        │   └── gateway.exe // Windows
        └── arm64
            └── gateway.exe // ARM based Windows
```

## Licensing

Copyright 2021-2022 Stefan Miller and pico-cs contributers. Please see our [LICENSE](LICENSE.md) for copyright and license information. Detailed information including third-party components and their licensing/copyright information is available [via the REUSE tool](https://api.reuse.software/info/github.com/pico-cs/docker-build).

