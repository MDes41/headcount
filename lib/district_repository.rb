require_relative 'pry'
require_relative 'csv'
require_relative './district'
require_relative './load_data'
require_relative './enrollment_repository'

class DistrictRepository
  attr_reader :repo, :enrollment_repo

  def load_data(hash_of_file_paths)
    @repo ||= LoadData.new.load_data(hash_of_file_paths)
    @enrollment_repo ||= EnrollmentRepository.new
    enrollment_repo.repo ||= @repo
  end

  def kindergarten_enrollments
    @repo[:enrollment][:kindergarten]
  end

  def district_names
    kindergarten_enrollments.group_by do |enrollment|
      enrollment[:location]
    end.keys
  end

  def enrollment_for_district(district)
    @enrollment_repo.find_by_name(district)
  end

  def district_instances
    district_names.map do |district|
      district_instance = District.new(district)
      district_instance.enrollment = enrollment_for_district(district)
      district_instance
    end
  end

  def find_by_name(name)
    districts = district_instances
    districts.find do |district|
      district.name.upcase == name.upcase
    end
  end

  def find_all_matching(name)
    result = []
    districts = district_instances
    result = districts.find_all do |district|
      district.name.upcase.include?(name.upcase)
    end
    result
  end

end
