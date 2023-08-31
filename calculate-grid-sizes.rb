require 'optparse'

class My_Person
  attr_reader :name

  def initialize
    @name = 'Nikita'
  end
end

p = My_Person.new
puts p.name
