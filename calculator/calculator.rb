require 'optparse'

$debug = false

OptionParser.new do |options|
  options.banner = "Usage: #$PROGRAM_NAME [options] [expression]"
  options.on('-d', '--debug') do |flag|
    $debug = flag
  end
  options.parse!
end

class InvalidElementError < RuntimeError

end

class Operation
  attr_accessor :left_operand, :operator, :right_operand

  OPERATORS = %w(+ - / *)
  HIGH_PRIORITY_OPERATORS = %w(* /)

  def initialize(elements)

    @elements = elements
    parentheses_number = 0
    group_start = nil
    group_end = nil
    while @elements.include? '('
      group_start = @elements.index '('
      group_end = find_group_end(group_start)
      if group_start == 0 and group_end == @elements.size - 1
        @elements = @elements[group_start+1..group_end-1]
        next
      end
      group = @elements.slice!(group_start..group_end)
      group = group[1..-2]
      @elements.insert(group_start, Operation.new(group))
    end

    while @elements.length > 3 and @elements.intersect? HIGH_PRIORITY_OPERATORS
      operator = @elements.intersection(HIGH_PRIORITY_OPERATORS).first
      operator_index = @elements.index operator
      group = @elements.slice!(operator_index-1..operator_index+1)
      @elements.insert operator_index-1, Operation.new(group)
    end
  end

  def result()
    result = nil
    @elements.each_with_index do |element, index|
      if OPERATORS.include? element
        if result == nil
          result = @elements[index - 1] if result == nil
          result = result.result() if result.kind_of? Operation
        end
        right_operand = @elements[index + 1]
        right_operand = right_operand.result() if right_operand.kind_of? Operation
        result = result.send(element, right_operand)
      end
    end
    return result
  end

  def to_s
    %Q/Operation(#{@elements.join(' ')})/
  end

  private
  def find_group_end(group_start)
    parentheses = 0
    @elements[group_start + 1 ..].each_with_index do |element, index|
      if element == '('
        parentheses += 1
      elsif element == ')'
        if parentheses == 0
          return group_start + index + 1
        else
          parentheses -= 1
        end
      end
    end
    raise %Q/Unmatched "("!/
  end
end

class Expression
  NUMBER_REGEX = /\d+(?:\.\d+)?/

  def initialize(original_string)
    @elements = []
    parentheses = 0
    original_string.scan(/ #{NUMBER_REGEX} | \S /x) do |element|
      match = $~
      case element
      when '('
        parentheses += 1
        @elements.push element
      when ')'
        if parentheses == 0
          raise %Q/Unmatched parentheses at #{match.begin(0)}: #{match.pre_match}>#{match[0]}<#{match.post_match}/
        end
        parentheses -= 1
        @elements.push element
      when /\d+(?:\.\d+)?/
        @elements.push Float(element)
      when %r/[-+\/*]/
        unless match.pre_match =~ /( #{NUMBER_REGEX} | \) ) \s* $/x and match.post_match =~ /^ \s* (\( | #{NUMBER_REGEX})?/x
          raise %Q/Operands not found for operator "#{element}": #{match.pre_match}>#{element}<#{match.post_match}/
        end
        @elements.push element
      else
        raise %Q/Unexpected character "#{element}": #{match.pre_match}>#{element}<#{match.post_match}/
      end
    end
    if parentheses > 0
      match = original_string.match(/\(/)
      raise %Q/Unmatched parentheses at #{match.begin(0)}: #{match.pre_match}>#{match[0]}<#{match.post_match}/
    end
  end

  def evaluate
    operation = Operation.new(@elements)
    puts operation.to_s if $debug
    return operation.result
  end
end

puts Expression.new(ARGV.join).evaluate
