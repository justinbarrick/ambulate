.PHONY: build
build:
	docker build -f build/Dockerfile -t ambulator .

.PHONY: test
test:
	docker run -v $(shell pwd):/src ambulator lua build/install-ambulator.lua -v
	docker run -v $(shell pwd):/src ambulator lua tests/test_ambulator.lua -v
	docker run -v $(shell pwd):/src ambulator lua tests/test_internet.lua -v
