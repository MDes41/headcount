require 'pry'
require 'csv'
require_relative './statewide_test'
require_relative './load_data'
require_relative './statewide_test_repository'

class StatewideTestRepository

  attr_accessor :repo

  def load_data(hash_of_file_paths)
    @repo ||= LoadData.new.load_data(hash_of_file_paths)
    statewide_test_instances
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
      [year.to_i, hash_out_scores(data)]
    end.to_h
  end

  def hash_out_scores(data)
    data.map do |data|
      if data[:data].to_f == 0.0
        [data[:score].downcase.to_sym, "N/A"]
      else
        [data[:score].downcase.to_sym, ('%.3f' % truncate(data[:data])).to_f]
      end
    end.to_h
  end

  def truncate(value)
    ((value.to_f * 1000).floor / 1000.0 )
  end

  #create_hash_for_race_groups

  def create_hash_with_all_subjects
    math = district_groups_by_race_for_math
    reading = district_groups_by_race_for_reading
    writing = district_groups_by_race_for_writing
    main = create_hash_for_race_groups(main: math)
    math_hash ||= create_hash_for_race_groups(math: math)
    reading_hash ||= create_hash_for_race_groups(reading: reading)
    math_and_reading_hash = merge_proficiency_data(math_hash, reading_hash)
    writing_hash ||= create_hash_for_race_groups(writing: writing)
    all_subjects = merge_proficiency_data(math_and_reading_hash, writing_hash)
    merge_proficiency_data(all_subjects, all_subjects, 1)
  end



  def merge_proficiency_data(subject_one, subject_two, zeros = nil)
    subject_one.merge(subject_two) do |key, oldval, newval|
      newval.merge(oldval) do |key, oldval, newval|
        newval.merge(oldval) do |key, oldval, newval|
          newval.merge(oldval) do |key, oldval, newval|
            if zeros == 1
              if oldval == 0.0
                newval = "N/A"
              else
                newval
              end
            else
              newval + oldval
            end
          end
        end
      end
    end
  end

  def create_hash_for_race_groups(subject)
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
      [ year.to_i ,  subject_hash(subject, data)]
    end.to_h
  end

  def subject_hash(subject, data)
    proficiencies = { math: 0, reading: 0, writing: 0 }
    proficiencies[subject] = ('%.3f' % truncate(data.first[:data])).to_f
    proficiencies
  end


end
