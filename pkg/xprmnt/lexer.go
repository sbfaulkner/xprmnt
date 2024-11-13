
//line pkg/xprmnt/lexer.rl:1
package xprmnt


//line pkg/xprmnt/lexer.go:7
const lexer_start int = 1
const lexer_first_final int = 1
const lexer_error int = 0

const lexer_en_main int = 1


//line pkg/xprmnt/lexer.rl:19


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
    
//line pkg/xprmnt/lexer.go:30
	{
	( l.cs) = lexer_start
	( l.ts) = 0
	( l.te) = 0
	( l.act) = 0
	}

//line pkg/xprmnt/lexer.rl:33
    return l
}

func (l *Lexer) NextToken() Token {
    data := l.data
    p := l.p
    pe := l.pe

    
//line pkg/xprmnt/lexer.go:48
	{
	if ( l.p) == ( l.pe) {
		goto _test_eof
	}
	switch ( l.cs) {
	case 1:
		goto st_case_1
	case 0:
		goto st_case_0
	}
	goto st_out
tr0:
//line pkg/xprmnt/lexer.rl:17
( l.te) = ( l.p)+1
{ l.p = p + 1; return Token{Type: PLUS, Value: "+"} }
	goto st1
	st1:
//line NONE:1
( l.ts) = 0

		if ( l.p)++; ( l.p) == ( l.pe) {
			goto _test_eof1
		}
	st_case_1:
//line NONE:1
( l.ts) = ( l.p)

//line pkg/xprmnt/lexer.go:76
		if data[( l.p)] == 43 {
			goto tr0
		}
		goto st0
st_case_0:
	st0:
		( l.cs) = 0
		goto _out
	st_out:
	_test_eof1: ( l.cs) = 1; goto _test_eof

	_test_eof: {}
	_out: {}
	}

//line pkg/xprmnt/lexer.rl:42

    if p == pe {
        return Token{Type: EOF}
    }

    l.p = p + 1
    return Token{Type: ILLEGAL, Value: string(data[p:p+1])}
} 