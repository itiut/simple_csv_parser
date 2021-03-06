module SimpleCsvPaser
  class SemanticAnalyzer
    def initialize(ast_root)
      @ast_root = ast_root
    end

    def analyze
      fields_and_crlfs = select_and_flatten_types_by_dfs([:field, :crlf], @ast_root)

      number_of_fields = nil
      split_by_value(fields_and_crlfs, :crlf).each_with_index do |fields_in_record, i|
        unless number_of_fields
          number_of_fields = fields_in_record.size
          next
        end

        semantic_error('The number of fields is different', i + 1) unless number_of_fields == fields_in_record.size
      end
    end

    private

    def select_and_flatten_types_by_dfs(types, node)
      return [node.type] if types.include?(node.type)

      result = []
      node.children.each do |child|
        result.concat select_and_flatten_types_by_dfs(types, child)
      end
      result
    end

    def split_by_value(array, target_value)
      array.chunk { |value| value != target_value || nil }.map { |_, arr| arr }
    end

    def semantic_error(message, line)
      fail "Semantic error in line:#{line}: #{message}"
    end
  end
end
