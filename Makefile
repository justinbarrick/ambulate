.PHONY: build
build:
	docker build -f build/Dockerfile -t ambulator .

.PHONY: test
test:
	docker run -v $(shell pwd):/src ambulator
