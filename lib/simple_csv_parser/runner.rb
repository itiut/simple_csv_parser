require_relative 'lexer'
require_relative 'parser'
require_relative 'semantic_analyzer'

module SimpleCsvPaser
  class Runner
    def initialize(args)
      @args = args
    end

    def usage
      puts "Usage: #{$PROGRAM_NAME} CSVFILE"
    end

    def run
      if @args.size != 1
        usage
        exit 1
      end

      csvfile = @args.first
      lexer = Lexer.new IO.read(csvfile)
      parser = Parser.new lexer
      analyzer = SemanticAnalyzer.new parser.parse

      analyzer.analyze

      puts "Finish parsing #{csvfile} successfully."
    end
  end
end
