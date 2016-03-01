class Enrollment

  attr_reader :data

  def initialize(data)
    @data = data.merge(kindergarten_participation: floor_stuff(data))
  end

  def kindergarten_participation_by_year
    @data[:kindergarten_participation]
  end

  def floor_stuff(data)
    data[:kindergarten_participation].map do |year, value|
      [year, truncate(value)]
    end.to_h
  end

  def truncate(value)
    ((value * 1000).floor / 1000.0 )
  end

  def kindergarten_participation_in_year(year)
    @data[:kindergarten_participation][year]
  end





end
