package main

import (
	"fmt"
	"io"
	"os"
	"xprmnt/pkg/xprmnt"
)

func main() {
	in, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(fmt.Errorf("unable to read stdin: %w", err))
	}

	result, err := xprmnt.Parse(string(in))
	if err != nil {
		panic(fmt.Errorf("unable to parse input: %w", err))
	}

	fmt.Println(result)
}
