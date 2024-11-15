# require 'rubygems'
require 'bundler/setup'
require 'ffi'

module Xprmnt
  extend FFI::Library
  ffi_lib File.expand_path('../../lib/libxprmnt.so', __dir__)

  # Define the function signature to match our C API
  attach_function :Parse, [:string, :pointer], :double
end

class TestCase
  attr_reader :input, :expected_result, :expect_error

  def initialize(input, expected_result, expect_error)
    @input = input
    @expected_result = expected_result
    @expect_error = expect_error
  end
end

# Define test cases
tests = [
  TestCase.new("2 + 3 * 4", 14.0, false),      # Operator precedence
  TestCase.new("(2 + 3) * 4", 20.0, false),    # Parentheses
  TestCase.new("10 / 2 + 5", 10.0, false),     # Left-to-right evaluation
  TestCase.new("1 + * 2", 0.0, true),          # Invalid expression
  TestCase.new("42", 42.0, false),             # Single number
  TestCase.new("1 2", 0.0, true),              # Invalid expression
  TestCase.new("1 / 0", 0.0, true),            # Division by zero
  TestCase.new("-5", -5.0, false),             # Simple negation
  TestCase.new("-2 + 3", 1.0, false),          # Negation with addition
  TestCase.new("2 * -3", -6.0, false),         # Negation with multiplication
  TestCase.new("-(2 + 3)", -5.0, false),       # Negation of parenthesized expression
  TestCase.new("-(-5)", 5.0, false),           # Double negation
  TestCase.new("+5", 5.0, false),              # Simple positive
  TestCase.new("+2 + 3", 5.0, false),          # Positive with addition
  TestCase.new("2 * +3", 6.0, false),          # Positive with multiplication
  TestCase.new("+(2 + 3)", 5.0, false),        # Positive of parenthesized expression
  TestCase.new("+(-5)", -5.0, false),          # Positive of negative
  TestCase.new("-+5", -5.0, false),            # Mixed unary operators
  TestCase.new("+(-2 * 3)", -6.0, false)       # Complex expression with unary plus
]

failed = 0

tests.each do |test|
  error_ptr = FFI::MemoryPointer.new(:int, 1)
  result = Xprmnt.Parse(test.input, error_ptr)
  has_error = error_ptr.read_int != 0

  if has_error != test.expect_error
    puts "FAIL: '#{test.input}' - expected error: #{test.expect_error}, got error: #{has_error}"
    failed += 1
    next
  end

  if !test.expect_error && result != test.expected_result
    puts "FAIL: '#{test.input}' - expected: #{test.expected_result}, got: #{result}"
    failed += 1
    next
  end

  puts "PASS: '#{test.input}'"
end

puts "\n#{tests.length} tests run, #{failed} failed"
exit(failed == 0 ? 0 : 1)
