FROM debian:jessie

WORKDIR /src

RUN apt-get update && apt-get install -y luarocks
RUN luarocks install luaunit

ADD . /src
CMD lua test_ambulator.lua -v
