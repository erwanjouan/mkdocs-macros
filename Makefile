GO_HTTP_SERVER:=docus-perso-mac
BIN_FOLDER:=.venv/bin

.ONESHELL:

activate:
	(cd .. && python3 -m venv .venv && \
	source $(BIN_FOLDER)/activate)

install: activate
	(cd .. && $(BIN_FOLDER)/python3 -m pip install -r mkdocs-macros/requirements.txt)

init: install
	(cd .. && $(BIN_FOLDER)/python3 -m mkdocs new .)

serve: activate
	(cd .. && $(BIN_FOLDER)/python3 -m mkdocs serve)

site-build: activate
	(cd .. && $(BIN_FOLDER)/python3 -m mkdocs build)

run: site-build
	(cd .. && docker run -v $$(pwd)/site:/usr/share/nginx/html:ro -p8080:80 nginx)

docker_build:
	(cd .. && docker build -t some-content-nginx .)

docker_run: docker_build
	(cd .. && docker run --name some-nginx -d -p 8080:80 some-content-nginx)

go-build-intel-mac: site-build
	(cd .. && \
	mv site mkdocs-macros/go/ && \
	GOOS=darwin GOARCH=amd64 go build -o mkdocs-macros/go/$(GO_HTTP_SERVER)-intel mkdocs-macros/go/main.go && \
	rm -rf mkdocs-macros/go/site)

go-build: site-build
	(cd .. && \
	mv site mkdocs-macros/go/ && \
	go build -o mkdocs-macros/go/$(GO_HTTP_SERVER)-arm mkdocs-macros/go/main.go && \
	rm -rf mkdocs-macros/go/site)

go-run: go-build
	(cd .. && ./mkdocs-macros/go/$(GO_HTTP_SERVER)-arm)
