# Define platforms and architectures
CURRENT_OS := $(shell go env GOOS)
CURRENT_ARCH := $(shell go env GOARCH)

# Output directories
DIST_DIR = dist

# Base names
LIB_NAME = libxprmnt

.PHONY: all
all: test test-c test-ruby build

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

.PHONY: shared-darwin-amd64
shared-darwin-amd64: generate
	@if [ "$(CURRENT_OS)" = "darwin" ]; then \
		mkdir -p $(DIST_DIR)/$@ && \
		GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 \
		go build -buildmode=c-shared \
			-o $(DIST_DIR)/$@/$(LIB_NAME).dylib \
			./pkg/libxprmnt; \
	else \
		echo "Skipping darwin-amd64 build on non-macOS system"; \
	fi

.PHONY: shared-darwin-arm64
shared-darwin-arm64: generate
	@if [ "$(CURRENT_OS)" = "darwin" ]; then \
		mkdir -p $(DIST_DIR)/$@ && \
		GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 \
		go build -buildmode=c-shared \
			-o $(DIST_DIR)/$@/$(LIB_NAME).dylib \
			./pkg/libxprmnt; \
	else \
		echo "Skipping darwin-arm64 build on non-macOS system"; \
	fi

.PHONY: shared-linux-amd64
shared-linux-amd64: generate
	@if [ "$(CURRENT_OS)" = "linux" ]; then \
		mkdir -p $(DIST_DIR)/$@ && \
		GOOS=linux GOARCH=amd64 CGO_ENABLED=1 \
		go build -buildmode=c-shared \
			-o $(DIST_DIR)/$@/$(LIB_NAME).so \
			./pkg/libxprmnt; \
	else \
		echo "Skipping linux-amd64 build on non-Linux system"; \
	fi

.PHONY: shared-linux-arm64
shared-linux-arm64: generate
	@if [ "$(CURRENT_OS)" = "linux" ]; then \
		mkdir -p $(DIST_DIR)/$@ && \
		GOOS=linux GOARCH=arm64 CGO_ENABLED=1 \
		go build -buildmode=c-shared \
			-o $(DIST_DIR)/$@/$(LIB_NAME).so \
			./pkg/libxprmnt; \
	else \
		echo "Skipping linux-arm64 build on non-Linux system"; \
	fi

.PHONY: shared-all
shared-all: shared-darwin-amd64 shared-darwin-arm64 shared-linux-amd64 shared-linux-arm64

.PHONY: clean
clean:
	rm -rf $(DIST_DIR)
	rm -f pkg/xprmnt/lexer.go pkg/xprmnt/parser.go bin/xprmnt bin/test-c

.PHONY: test
test: generate
	go test ./... -v

.PHONY: test-c
test-c: shared-$(CURRENT_OS)-$(CURRENT_ARCH)
	mkdir -p bin
	gcc -o bin/test-c examples/c/test.c -L./dist/shared-$(CURRENT_OS)-$(CURRENT_ARCH) -I./include -lxprmnt
	@if [ "$(CURRENT_OS)" = "darwin" ]; then \
		DYLD_LIBRARY_PATH=./dist/shared-$(CURRENT_OS)-$(CURRENT_ARCH) ./bin/test-c; \
	else \
		LD_LIBRARY_PATH=./dist/shared-$(CURRENT_OS)-$(CURRENT_ARCH) ./bin/test-c; \
	fi

.PHONY: test-ruby
test-ruby: shared-$(CURRENT_OS)-$(CURRENT_ARCH)
	@if [ "$(CURRENT_OS)" = "darwin" ]; then \
		DYLD_LIBRARY_PATH=./dist/shared-$(CURRENT_OS)-$(CURRENT_ARCH) ruby examples/ruby/test.rb; \
	else \
		LD_LIBRARY_PATH=./dist/shared-$(CURRENT_OS)-$(CURRENT_ARCH) ruby examples/ruby/test.rb; \
	fi
