all:
	rm -rf build
	DOCKER_BUILDKIT=1 docker build --output type=local,dest=. --build-arg PICO_CS_WIFI_SSID="YourWiFiSSID" --build-arg PICO_CS_WIFI_PASSWORD="YourWiFiPassword" --no-cache .
	@echo "reuse (license) check"
	reuse lint

#remove build cache and unused docker images
prune:
	docker builder prune -a -f
	docker image   prune -a -f

#install fsfe reuse tool (https://git.fsfe.org/reuse/tool)
# pre-conditions:
# - Python 3.6+
# - pip
# install pre-conditions in Debian like linux distros:
# - sudo apt install python3
# - sudo apt install python3-pip
reuse:
	pip3 install --user --upgrade reuse
