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

  def high_school_enrollments
    repo[:enrollment][:high_school_graduation]
  end

  def district_names
    kindergarten_enrollments.group_by do |enrollment|
      enrollment[:location]
    end.keys
  end

  def district_graduation_rates_hs(district)
    high_school_enrollments.find_all do |graduation_by_district|
      graduation_by_district[:location] == district
    end
  end

  def create_hash_of_years_to_graduation_hs(district)
    district_graduation_rates_hs(district).map do |row|
      [row[:timeframe], row[:data]]
    end.to_h
  end

  def district_participation_data_kg(district)
    kindergarten_enrollments.find_all do |kindergarten_enrollment|
      kindergarten_enrollment[:location] == district
    end
  end

  def create_hash_of_years_to_participation_kg(district)
    district_participation_data_kg(district).map do |row|
      [row[:timeframe], row[:data]]
    end.to_h
  end

  def enrollment_instances
    district_names.map do |district|
      participation = create_hash_of_years_to_participation_kg(district)
      graduation = create_hash_of_years_to_graduation_hs(district)
      Enrollment.new({        :name => district,
        :kindergarten_participation => floor_stuff(participation),
            :high_school_graduation => floor_stuff(graduation)
                    })
    end
  end

  def floor_stuff(percentage_data)
    percentage_data.map do |year, value|
      [year.to_i, ('%.3f' % truncate(value)).to_f]
    end.to_h
  end

  def truncate(value)
    ((value.to_f * 1000).floor / 1000.0 )
  end
end
