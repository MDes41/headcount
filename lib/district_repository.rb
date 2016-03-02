require 'pry'
require 'csv'
require_relative './district'
require_relative './load_data'

class DistrictRepository
  attr_reader :repo

  def initialize
    @repo = {:enrollment=>{:kindergarten=>nil}}
  end

  def load_data(hash_of_file_paths)
    @repo = LoadData.new.load_data(hash_of_file_paths)
  end

  def kindergarten_enrollments(repo)
    repo[:enrollment][:kindergarten]
  end

  def enrollments_grouped_by_district(repo)
    kindergarten_enrollments(repo).group_by do |enrollment|
      enrollment[:location]
    end
  end

  def create_district_names(repo)
    enrollments_grouped_by_district(repo).keys.map do |district|
      District.new(district)
    end
  end

  def find_by_name(name)
    districts = create_district_names(repo)
    districts.find do |district|
      district.name.upcase == name.upcase
    end
  end

  def find_all_matching(name)
    result = []
    districts = create_district_names(repo)
    result = districts.find_all do |district|
      district.name.upcase.include?(name.upcase)
    end
    result
  end

end
