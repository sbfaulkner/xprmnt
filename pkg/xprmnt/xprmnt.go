package xprmnt

func Parse(expression string) (string, error) {
    lexer := newLexer(expression)
	lexer.NextToken()
    // We'll implement the actual parsing later
    return "", nil
}