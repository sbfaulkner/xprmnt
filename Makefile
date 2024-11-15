.PHONY: all
all: generate build test test-c test-ruby

.PHONY: build
build: bin/xprmnt

bin/xprmnt: generate
	go build -o $@ ./cmd/xprmnt

.PHONY: generate
generate: pkg/xprmnt/lexer.go pkg/xprmnt/parser.go

pkg/xprmnt/parser.go: pkg/xprmnt/parser.y
	goyacc -o $@ $<

pkg/xprmnt/lexer.go: pkg/xprmnt/lexer.rl
	ragel -Z -G2 -o $@ $<

.PHONY: clean
clean:
	rm -f pkg/xprmnt/lexer.go pkg/xprmnt/parser.go bin/xprmnt bin/test-c

.PHONY: test
test: generate
	go test ./... -v

.PHONY: shared
shared: generate
	mkdir -p lib
	go build -buildmode=c-shared -o lib/libxprmnt.so ./pkg/libxprmnt

.PHONY: install
install: shared
	cp lib/libxprmnt.so /usr/local/lib/
	cp include/xprmnt.h /usr/local/include/

.PHONY: test-c
test-c: shared
	mkdir -p bin
	gcc -o bin/test-c examples/c/test.c -L./lib -I./include -lxprmnt
	DYLD_LIBRARY_PATH=./lib ./bin/test-c

.PHONY: test-ruby
test-ruby: shared
	DYLD_LIBRARY_PATH=./lib ruby examples/ruby/test.rb
