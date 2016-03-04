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

  def district_groups_kg
    kindergarten_enrollments.group_by do |enrollment|
      enrollment[:location]
    end
  end

  def district_groups_hs
    high_school_enrollments.group_by do |graduation|
      graduation[:location]
    end
  end

  def create_hash_of_years_to_graduation_hs(district)
    district_groups_hs[district].map do |row|
      [row[:timeframe], row[:data]]
    end.to_h
  end

  def create_hash_of_years_to_participation_kg(district)
    district_groups_kg[district].map do |row|
      [row[:timeframe], row[:data]]
    end.to_h
  end

  def enrollment_instances
    result = create_enrollment_instances_with_name_and_kindergarten
    add_hs_data_to_enrollment_instances(result) if high_school_enrollments != nil
    result
  end

  def create_enrollment_instances_with_name_and_kindergarten
    district_groups_kg.keys.map do |district|
      participation = create_hash_of_years_to_participation_kg(district)
      Enrollment.new  ({        :name => district,
          :kindergarten_participation => floor_stuff(participation)
                      })
    end
  end

  def add_hs_data_to_enrollment_instances(result)
    result.each do |enrollment_instance|
      graduation = create_hash_of_years_to_graduation_hs(enrollment_instance.name)
      enrollment_instance.high_school_graduation = floor_stuff(graduation)
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
