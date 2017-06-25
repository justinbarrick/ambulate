FROM abaez/luarocks:lua5.1

RUN apk update && apk add --no-progress git

RUN luarocks install luaunit && luarocks install luasec
WORKDIR /src
ADD . /src

CMD lua tests/test_ambulator.lua -v
