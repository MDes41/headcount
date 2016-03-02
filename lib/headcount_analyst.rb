require 'pry'

class HeadcountAnalyst

  attr_reader :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def average_district_kindergarten_participation_across_all_years(district)
    participation_by_years =
    @district_repository.find_by_name(district) .enrollment.kindergarten_participation
    participation_by_years.values.reduce(0) do |sum, num|
      sum += num.to_f
    end / participation_by_years.values.count
  end

  def state_average_kindergarten_participation_across_all_years(state)
    participation_by_years =
    @district_repository.find_by_name(state[:against])
    binding.pry
    x = participation_by_years.values.reduce(0) do |sum, num|
      sum += num.to_f
    end / participation_by_years.values.count
  end

  def kindergarten_participation_rate_variation(district, state)
    (average_district_kindergarten_participation_across_all_years(district) /
    state_average_kindergarten_participation_across_all_years(state)).round(3)
  end

end
