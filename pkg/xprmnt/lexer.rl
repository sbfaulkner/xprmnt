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
        space+      => {
            l.p = l.te - 1;
            if l.debug { log.Printf("Skipping whitespace") }
        };
        digit+      => {
            l.p = l.te;
            token := Token{Type: NUMBER, Value: string(data[l.ts:l.te])}
            if l.debug { log.Printf("Found number: %s", token.Value) }
            return token
        };
        '*'         => {
            l.p = l.te;
            if l.debug { log.Printf("Found multiply") }
            return Token{Type: MULTIPLY, Value: "*"}
        };
        '/'         => {
            l.p = l.te;
            if l.debug { log.Printf("Found divide") }
            return Token{Type: DIVIDE, Value: "/"}
        };
        '+'         => {
            l.p = l.te;
            if l.debug { log.Printf("Found plus") }
            return Token{Type: PLUS, Value: "+"}
        };
        '-'         => {
            l.p = l.te;
            if l.debug { log.Printf("Found minus") }
            return Token{Type: MINUS, Value: "-"}
        };
        '('         => {
            l.p = l.te;
            if l.debug { log.Printf("Found lparen") }
            return Token{Type: LPAREN, Value: "("}
        };
        ')'         => {
            l.p = l.te;
            if l.debug { log.Printf("Found rparen") }
            return Token{Type: RPAREN, Value: ")"}
        };
    *|;
}%%

type Lexer struct {
    data []byte
    p, pe, cs int
    ts, te, act int
    debug bool
}

func newLexer(input string) *Lexer {
    debug := os.Getenv("DEBUG") != ""
    l := &Lexer{
        data: []byte(input),
        pe:   len(input),
        debug: debug,
    }
    %% write init;
    return l
}

func (l *Lexer) NextToken() Token {
    data := l.data
    p := l.p
    pe := l.pe
    eof := pe

    if p >= pe {
        if l.debug { log.Printf("EOF") }
        return Token{Type: EOF}
    }

    %% write exec;

    if l.p >= l.pe {
        if l.debug { log.Printf("EOF") }
        return Token{Type: EOF}
    }

    if l.debug { log.Printf("Invalid token: %v", data[p:p+1]) }
    l.p = p + 1
    return Token{Type: INVALID, Value: string(data[p:p+1])}
} 