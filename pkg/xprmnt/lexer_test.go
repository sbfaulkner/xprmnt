package xprmnt

import (
	"testing"
)

func TestLexer_NextToken(t *testing.T) {
	input := "+"
	lexer := newLexer(input)

	tests := []struct {
		expectedType  TokenType
		expectedValue string
	}{
		{PLUS, "+"},
		{EOF, ""},
	}

	for i, tt := range tests {
		token := lexer.NextToken()
		
		if token.Type != tt.expectedType {
			t.Errorf("tests[%d] - wrong token type. expected=%d, got=%d",
				i, tt.expectedType, token.Type)
		}

		if token.Value != tt.expectedValue {
			t.Errorf("tests[%d] - wrong token value. expected=%q, got=%q",
				i, tt.expectedValue, token.Value)
		}
	}
}

