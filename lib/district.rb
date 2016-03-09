require_relative 'enrollment'

class District
  attr_reader :name

  attr_accessor :enrollment, :economic_profile, :statewide_test

  def initialize(name)
    @name = name[:name]
  end
end
