.PHONY: build
build:
	docker build -t ambulator .

.PHONY: test
test:
	docker run -v $(shell pwd):/src ambulator
