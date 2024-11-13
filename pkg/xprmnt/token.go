package xprmnt

import (
	"fmt"
)

type TokenType int

const (
    EOF     TokenType = -1
    INVALID TokenType = iota
    NUMBER
    PLUS
    MINUS
    MULTIPLY
    DIVIDE
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
	case PLUS:
		return "PLUS"
	default:
		panic(fmt.Errorf("Unknown token type: %d", tt))
	}
}
