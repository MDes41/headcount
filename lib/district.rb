require_relative 'enrollment'

class District
  attr_reader :name

  def initialize(name)
    @name = name
  end
end
