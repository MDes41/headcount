require_relative 'enrollment'

class District
  attr_reader :name

  def initialize(hash)
    @name = hash[:location]
  end
end
