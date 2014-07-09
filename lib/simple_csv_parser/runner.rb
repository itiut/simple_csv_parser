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

      lexer = Lexer.new IO.read(@args[0])
      parser = Parser.new lexer
      analyzer = SemanticAnalyzer.new parser.parse

      analyzer.analyze

      puts "Finish parsing #{@args[0]} successfully."
    end
  end
end
