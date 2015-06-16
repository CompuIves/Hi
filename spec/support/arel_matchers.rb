module RSpec::Matchers
  define :have_where_clause do |table, left, operator, right|
    string_with_symbol_matching = lambda do |sym_or_str|
      sym_or_str = sym_or_str.to_s
      def sym_or_str.==(other)
        super(other.to_s)
      end
      sym_or_str
    end

    cls = table.to_s.classify.constantize
    # left operant is converted by active_record to a string in some cases, but not all
    left = string_with_symbol_matching.call(left)

    expected_clause = cls.arel_table[left].send(operator, right)

    match do |actual|
      actual.where_values.any? { |v| expected_clause == v }
    end

    failure_message do |actual|
      "expected\n#{PP.pp actual.where_values, ''}\nto contain\n#{PP.pp expected_clause, ''}"
    end
    failure_message_when_negated do |actual|
      "expected\n#{PP.pp actual.where_values, ''}\nto not contain\n#{PP.pp expected_clause, ''}"
    end
  end
end
