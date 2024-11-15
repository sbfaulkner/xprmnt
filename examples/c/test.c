#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <xprmnt.h>

struct TestCase {
    const char* input;
    double expected_result;
    bool expect_error;
};

int main() {
    struct TestCase tests[] = {
        {"2 + 3 * 4", 14.0, false},      // Operator precedence
        {"(2 + 3) * 4", 20.0, false},    // Parentheses
        {"10 / 2 + 5", 10.0, false},     // Left-to-right evaluation
        {"1 + + 2", 0.0, true},          // Invalid expression
        {"42", 42.0, false},             // Single number
        {"1 2", 0.0, true},              // Invalid expression
        {"1 / 0", 0.0, true},            // Division by zero
        {"-5", -5.0, false},             // Simple negation
        {"-2 + 3", 1.0, false},          // Negation with addition
        {"2 * -3", -6.0, false},         // Negation with multiplication
        {"-(2 + 3)", -5.0, false},       // Negation of parenthesized expression
        {"-(-5)", 5.0, false}            // Double negation
    };
    
    int num_tests = sizeof(tests) / sizeof(tests[0]);
    int failed = 0;
    
    for (int i = 0; i < num_tests; i++) {
        int error_code = 0;
        double result = Parse(tests[i].input, &error_code);
        
        bool has_error = (error_code != 0);
        if (has_error != tests[i].expect_error) {
            printf("FAIL: '%s' - expected error: %s, got error: %s\n",
                tests[i].input,
                tests[i].expect_error ? "yes" : "no",
                has_error ? "yes" : "no");
            failed++;
            continue;
        }
        
        if (!tests[i].expect_error && result != tests[i].expected_result) {
            printf("FAIL: '%s' - expected: %f, got: %f\n",
                tests[i].input,
                tests[i].expected_result,
                result);
            failed++;
            continue;
        }
        
        printf("PASS: '%s'\n", tests[i].input);
    }
    
    printf("\n%d tests run, %d failed\n", num_tests, failed);
    return failed ? 1 : 0;
}
