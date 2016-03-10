require 'pry'
require_relative 'errors'

class HeadcountAnalyst

  attr_reader :district_repo, :district_names

  def initialize(district_repository = nil)
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

  #statewide testing analysis

  def top_statewide_test_year_over_year_growth(hash_of_input)
    subject = hash_of_input[:subject]
    grade = hash_of_input[:grade]
    top = hash_of_input[:top]
    weights = hash_of_input[:weighting]
    operators = hash_of_input.keys.sort
    case operators
    when [:grade, :top, :subject].sort
      result = percentage_growth_accross_all_districts(subject, grade).sort_by {|k,v| -v}
      result.take(top)
    when [:grade, :subject].sort
      result = percentage_growth_accross_all_districts(subject, grade).sort_by {|k,v| -v}
      result.first
    when [:grade]
      growth_across_all_districts_all_subjects(grade).first
    when [:grade, :weighting].sort
      growth_across_all_districts_all_subjects(grade, weights).first
    else
      raise InsufficientInformationError
    end
  end

  def growth_across_all_districts_all_subjects(grade, weights = nil)
    top_math = percentage_growth_accross_all_districts(:math, grade).to_h
    top_writing = percentage_growth_accross_all_districts(:writing, grade).to_h
    top_reading = percentage_growth_accross_all_districts(:reading, grade).to_h
    merge_district_data(top_math, top_writing, top_reading, weights)
  end
  #
  def merge_district_data(top_math, top_writing, top_reading, weights)
    weights = { math: 0.33333333, writing: 0.3333333, reading: 0.33333333 } unless weights
    @district_repo.district_instances.map do |district|
      adjusted_growth = ( (top_math[district.name] * weights[:math]) +
                          (top_writing[district.name] * weights[:writing]) +
                          (top_reading[district.name] * weights[:reading]) )
      [ district.name, truncate(adjusted_growth) ]
    end.sort_by { |k, v| -v }
  end

  def percentage_growth_accross_all_districts(subject, grade)
    @district_repo.district_instances.map do |district|
      proficiencies = district.statewide_test
      growth = percentage_growth_for_district(proficiencies, subject, grade)
      growth == nil ? [district.name, 0.0] : [district.name, growth]
    end
  end

  def percentage_growth_for_district(proficiencies, subject, grade)
    year_range = find_valid_years_across_district(proficiencies, subject, grade)
    if year_range.none? { |year| year == nil }
      proficiency_range = proficiency_accross_valid_years(proficiencies, subject, grade, year_range)
      average_percentage_growth_accross_years(year_range, proficiency_range)
    end
  end

  def proficiency_accross_valid_years(proficiencies, subject, grade, year_range)
    year_range.map do |year|
      proficiencies.proficient_for_subject_by_grade_in_year(subject,grade,year)
    end
  end

  def grade_proficiencies(grade, proficiencies)
    if grade == 3
      proficiencies.proficiency_by_year_3g
    elsif grade == 8
      proficiencies.proficiency_by_year_8g
    end
  end

  def find_valid_years_across_district(proficiencies, subject, grade)
    proficiencies_for_grade = grade_proficiencies(grade, proficiencies)
    years = proficiencies_for_grade.map do |year, proficiency|
      year if proficiency[subject] != "N/A"
    end.compact
    [ years.min, years.max ]
  end

  def average_percentage_growth_accross_years(year_range, proficiency_range)
    if year_range[1] - year_range[0] == 0
      result = 0.0
    else
      result = (proficiency_range[1] - proficiency_range[0]) /
                (year_range[1] - year_range[0])
    end
    truncate(result)
  end

  def truncate(value)
      ((value.to_f * 1000).floor / 1000.0 )
  end
end
