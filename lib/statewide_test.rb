require "minitest/autorun"
require "minitest/pride"
require 'pry'

class StatewideTest
  attr_reader :name

  def initialize(hash_of_data)
    @name = hash_of_data[:name]
    @proficiency_by_year_3g = hash_of_data[:proficiency_by_year_3g]
    @proficiency_by_year_8g = hash_of_data[:proficiency_by_year_8g]
    @proficiency_by_race_or_ethnicity_data = hash_of_data[:proficiency_by_race_or_ethnicity]
  end

  def proficient_by_grade(grade)
    @proficiency_by_year_3g if grade == 3 || grade == "3"
    @proficiency_by_year_8g if grade == 8 || grade == "8"
  end

  def proficient_by_race_or_ethnicity(category)
    @proficiency_by_race_or_ethnicity_data[category]
  end

  def proficient_for_subject_by_grade_in_year(subject,grade,year)
    if grade == 3 || grade == "3"
      require "pry"; binding.pry
      @proficiency_by_year_3g[year.to_s][subject.downcase.to_sym]
    elsif grade == 8 || grade == "8"
      @proficiency_by_year_8g[year.to_s][subject.downcase.to_sym]
    end
  end

  def proficient_for_subject_by_race_in_year(subject,race, year)
    require "pry"; binding.pry
    @proficiency_by_race_or_ethnicity_data[race][year.to_s][subject]
  end

end
