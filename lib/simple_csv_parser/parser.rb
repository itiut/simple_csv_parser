module SimpleCsvPaser
  class Parser
    RULES = [
      # file0 ->
      [:record0, :file1],           # 0

      # file1 ->
      [:crlf, :record0, :file1],   # 1
      [],                          # 2

      # record0 ->
      [:field, :record1],          # 3

      # record1 ->
      [:comma, :field, :record1],  # 4
      [],                          # 5

      # field ->
      [:escaped],                  # 6
      [:nonescaped],               # 7

      # escaped ->
      [:dquote, :quoted, :dquote], # 8

      # nonescaped ->
      [:textdata, :nonescaped],    # 9
      [],                          # 10

      # quoted ->
      [:comma,     :quoted],       # 11
      [:crlf,      :quoted],       # 12
      [:textdata,  :quoted],       # 13
      [:cr,        :quoted],       # 14
      [:lf,        :quoted],       # 15
      [:twodquote, :quoted],       # 16
      []                           # 17
    ]

    PARSE_TABLE = {
      file0:      { eof: 0,  comma: 0,  crlf: 0,  dquote: 0,  textdata: 0 },
      file1:      { eof: 2,             crlf: 1 },
      record0:    { eof: 3,  comma: 3,  crlf: 3,  dquote: 3,  textdata: 3 },
      record1:    { eof: 5,  comma: 4,  crlf: 5 },
      field:      { eof: 7,  comma: 7,  crlf: 7,  dquote: 6,  textdata: 7 },
      escaped:    {                               dquote: 8 },
      nonescaped: { eof: 10, comma: 10, crlf: 10, dquote: 10, textdata: 9 },
      quoted:     {          comma: 11, crlf: 12, dquote: 17, textdata: 13, cr: 14, lf: 15, twodquote: 16 }
    }

    def initialize(lexer)
      @lexer = lexer
    end

    def parse
      stack = [:file0]
      until stack.empty?
        token = @lexer.peek(0)

        if terminal_symbol?(stack.last)
          parse_error(token) unless stack.last == token.type
          stack.pop
          @lexer.read
          next
        end

        generated_symbols = RULES[PARSE_TABLE[stack.pop][token.type]]
        generated_symbols.reverse.each do |symbol|
          stack << symbol
        end
      end
    end

    private

    def terminal_symbol?(type)
      PARSE_TABLE.keys.all? { |key| key != type }
    end

    def parse_error(token)
      fail 'parse error'
    end
  end
end
