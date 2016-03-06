require 'pry'
require 'csv'
require_relative './statewide_test'
require_relative './load_data'
require_relative './statewide_test_repository'

class StatewideTestRepository

  def load_data(hash_of_file_paths)
    @repo ||= LoadData.new.load_data(hash_of_file_paths)
    statewide_test_instances if third_grade_proficiency
  end

  def find_by_name(name)
    statewide_test_instances.find do |statewide_test|
      statewide_test.name.upcase == name.upcase
    end
  end

  def third_grade_proficiency
    @repo[:statewide_testing][:third_grade]
  end

  def eighth_grade_proficiency
    @repo[:statewide_testing][:eighth_grade]
  end

  def district_groups_3g
    third_grade_proficiency.group_by do |repo_row|
      repo_row[:location]
    end
  end

  def district_groups_8g
    eighth_grade_proficiency.group_by do |repo_row|
      repo_row[:location]
    end
  end

  def statewide_test_instances
    proficiency_data_3g ||= create_hash_of_math_reading_writing_per_year_3g
    proficiency_data_8g ||= create_hash_of_math_reading_writing_per_year_8g
    district_groups_3g.keys.map do |district|
      StatewideTest.new( { name: district,
            proficiency_by_year_3g: proficiency_data_3g[district],
            proficiency_by_year_8g: proficiency_data_8g[district]
                      } )
    end
  end

  def create_hash_of_math_reading_writing_per_year_8g
    district_groups_8g.map do |district, data|
      [district, get_score_data(data)]
    end.to_h
  end

  def create_hash_of_math_reading_writing_per_year_3g
    district_groups_3g.map do |district, data|
      [district, get_score_data(data)]
    end.to_h
  end

  def group_by_years(data)
    data.group_by do |data|
      data[:timeframe]
    end
  end

  def get_score_data(data)
    group_by_years(data).map do |year, data|
      [year, hash_out_scores(data)]
    end.to_h
  end

  def hash_out_scores(data)
    data.map do |data|
      [data[:score], ('%.3f' % truncate(data[:data])).to_f]
    end.to_h
  end

  def truncate(value)
    ((value.to_f * 1000).floor / 1000.0 )
  end

end
