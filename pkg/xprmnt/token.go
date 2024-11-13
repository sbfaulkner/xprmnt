package xprmnt

import (
	"fmt"
)

type TokenType int

const (
    EOF     TokenType = -1
    INVALID TokenType = iota
    NUMBER
    MULTIPLY
    DIVIDE
    PLUS
    MINUS
    LPAREN
    RPAREN
)

type Token struct {
    Type  TokenType
    Value string
}

func (tt TokenType) String() string {
	switch tt {
	case INVALID:
		return "INVALID"
	case EOF:
		return "EOF"
	case NUMBER:
		return "NUMBER"
	case MULTIPLY:
		return "MULTIPLY"
	case DIVIDE:
		return "DIVIDE"
	case PLUS:
		return "PLUS"
	case MINUS:
		return "MINUS"
	default:
		panic(fmt.Errorf("Unknown token type: %d", tt))
	}
}
