# Add ragel generation to the generate target
.PHONY: generate
generate: pkg/xprmnt/lexer.go

# Rule to generate lexer.go from lexer.rl
pkg/xprmnt/lexer.go: pkg/xprmnt/lexer.rl
	ragel -Z -G2 -o $@ $<

# Add lexer.go to clean target
.PHONY: clean
clean:
	rm -f pkg/xprmnt/lexer.go

.PHONY: test
test:
	go test ./...

.PHONY: test-gen
test-gen: generate
	go test ./...
