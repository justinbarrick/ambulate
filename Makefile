LUA_PATH=$(shell lua -e 'print("/src/opencomputers/?.lua;" .. package.path)')
LUA=LUA_PATH="$(LUA_PATH)" lua

.PHONY: build
build:
	docker build -f build/Dockerfile -t ambulator .

.PHONY: test
test:
	docker run --rm -v $(shell pwd):/src ambulator make run-tests
    
.PHONY: run-tests
run-tests:
	$(LUA) tests/test_navigation.lua -v
	$(LUA) build/install-ambulator.lua -v
	$(LUA) tests/test_ambulator.lua -v
	$(LUA) tests/test_internet.lua -v
	$(LUA) ambulator.lua 0 2
	$(LUA) ambulator.lua list
	$(LUA) ambulator.lua waypoint1
