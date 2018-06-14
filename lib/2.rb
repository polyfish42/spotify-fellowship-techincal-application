def lexer(str)
    str.scan /[\[\]]|\d|[A-Za-z]+/
end

def repeat(num, str)
    str * num
end

def decode(tokens)
    return "" if tokens.empty?

    case tokens[0]
    when /\d/
        repeat(tokens[0].to_i, decode(tokens[1..-1]))
    when /[A-Za-z]+/
        tokens[0] + decode(tokens[1..-1])
    when /[\[\]]/
        decode(tokens[1..-1])
    end
end

def decode_string(str)
    tokens = lexer(str)

    decode(tokens)
end

