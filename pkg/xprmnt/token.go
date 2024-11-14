package xprmnt

import (
	"fmt"
)

type TokenType int

const (
	EOF     TokenType = -1
	INVALID TokenType = iota
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
	case LPAREN:
		return "LPAREN"
	case RPAREN:
		return "RPAREN"
	default:
		panic(fmt.Errorf("unknown token type: %d", tt))
	}
}
