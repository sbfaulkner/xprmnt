.PHONY: all
all: generate build

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
	rm -f pkg/xprmnt/lexer.go pkg/xprmnt/parser.go bin/xprmnt

.PHONY: test
test: generate
	go test ./... -v
