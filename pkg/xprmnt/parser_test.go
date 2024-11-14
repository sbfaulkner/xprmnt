package xprmnt

import (
	"testing"
)

func TestParser(t *testing.T) {
	tests := []struct {
		input    string
		expected float64
	}{
		{"1 + 2", 3},
		{"3 - 2", 1},
		{"2 * 3", 6},
		{"6 / 2", 3},
		{"2 + 3 * 4", 14},
		{"6 / 2 + 1", 4},
	}

	for i, tt := range tests {
		lexer := newLexer(tt.input)
		parser := newParser(lexer)

		result, err := parser.Parse()
		if err != nil {
			t.Errorf("tests[%d] - unexpected error: %v", i, err)
			continue
		}

		if result != tt.expected {
			t.Errorf("tests[%d] - wrong result. expected=%v, got=%v",
				i, tt.expected, result)
		}
	}
}
