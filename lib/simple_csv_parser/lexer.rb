require_relative 'token'

module SimpleCsvPaser
  class Lexer
    def initialize(data_string)
      @data = data_string.chomp
      @index = 0
      @row = 0
      @column = 0
      @token_queue = []
      @has_more = true
    end

    def read
      return @token_queue.shift if fill_queue(0)
      Token.eof(@row, @column)
    end

    def peek(i)
      return @token_queue.fetch(i) if fill_queue(i)
      Token.eof(@row, @column)
    end

    private

    def fill_queue(i)
      while i >= @token_queue.size
        return false unless @has_more
        read_data_at_index
      end
      true
    end

    def read_data_at_index
      if @index >= @data.size
        @has_more = false
        return
      end
      token = Token.create(@data[@index..-1], @row, @column)
      @token_queue << token

      update_position token
    end

    def update_position(token)
      @index += token.text.size
      @column += token.text.size

      if token.type == :crlf || token.type == :lf
        @row += 1
        @column = 0
      end
    end
  end
end
