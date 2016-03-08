require 'pry'

class HeadcountAnalyst

  attr_reader :district_repo, :district_names

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
      [year, compare_to_state_average(year, participation, compare).to_f]
    end.to_h
  end

  def compare_to_state_average(year, participation, district_comparing_against)
    district_participation_compared_with_state = participation.to_f /
    districts_participation(district_comparing_against)[year].to_f
    '%.3f' % district_participation_compared_with_state
  end

  def districts_graduation(district)
    @district_repo.find_by_name(district).enrollment.high_school_graduation
  end

  def average_of_districts_graduation(district)
    districts_graduation(district).values.reduce(0) do |sum, num|
      sum += num.to_f
    end / districts_graduation(district).values.count
  end

  def hs_graduation_rate_variation(district, district_to_compare)
    compare = district_to_compare[:against]
    (average_of_districts_graduation(district) /
    average_of_districts_graduation(compare)).round(3)
  end

  def hs_graduation_rate_variation_against_state(district)
    state_graduation_average ||= average_of_districts_graduation('COLORADO')
    (average_of_districts_graduation(district) /
    state_graduation_average).round(3)
  end

  def kindergarten_participation_rate_variation_against_state(district)
    state_participation_average ||= average_of_districts_participation('COLORADO')
    (average_of_districts_participation(district) /
    state_participation_average).round(3)
  end

  def kindergarten_participation_against_high_school_graduation(district)
    (kindergarten_participation_rate_variation_against_state(district) /
    hs_graduation_rate_variation_against_state(district)).round(3)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(for_district)
    district = for_district[:for]
    districts = for_district[:across]
    false_array = Array.new
    true_array = Array.new
    if districts
        districts.map do |district|
        result = find_if_variation_is_true_or_false(district)
          if result == true
            true_array.push(result)
          else
            false_array.push(result)
          end
        end
        correlation_above_seventy_percent?(true_array, false_array)
    elsif district == "STATEWIDE"
      @district_repo.district_names.map do |district|
      result = find_if_variation_is_true_or_false(district)
        if result == true
          true_array.push(result)
        else
          false_array.push(result)
        end
      end
      correlation_above_seventy_percent?(true_array, false_array)
    else
      find_if_variation_is_true_or_false(district)
    end
  end

  def find_if_variation_is_true_or_false(district)
    variation = kindergarten_participation_against_high_school_graduation(district)
    variation > 0.6 && variation < 1.5 ? true : false
  end

  def correlation_above_seventy_percent?(true_array, false_array)
    total_count = true_array.count + false_array.count
    true_array.count > 0.7*(total_count) ? true : false
  end
end
