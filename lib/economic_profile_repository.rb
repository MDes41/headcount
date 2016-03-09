require 'pry'
require_relative 'load_data'
require_relative 'economic_profile'

class EconomicProfileRepository

  attr_accessor :repo

  def load_data(hash_of_file_paths)
    @repo ||= LoadData.new.load_data(hash_of_file_paths)
  end

  def find_by_name(name)
    economic_profile_instances.find do |economic_profile_instance|
      economic_profile_instance.name.downcase == name.downcase
    end
  end

  def median_household_income
    @repo[:economic_profile][:median_household_income]
  end

  def children_in_poverty
    @repo[:economic_profile][:children_in_poverty]
  end

  def free_or_reduced_price_lunch
    @repo[:economic_profile][:free_or_reduced_price_lunch]
  end

  def title_I
    @repo[:economic_profile][:title_i]
  end

  def district_groups
    @repo[:economic_profile][:median_household_income].group_by do |repo_row|
      repo_row[:location]
    end
  end

  def economic_profile_instances
    median_income_hash ||= hash_repo_for_median_income(median_household_income)
    title_I_hash ||= hash_percent_repo(title_I)
    children_in_poverty_hash ||= hash_percent_repo(children_in_poverty)
    free_or_reduced_price_lunch_hash ||= hash_repo_for_free_or_reduced_price_lunch(free_or_reduced_price_lunch)
    district_groups.keys.map do |district|
      EconomicProfile.new( name: district,
        median_household_income: median_income_hash[district],
            children_in_poverty: children_in_poverty_hash[district],
                        title_i: title_I_hash[district],
    free_or_reduced_price_lunch: free_or_reduced_price_lunch_hash[district]
                          )
    end
  end

  def hash_repo_for_median_income(repo)
    repo_by_location = group_by_location(repo)
    repo_by_location.map do |district, data_for_district|
      [ district, match_timeframe_to_data_range(data_for_district) ]
    end.to_h
  end

  def group_by_location(repo)
    repo.group_by do |repo_row|
      repo_row[:location]
    end
  end

  def match_timeframe_to_data_range(data_for_district)
    data_for_district.map do |district_data|
      year_range = string_range_into_int(district_data[:timeframe])
      [ year_range, district_data[:data].to_i ]
    end.to_h
  end

  def string_range_into_int(string_range)
    string_range.split("-").map(&:to_i)
  end

  def hash_percent_repo(repo)
    repo_by_location = group_by_location(repo)
    repo_by_location.map do |district, data_for_district|
      [ district,  match_timeframe_to_percent(data_for_district) ]
    end.to_h
  end

  def match_timeframe_to_percent(data_for_district)
    data_for_district.map do |district_data|
      [ district_data[:timeframe].to_i, truncate(district_data[:data].to_f) ]
    end.to_h
  end

  def truncate(value)
    result = ((value.to_f * 1000).floor / 1000.0 )
    result == 100.0 ? 100 : result
  end

  def hash_repo_for_free_or_reduced_price_lunch(repo)
    repo_by_location = group_by_location(repo)
    repo_by_location.map do |district, data_for_district|
      [ district,  group_by_poverty_level(data_for_district).first ]
    end.to_h
  end

  def select_only_required_data(data_for_district)
    year = data_for_district[:timeframe].to_i
    data_format = data_for_district[:dataformat]
    data = data_for_district[:data]
    if @dates.include?(year)
      @dates -= [year]
      @data_holder << adjust_string_data(data_format , data)
      nil
    else
      data = adjust_string_data(data_format, data)
      data2 = @data_holder.pop
      { year => { data[0] => data[1] , data2[0] => data2[1] } }
    end
  end

  def adjust_string_data(data_format, data)
    if data_format == "Percent"
      [ :percentage , truncate(data.to_f) ]
    else
      [ :total , data.to_i ]
    end
  end

  def group_by_poverty_level(data_for_district)
    @dates = (2000..2014).to_a
    @data_holder = []
    data_for_district.map do |data_for_district|
      if data_for_district[:poverty_level]=="Eligible for Free or Reduced Lunch"
        select_only_required_data(data_for_district)
      else
        nil
      end
    end.compact
  end

  #maybe try to hash the entire repo then step down each line
  #with pop or .first to get the element into and array then
  #step down with if statements and grab the data and create a
  #hash with selected data. may also to_a and see if the

end
