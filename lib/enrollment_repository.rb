require 'pry'
require 'csv'
require_relative './district'
require_relative './enrollment'
require_relative 'load_data'

class EnrollmentRepository

  attr_accessor :repo

  def load_data(hash_of_file_paths)
    @repo ||= LoadData.new.load_data(hash_of_file_paths)
  end

  def find_by_name(name)
    enrollment_instances.find do |enrollment|
      enrollment.name.upcase == name.upcase
    end
  end

  def kindergarten_enrollments
    repo[:enrollment][:kindergarten]
  end

  def district_names
    kindergarten_enrollments.group_by do |enrollment|
      enrollment[:location]
    end.keys
  end

  def district_participation_data(district)
    kindergarten_enrollments.find_all do |kindergarten_enrollment|
      kindergarten_enrollment[:location] == district
    end
  end

  def create_hash_of_years_to_participation(district)
    district_participation_data(district).map do |row|
      [row[:timeframe], row[:data]]
    end.to_h
  end

  def enrollment_instances
    district_names.map do |district|
      participation = create_hash_of_years_to_participation(district)
      Enrollment.new({        :name => district,
        :kindergarten_participation => floor_stuff(participation)
                    })
    end
  end

  def floor_stuff(participation)
    participation.map do |year, value|
      [year.to_i, ('%.3f' % truncate(value)).to_f]
    end.to_h
  end

  def truncate(value)
    ((value.to_f * 1000).floor / 1000.0 )
  end
end
