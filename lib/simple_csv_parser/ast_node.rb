module SimpleCsvPaser
  class ASTNode
    attr_accessor :type, :children, :token

    def initialize(type)
      @type = type
      @children = []
    end

    def inspect(indent = 0)
      if children.empty?
        print ' ' * indent, @type.to_s, ' -> '
        p @token
        return
      end

      print ' ' * indent, @type.to_s, ":\n"
      @children.each do |child|
        child.inspect(indent + 2)
      end
    end
  end
end
