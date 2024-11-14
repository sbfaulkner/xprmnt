package main

// #include <stdlib.h>
import "C"
import "xprmnt/pkg/xprmnt"

//export Parse
func Parse(expr *C.char, error_code *C.int) C.double {
	goExpr := C.GoString(expr)
	result, err := xprmnt.Parse(goExpr)

	if err != nil {
		*error_code = C.int(1)
		return 0
	}

	*error_code = C.int(0)
	return C.double(result)
}

func main() {} // Required for C shared libraries
