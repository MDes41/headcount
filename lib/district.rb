require_relative 'enrollment'

class District
  attr_reader :name

  attr_accessor :enrollment

  def initialize(hash)
    @name = hash[:name]
  end
end
