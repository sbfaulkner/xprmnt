package xprmnt

import (
    "log"
    "os"
)

%%{
    machine lexer;

    # Variable declarations for Ragel
    variable p l.p;
    variable pe l.pe;
    variable cs l.cs;
    variable ts l.ts;
    variable te l.te;
    variable act l.act;

    write data;

    main := |*
        space+      => { l.p = l.te - 1; };
        digit+      => { l.p = l.te; return Token{Type: NUMBER, Value: string(data[l.ts:l.te])} };
        '*'         => { l.p = l.te; return Token{Type: MULTIPLY, Value: "*"} };
        '/'         => { l.p = l.te; return Token{Type: DIVIDE, Value: "/"} };
        '+'         => { l.p = l.te; return Token{Type: PLUS, Value: "+"} };
        '-'         => { l.p = l.te; return Token{Type: MINUS, Value: "-"} };
        '('         => { l.p = l.te; return Token{Type: LPAREN, Value: "("} };
        ')'         => { l.p = l.te; return Token{Type: RPAREN, Value: ")"} };
    *|;
}%%

type Lexer struct {
    data []byte
    p, pe, cs int
    ts, te, act int
}

func newLexer(input string) *Lexer {
    l := &Lexer{
        data: []byte(input),
        pe:   len(input),
    }
    %% write init;
    return l
}

var debugging = os.Getenv("DEBUG") != ""

func (l Lexer) debug(msg string) {
    if !debugging {
        return
    }

    log.Printf("%s - %+v", msg, l)
}

func (l *Lexer) NextToken() Token {
    data := l.data
    p := l.p
    pe := l.pe
    eof := pe

    if p >= pe {
        return Token{Type: EOF}
    }

    %% write exec;

    l.p = p + 1
    return Token{Type: INVALID, Value: string(data[p:p+1])}
} 