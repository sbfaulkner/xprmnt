.PHONY: generate
generate: pkg/xprmnt/lexer.go pkg/xprmnt/parser.go

pkg/xprmnt/parser.go: pkg/xprmnt/parser.y
	goyacc -o $@ $<

pkg/xprmnt/lexer.go: pkg/xprmnt/lexer.rl
	ragel -Z -G2 -o $@ $<

.PHONY: clean
clean:
	rm -f pkg/xprmnt/lexer.go

.PHONY: test
test: generate
	go test ./...
