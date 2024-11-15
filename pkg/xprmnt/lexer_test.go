package xprmnt

import (
	"testing"
)

func TestLexer(t *testing.T) {
	input := "1 + 2 * 3 / (4 - 5)"
	lexer := newLexer(input)

	tests := []struct {
		expectedType  TokenType
		expectedValue string
	}{
		{NUMBER, "1"},
		{PLUS, "+"},
		{NUMBER, "2"},
		{MULTIPLY, "*"},
		{NUMBER, "3"},
		{DIVIDE, "/"},
		{LPAREN, "("},
		{NUMBER, "4"},
		{MINUS, "-"},
		{NUMBER, "5"},
		{RPAREN, ")"},
		{EOF, ""},
	}

	for i, tt := range tests {
		token := lexer.NextToken()

		if token.Type != tt.expectedType {
			t.Errorf("tests[%d] - wrong token type. expected=%v, got=%v",
				i, tt.expectedType, token.Type)
		}

		if token.Value != tt.expectedValue {
			t.Errorf("tests[%d] - wrong token value. expected=%q, got=%q",
				i, tt.expectedValue, token.Value)
		}
	}
}
