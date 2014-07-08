module SimpleCsvPaser
  class Token
    attr_accessor :type, :text, :row, :column

    def initialize(type, text, row, column)
      @type, @text, @row, @column = type, text, row, column
    end

    PATTERNS = {
      comma: /\A,/,
      crlf: /\A\r\n/,
      cr: /\A\r/,
      lf: /\A\n/,
      twodquote: /\A""/,
      dquote: /\A"/,
      textdata: /\A[ !#-+.-~-]+/
    }

    def self.create(data_substring, row = -1, column = -1)
      PATTERNS.each do |type, pattern|
        m = pattern.match(data_substring)
        return Token.new(type, m[0], row, column) if m
      end
      fail "Lexical error in line:#{row + 1} column:#{column + 1}"
    end

    def self.eof(row = -1, column = -1)
      @eof ||= Token.new(:eof, '', row, column)
    end
  end
end
