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
		{"2 + 3 * 4", 14}, // Without precedence this would be 20
		{"6 / 2 + 1", 4},
		{"(2 + 3) * 4", 20},       // Without parentheses this would be 14
		{"2 * (3 + 4)", 14},       // Without parentheses this would be 10
		{"(1 + 2) * (3 + 4)", 21}, // Without parentheses this would be 11
		{"10 / (2 + 3)", 2},       // Without parentheses this would be 8
		{"1 + 2 ", 3},             // Trailing whitespace should be ok
		{"-5", -5},                // Simple negation
		{"-2 + 3", 1},             // Negation with addition
		{"2 * -3", -6},            // Negation with multiplication
		{"-(2 + 3)", -5},          // Negation of parenthesized expression
		{"-(-5)", 5},              // Double negation
		{"2 + -3 * 4", -10},       // Negation with operator precedence
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

func TestParser_DivideByZero(t *testing.T) {
	tests := []struct {
		input       string
		expectError bool
	}{
		{"1 / 0", true},
		{"2 / (1 - 1)", true},
		{"1 / 2", false},
	}

	for i, tt := range tests {
		_, err := Parse(tt.input)

		if tt.expectError && err == nil {
			t.Errorf("tests[%d] - expected error for input %q, got none", i, tt.input)
		}

		if !tt.expectError && err != nil {
			t.Errorf("tests[%d] - unexpected error for input %q: %v", i, tt.input, err)
		}

		if tt.expectError && err != nil && err.Error() != "divide by zero" {
			t.Errorf("tests[%d] - wrong error message. expected=%q, got=%q",
				i, "divide by zero", err.Error())
		}
	}
}

func TestParser_ParenthesesErrors(t *testing.T) {
	tests := []struct {
		input       string
		expectedErr string
	}{
		{"(1 + 2", "unclosed parenthesis"},
		{"1 + 2)", "unexpected closing parenthesis"},
		{"((1 + 2)", "unclosed parenthesis"},
		{"(1 + 2))", "unexpected closing parenthesis"},
		{"(1 + 2) * 3", ""}, // Valid expression
	}

	for i, tt := range tests {
		_, err := Parse(tt.input)

		if tt.expectedErr == "" && err != nil {
			t.Errorf("tests[%d] - unexpected error for input %q: %v",
				i, tt.input, err)
			continue
		}

		if tt.expectedErr != "" && err == nil {
			t.Errorf("tests[%d] - expected error for input %q, got none",
				i, tt.input)
			continue
		}

		if tt.expectedErr != "" && err != nil && err.Error() != tt.expectedErr {
			t.Errorf("tests[%d] - wrong error message for input %q. expected=%q, got=%q",
				i, tt.input, tt.expectedErr, err.Error())
		}
	}
}

func TestParser_InvalidExpression(t *testing.T) {
	tests := []struct {
		input       string
		expectedErr string
	}{
		{"1 + + 2", "invalid expression"},
		{"1 2", "invalid expression"},
	}

	for i, tt := range tests {
		_, err := Parse(tt.input)

		if tt.expectedErr == "" && err != nil {
			t.Errorf("tests[%d] - unexpected error for input %q: %v",
				i, tt.input, err)
			continue
		}

		if tt.expectedErr != "" && err == nil {
			t.Errorf("tests[%d] - expected error for input %q, got none",
				i, tt.input)
			continue
		}

		if tt.expectedErr != "" && err != nil && err.Error() != tt.expectedErr {
			t.Errorf("tests[%d] - wrong error message for input %q. expected=%q, got=%q",
				i, tt.input, tt.expectedErr, err.Error())
		}
	}
}
