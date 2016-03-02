require 'pry'
require 'csv'
require_relative './district'

class DistrictRepository

  attr_reader :repo

  def load_data(file_categories)
    @repo = file_categories.map do |file_category, files|
      [file_category, load_each_file(files)]
    end.to_h
  end

  def load_each_file(files)
    files.map do |type, filename|
      [type, load_csv_data(filename)]
    end.to_h
  end

  def load_csv_data(filename)
    csv = CSV.open(filename, headers: true, header_converters: :symbol)
    csv.to_a.map { |row| row.to_h }
  end

  def districts
    kindergarten_enrollments = @repo[:enrollment][:kindergarten]
    kindergarten_enrollments.map do |kindergarten_enrollment|
      District.new(kindergarten_enrollment)
    end
  end

  def find_by_name(name)
    districts.find do |district|
      district.name.upcase == name.upcase
    end
  end

  def find_all_matching(name)
    result = []
    result = districts.find_all do |district|
      district.name.upcase.include?(name.upcase)
    end
    result
  end

end
