class Token
  attr_reader :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end

  def to_s
    "Token(Type: #{@type}, Value: '#{@value}')"
  end
end

KEYWORDS = {
  "let" => "KEYWORDS_LET",
  "if" => "KEYWORDS_IF",
  "else" => "KEYWORDS_ELSE",
  "print" => "KEYWORDS_PRINT"
}.freeze

_msg = "let x = 10.2; print x"
parts = []
tokens = []

_msg.scan(/\w+|\S/).each do |c|     # Making an array from the msg.
    parts << c
end

parts.each_with_index do |c, index|
  if KEYWORDS.key?(c.downcase)
    tokens << Token.new(KEYWORDS[c.downcase], c)
  elsif c == "="
    tokens << Token.new("ASSIGN", c)
  elsif c == ";"
    tokens << Token.new("SEMICOLON", c)
  elsif c =~ /^\d+$/
    if parts[index + 1] == "." || parts[index + 1] == ","
        _decimal_number = ""
    else
        tokens << Token.new("INT", c)
    end
  elsif c =~ /^[a-zA-Z_]\w*$/
    tokens << Token.new("IDENTIFIER", c)
  else
    tokens << Token.new("UNKNOWN", c)
  end
end

puts tokens


