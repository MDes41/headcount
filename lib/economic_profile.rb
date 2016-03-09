class EconomicProfile

  attr_reader :name

  def initialize(hash_of_data)
    @name = hash_of_data[:name]
    @median_household_income = hash_of_data[:median_household_income]
    @children_in_poverty = hash_of_data[:children_in_poverty]
    @free_or_reduced_price_lunch = hash_of_data[:free_or_reduced_price_lunch]
    @title_i = hash_of_data[:title_i]
  end

  def median_household_income_in_year(year)
    if incomes_for_year(year) == []
      raise "UnknownDataError"
    else
      incomes = incomes_for_year(year)
      incomes.reduce(0) do |sum, income|
        sum += income
      end / incomes.count
    end
  end

  def median_household_incomes_with_keys_as_range
    range = {}
    @median_household_income.map do |year_range, income|
      range[(year_range.first..year_range.last).to_a] = income
    end
    range
  end

  def first_and_last_year_in_given_data
    all_years = @median_household_income.map do |year_range, income|
      year_range
    end.flatten
    [ all_years.min, all_years.max ]
  end


  def median_household_income_average
    all_years = first_and_last_year_in_given_data
    years = (all_years.min..all_years.max).to_a
    years.reduce(0) do |sum, year|
      sum += median_household_income_in_year(year)
    end / years.count
  end

  def incomes_for_year(year)
    median_household_incomes_with_keys_as_range.map do |year_range, income|
      income if year_range.include?(year)
    end.compact
  end

  def children_in_poverty_in_year(year)
    result = @children_in_poverty[year]
    if result == nil
      raise "UnknownDataError"
      else
        truncate(result)
    end
  end

  def truncate(value)
    result = ((value.to_f * 1000).floor / 1000.0 )
    result == 100.0 ? 100 : result
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    result = @free_or_reduced_price_lunch[year][:percentage]
    if result == []
      raise "UnknownDataError"
    else
      truncate(result)
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    result = @free_or_reduced_price_lunch[year][:total]
    if result == nil
      raise "UnknownDataError"
    else
      truncate(result)
    end
  end

  def title_i_in_year(year)
    result = @title_i[year]
    if result == nil
    raise "UnknownDataError"
    else
      truncate(result)
    end
  end
end
