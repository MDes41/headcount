require 'pry'
require_relative 'load_data'
require_relative 'economic_profile'

class EconomicProfileRepository

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

  def district_groups
    median_household_income.group_by do |repo_row|
      repo_row[:location]
    end
  end

  def economic_profile_instances
    district_groups.keys.map do |district|
      EconomicProfile.new(name: district)
    end
  end

  



end
