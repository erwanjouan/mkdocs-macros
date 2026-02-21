GO_HTTP_SERVER:=docus-perso-mac

activate:
	python3 -m venv .venv && \
	source .venv/bin/activate

install: activate
	.venv/bin/python3 -m pip install -r requirements.txt

init: install
	.venv/bin/python3 -m mkdocs new .

serve: activate
	.venv/bin/python3 -m mkdocs serve

site-build: activate
	.venv/bin/python3 -m mkdocs build

run: site-build
	docker run -v $$(pwd)/site:/usr/share/nginx/html:ro -p8080:80 nginx

docker_build:
	docker build -t some-content-nginx .

docker_run: docker_build
	docker run --name some-nginx -d -p 8080:80 some-content-nginx

go-build-intel-mac: site-build
	@mv site go/
	@GOOS=darwin GOARCH=amd64 go build -o go/$(GO_HTTP_SERVER)-intel go/main.go
	@rm -rf go/site

go-build: site-build
	@mv site go/
	@go build -o go/$(GO_HTTP_SERVER)-arm go/main.go
	@rm -rf go/site

go-run: go-build
	./$(GO_HTTP_SERVER)
