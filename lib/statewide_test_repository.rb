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

  def math_proficiency_by_race
    @repo[:statewide_testing][:math]
  end

  def reading_proficiency_by_race
    @repo[:statewide_testing][:reading]
  end

  def writing_proficiency_by_race
    @repo[:statewide_testing][:writing]
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

  def district_groups_by_race_for_math
    math_proficiency_by_race.group_by do |repo_row|
      repo_row[:location]
    end
  end

  def district_groups_by_race_for_reading
    reading_proficiency_by_race.group_by do |repo_row|
      repo_row[:location]
    end
  end

  def district_groups_by_race_for_writing
    writing_proficiency_by_race.group_by do |repo_row|
      repo_row[:location]
    end
  end

  def statewide_test_instances
    proficiency_data_3g ||= create_hash_of_math_reading_writing_per_year_3g
    proficiency_data_8g ||= create_hash_of_math_reading_writing_per_year_8g
    proficiency_by_race_or_ethnicity ||= create_hash_with_all_subjects
    district_groups_3g.keys.map do |district|
      StatewideTest.new( {      name: district,
              proficiency_by_year_3g: proficiency_data_3g[district],
              proficiency_by_year_8g: proficiency_data_8g[district],
    proficiency_by_race_or_ethnicity: proficiency_by_race_or_ethnicity[district]
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
      [data[:score].downcase.to_sym, ('%.3f' % truncate(data[:data])).to_f]
    end.to_h
  end

  def truncate(value)
    ((value.to_f * 1000).floor / 1000.0 )
  end

  #create_hash_for_race_groups

  def create_hash_with_all_subjects
    @subject_proficiencies = {}
    math = district_groups_by_race_for_math
    reading = district_groups_by_race_for_reading
    writing = district_groups_by_race_for_writing
    create_hash_of_for_race_groups(math: math)
    create_hash_of_for_race_groups(reading: reading)
    create_hash_of_for_race_groups(writing: writing)
  end

  def create_hash_of_for_race_groups(subject)
    subject.values.first.map do |district, data|
      [district, get_proficiency_data(data, subject.keys.first)]
    end.to_h
  end

  def get_proficiency_data(data, subject)
    group_by_race(data).map do |race, data|
      standardized_race = race.gsub(" ","_").downcase.to_sym
      standardized_race = :pacific_islander if race.include?("aiian")
      [ standardized_race, hash_out_by_years(data, subject) ]
    end.to_h
  end

  def group_by_race(data)
    data.group_by do |data|
      data[:race_ethnicity]
    end.to_h
  end

  def hash_out_by_years(data, subject)
    group_by_years(data).map do |year, data|
      @subject_proficiencies[subject] = ('%.3f' % truncate(data.first[:data])).to_f
      [year , @subject_proficiencies]
    end.to_h
  end


end
