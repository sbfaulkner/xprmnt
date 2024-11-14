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
    err error
    parentheses int
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
%token PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN

%left PLUS MINUS
%left MULTIPLY DIVIDE

%type <num> expr

%%

expr:
    NUMBER {
        if yylex.(*Parser).debug { log.Printf("NUMBER: %v", $1) }
        $$ = $1;
        yylex.(*Parser).result = $$
    }
    | expr PLUS expr {
        if yylex.(*Parser).debug { log.Printf("expr PLUS expr: %v + %v", $1, $3) }
        $$ = $1 + $3;
        yylex.(*Parser).result = $$
    }
    | expr MINUS expr {
        if yylex.(*Parser).debug { log.Printf("expr MINUS expr: %v - %v", $1, $3) }
        $$ = $1 - $3;
        yylex.(*Parser).result = $$
    }
    | expr MULTIPLY expr {
        if yylex.(*Parser).debug { log.Printf("expr MULTIPLY expr: %v * %v", $1, $3) }
        $$ = $1 * $3;
        yylex.(*Parser).result = $$
    }
    | expr DIVIDE expr {
        if yylex.(*Parser).debug { log.Printf("expr DIVIDE expr: %v / %v", $1, $3) }
        if $3 == 0 {
            yylex.(*Parser).err = fmt.Errorf("divide by zero")
            return -1
        }
        $$ = $1 / $3;
        yylex.(*Parser).result = $$
    }
    | LPAREN expr RPAREN {
        if yylex.(*Parser).debug { log.Printf("LPAREN expr RPAREN: (%v)", $2) }
        $$ = $2;
        yylex.(*Parser).result = $$
    }
    ;

%%

func (p *Parser) Parse() (float64, error) {
    if p.debug {
        log.Printf("Starting parse...")
    }

    yyParse(p)

    if p.parentheses > 0 {
        p.err = fmt.Errorf("unclosed parenthesis")
    }

    if p.debug {
        log.Printf("Parse complete. Result: %v, Error: %v", p.result, p.err)
    }

    return p.result, p.err
}

func (p *Parser) Lex(lval *yySymType) int {
    token := p.lexer.NextToken()
    
    if p.debug {
        log.Printf("Token: %v (Value: %q)", token.Type, token.Value)
    }

    switch token.Type {
    case NUMBER:
        val, err := strconv.ParseFloat(token.Value, 64)
        if err != nil {
            p.Error(fmt.Sprintf("invalid number: %q", token.Value))
            return int(INVALID)
        }
        lval.num = val
    
    case LPAREN:
        p.parentheses++

    case RPAREN:
        p.parentheses--
        if p.parentheses < 0 {
            p.err = fmt.Errorf("unexpected closing parenthesis")
            return int(INVALID)
        }
    }
    
    return int(token.Type)
}

func (p *Parser) Error(s string) {
    if p.err == nil {
        p.err = fmt.Errorf("syntax error: %s", s)
    }
} 