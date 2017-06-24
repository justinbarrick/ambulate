FROM abaez/luarocks

RUN luarocks install luaunit
WORKDIR /src
ADD . /src

CMD lua test_ambulator.lua -v
