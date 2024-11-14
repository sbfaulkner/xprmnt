%{
package xprmnt

import (
    "fmt"
    "log"
    "os"
    "strconv"
)

type Parser struct {
    lexer *Lexer
    result float64
    debug bool
}

func newParser(l *Lexer) *Parser {
    debug := os.Getenv("DEBUG") != ""
    return &Parser{
        lexer: l,
        debug: debug,
    }
}

func Parse(expression string) (float64, error) {
	lexer := newLexer(expression)
	parser := newParser(lexer)

	return parser.Parse()
}
%}

%union {
    num float64
}

%token <num> NUMBER
%token PLUS

%type <num> expr

%%

expr:
    NUMBER                  {
        if yylex.(*Parser).debug { log.Printf("NUMBER: %v", $1) }
        $$ = $1;
        yylex.(*Parser).result = $$
    }
    | NUMBER PLUS NUMBER    {
        if yylex.(*Parser).debug { log.Printf("NUMBER PLUS NUMBER: %v + %v", $1, $3) }
        $$ = $1 + $3;
        yylex.(*Parser).result = $$
    }
    ;

%%

func (p *Parser) Parse() (float64, error) {
    if p.debug {
        log.Printf("Starting parse...")
    }
    yyParse(p)
    if p.debug {
        log.Printf("Parse complete. Result: %v", p.result)
    }
    return p.result, nil
}

func (p *Parser) Lex(lval *yySymType) int {
    token := p.lexer.NextToken()
    
    if p.debug {
        log.Printf("Token: %v (Value: %q)", token.Type, token.Value)
    }

    if token.Type == NUMBER {
        val, err := strconv.ParseFloat(token.Value, 64)
        if err != nil {
            p.Error(fmt.Sprintf("invalid number: %q", token.Value))
            return int(INVALID)
        }
        lval.num = val
    }
    
    return int(token.Type)
}

func (p *Parser) Error(s string) {
    // For now, just print the error
    fmt.Printf("parse error: %s\n", s)
} 