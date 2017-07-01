.PHONY: build
build:
	docker build -f build/Dockerfile -t ambulator .

.PHONY: test
test:
	docker run --rm -v $(shell pwd):/src ambulator lua tests/test_navigation.lua -v
	docker run --rm -v $(shell pwd):/src ambulator lua build/install-ambulator.lua -v
	docker run --rm -v $(shell pwd):/src ambulator lua tests/test_ambulator.lua -v
	docker run --rm -v $(shell pwd):/src ambulator lua tests/test_internet.lua -v
	docker run --rm -v $(shell pwd):/src ambulator lua ambulator.lua 0 2 -v
