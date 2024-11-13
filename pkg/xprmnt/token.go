package xprmnt

type TokenType int

const (
    EOF     TokenType = -1
    ILLEGAL TokenType = iota
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
