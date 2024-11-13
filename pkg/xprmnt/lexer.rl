package xprmnt

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
        '+'           => { l.p = p + 1; return Token{Type: PLUS, Value: "+"} };
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

func (l *Lexer) NextToken() Token {
    data := l.data
    p := l.p
    pe := l.pe

    %% write exec;

    if p == pe {
        return Token{Type: EOF}
    }

    l.p = p + 1
    return Token{Type: ILLEGAL, Value: string(data[p:p+1])}
} 