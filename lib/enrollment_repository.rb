require 'pry'
require 'csv'
require_relative './district'
require_relative './enrollment'
require_relative 'load_data'

class EnrollmentRepository

  attr_reader :repo

  def load_data(hash_of_file_paths)
    @repo = LoadData.new.load_data(hash_of_file_paths)
  end

  def find_by_name(name)
    binding.pry
    instances_of_enrollment.find do |enrollment|
      enrollment.name.upcase == name.upcase
    end
  end

  def kindergarten_enrollments
    repo[:enrollment][:kindergarten]
  end

  def enrollments_grouped_by_district
    kindergarten_enrollments.group_by do |enrollment|
      enrollment[:location]
    end
  end

  def match_year_and_participation(participation_data)
    participation_data.map do |row|
      [row[:timeframe], row[:data]]
    end.to_h
  end

  def participation_for_district(district)
    all_data_for_district = kindergarten_enrollments.find_all do |repo_row|
      district == repo_row[:location]
    end
    match_year_and_participation(all_data_for_district)
  end

  def instances_of_enrollment
    enrollments_grouped_by_district.keys.map do |district|
      participation_for_district_hash = participation_for_district(district)
      modified_participation = floor_stuff(participation_for_district_hash)
      Enrollment.new({        :name => district,
        :kindergarten_participation => modified_participation
                    })
    end
  end

  def floor_stuff(participation)
    participation.map do |year, value|
      [year, ('%.3f' % truncate(value)).to_s]
    end.to_h
  end

  def truncate(value)
    ((value.to_f * 1000).floor / 1000.0 )
  end
end
