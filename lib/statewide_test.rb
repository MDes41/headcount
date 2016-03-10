require "minitest/autorun"
require "minitest/pride"

class StatewideTest
  attr_reader :name, :proficiency_by_year_3g, :proficiency_by_year_8g

  def initialize(hash_of_data)
    @name = hash_of_data[:name]
    @proficiency_by_year_3g = hash_of_data[:proficiency_by_year_3g]
    @proficiency_by_year_8g = hash_of_data[:proficiency_by_year_8g]
    @proficiency_by_race_or_ethnicity_data = hash_of_data[:proficiency_by_race_or_ethnicity]
  end

  def proficient_by_grade(grade)
    if grade == 3
      @proficiency_by_year_3g
    elsif grade == 8
      @proficiency_by_year_8g
    else
      raise UnknownDataError
    end
  end

  def proficient_by_race_or_ethnicity(category)
    valid_categories = [:asian, :black, :pacific_islander,
          :hispanic, :native_american, :two_or_more, :white]
    if valid_categories.include?(category)
      @proficiency_by_race_or_ethnicity_data[category]
    else
      raise UnknownDataError
    end
  end

  def proficient_for_subject_by_grade_in_year(subject,grade,year)
    if [:math, :reading, :writing].include?(subject) && grade == 3
      @proficiency_by_year_3g[year][subject.downcase.to_sym]
    elsif [:math, :reading, :writing].include?(subject) && grade == 8
      @proficiency_by_year_8g[year][subject.downcase.to_sym]
    elsif
      raise UnknownDataError
    end
  end

  def proficient_for_subject_by_race_in_year(subject,race, year)
    valid_categories = [:asian, :black, :pacific_islander,
          :hispanic, :native_american, :two_or_more, :white]
    valid_subjects = [:math, :reading, :writing]
    if valid_subjects.include?(subject) && valid_categories.include?(race)
      @proficiency_by_race_or_ethnicity_data[race][year][subject]
    else
      raise UnknownDataError
    end
  end

end
