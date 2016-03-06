require "minitest/autorun"
require "minitest/pride"
require 'pry'

class StatewideTest
  attr_reader :name

  def initialize(hash_of_name)
    @name = hash_of_name[:name]
    @proficiency_by_year_3g = hash_of_name[:proficiency_by_year_3g]
    @proficiency_by_year_8g = hash_of_name[:proficiency_by_year_8g]
  end

  def proficient_by_grade(grade)
    @proficiency_by_year_3g if grade == 3 || "3"
    @proficiency_by_year_8g if grade == 8 || "8"
  end

  def proficient_by_race_or_ethnicity(race)
    @proficient_by_race_or_ethnicity[race]
  end

  def proficient_for_subject_by_grade_in_year(subject,grade,year)
    @proficient_for_subject_by_grade_in_year[subject, grade, year]
  end

  def proficient_for_subject_by_race_in_year(subject,race_year)
    @proficient_for_subject_by_race_in_year[subject, race, year]
  end

end
