class Token
  attr_reader :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end

  def to_s
    "Token(Type: #{@type}, Value: '#{@value}')"
  end
  
  def show_type
    "#{@type}" 
  end

  def show_value
    "#{@value}" 
  end
end

class Variable 
  attr_reader :name, :type, :value
  
  def initialize(name, type, value)
    @name = name 
    @type = type
    @value = value 
  end 
  
  def change_v(value)
    @value = value
  end 
  
  def show_value
    @value
  end
end

KEYWORDS = {
  "let" => "KEYWORDS_LET",
  "if" => "KEYWORDS_IF",
  "else" => "KEYWORDS_ELSE",
  "print" => "KEYWORDS_PRINT",

  # Brakets
  "{" => "BRAKET_OPEN_CURL",
  "}" => "BRAKET_CLOSE_CURL",
  "(" => "BRAKET_OPEN_ROUND",
  ")" => "BRAKET_CLOSE_ROUND"
}.freeze

_msg = "let x = 10.2; print(x); if (x) { print(1) } else { print(0) }"
parts = []
tokens = []

parts = _msg.scan(/\d+\.\d+|\w+|[{}()=;]|\S/)  # Array of things to be tokenized

# Basically all the tokenization process (aka Lexer)
parts.each_with_index do |c, index|
  if KEYWORDS.key?(c.downcase)
    tokens << Token.new(KEYWORDS[c.downcase], c)
  elsif c == "="
    tokens << Token.new("ASSIGN", c)
  elsif c == ";"
    tokens << Token.new("SEMICOLON", c)
  elsif c =~ /^\d+\.\d+$/                     # Decimal check
    tokens << Token.new("DECIMAL", c)
  elsif c =~ /^\d+$/                          # Integer check
    tokens << Token.new("INT", c)
  elsif c =~ /^[a-zA-Z_]\w*$/
    tokens << Token.new("IDENTIFIER", c)
  else
    tokens << Token.new("UNKNOWN", c)
  end
end

puts "--- TOKENS ---"
puts tokens

# ast creation process (beacuse i want my own algorithm)
ast = []

tokens.each_with_index do |token, index|
  new_part = []
  if token.type == "KEYWORDS_LET"
    new_part << index 
    new_part << "ASSIGN" 
    new_part << tokens[index + 1].value
    new_part << tokens[index + 3].value
    
  elsif token.type == "KEYWORDS_PRINT"
    new_part << index
    new_part << "PRINT"
    new_part << tokens[index + 2].value

  elsif token.type == "KEYWORDS_IF"
    new_part << index
    new_part << "IF_BLOCK"
    new_part << tokens[index + 2].value

  elsif token.type == "KEYWORDS_ELSE"
    new_part << index
    new_part << "ELSE_BLOCK"

  elsif token.type == "BRAKET_OPEN_CURL"
    new_part << index
    new_part << "BRAKET_OPEN_CURL"
  
  elsif token.type == "BRAKET_CLOSE_CURL"
    new_part << index
    new_part << "BRAKET_CLOSE_CURL"
  
  end
  ast << new_part
end

puts "\n--- AST ---"
p ast

# Brackets and If-Else evaluation

_indentation = 0
_last_bracket = "BRAKET_CLOSE_CURL"

ast.each_with_index do |branch, index|
  if branch[1] == "BRAKET_OPEN_CURL"
    if _last_bracket != branch[1]
      _indentation = _indentation + 1
      _last_bracket = "BRAKET_OPEN_CURL"
    else 
      puts "ERROR: Unexpected open bracket"
      break
    end
  elsif branch[1] == "BRAKET_CLOSE_CURL"
    if _last_bracket != branch[1]
      _indentation = _indentation - 1
      _last_bracket = "BRAKET_CLOSE_CURL"
    else 
      puts "ERROR: Unexpected closed bracket"
      break
    end
  end

  if _indentation < 0
    puts "ERROR: Unexpected bracket"
  end
  branch << _indentation
end

puts "\n--- AST ---"
p ast


