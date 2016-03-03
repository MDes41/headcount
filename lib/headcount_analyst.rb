require 'pry'

class HeadcountAnalyst

  attr_reader :district_repo

  def initialize(district_repository)
    @district_repo = district_repository
  end

  def districts_participation(district)
    @district_repo.find_by_name(district).enrollment.kindergarten_participation
  end

  def average_of_districts_participation(district)
    districts_participation(district).values.reduce(0) do |sum, num|
      sum += num.to_f
    end / districts_participation(district).values.count
  end

  def kindergarten_participation_rate_variation(district, district_to_compare)
    compare = district_to_compare[:against]
    (average_of_districts_participation(district) /
    average_of_districts_participation(compare)).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district,compare_district)
    compare = compare_district[:against]
    districts_participation(district).map do |year, participation|
      [year, compare_to_state_average(year, participation, compare).to_s]
    end.to_h
  end

  def compare_to_state_average(year, participation, district_comparing_against)
    district_participation_compared_with_state = participation.to_f /
    districts_participation(district_comparing_against)[year].to_f
    '%.3f' % district_participation_compared_with_state
  end
end
