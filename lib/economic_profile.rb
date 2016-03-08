class EconomicProfile

  attr_reader :name

  def initialize(hash_of_data)
    @name = hash_of_data[:name]
    @median_household_income = hash_of_data[:median_household_income]
  end

  def median_household_income_in_year(year)
    incomes = incomes_for_year(year)
    incomes.reduce(0) do |sum, income|
      sum += income
    end / incomes.count
  end

  def median_household_incomes_with_keys_as_range
    range = {}
    @median_household_income.map do |year_range, income|
      range[(year_range.first..year_range.last).to_a] = income
    end
    range
  end

  def incomes_for_year(year)
    median_household_incomes_with_keys_as_range.map do |year_range, income|
      income if year_range.include?(year)
    end.compact
  end


    #first sort through the keys and find output if the year is in range of the key
      #separate the keys into a range array
      #see if year is included in the array
      #return that hash key into another array
      #average out the keys that are returned


end
