docker_build:
	docker build . -t docker-wine-x11-novnc

docker_run:
	docker run -p 8080:8080 -p 5900:5900 \
	-v $(PWD):/src \
	-v /home/hldias/Downloads:/downloads \
	docker-wine-x11-novnc

docker_rm_all:
	docker ps -qa | xargs docker rm -f
