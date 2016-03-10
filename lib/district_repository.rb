require 'csv'
require_relative './district'
require_relative './load_data'
require_relative './enrollment_repository'
require_relative './statewide_test_repository'
require_relative './economic_profile_repository'

class DistrictRepository
  attr_reader :repo, :district_instances

  def load_data(hash_of_file_paths)
    @repo ||= LoadData.new.load_data(hash_of_file_paths)
    district_instance_creator
    load_enrollment_repo_if_data_is_available
    load_state_wide_testing_if_data_is_available
    load_economic_proflie_repo_if_data_is_available
  end

  def load_economic_proflie_repo_if_data_is_available
    if @repo[:economic_profile]
      @economic_profile_repo ||= EconomicProfileRepository.new
      @economic_profile_repo.repo ||= @repo
      hash_of_economic_profile ||= economic_profile_for_district
      attach_economic_profile_instances(hash_of_economic_profile)
    end
  end

  def attach_economic_profile_instances(economic_profile_by_district)
    district_names.each do |district|
      district_instance = find_by_name(district)
      district_instance.economic_profile = economic_profile_by_district[district].first
    end
  end

  def economic_profile_for_district
    @economic_profile_repo.economic_profile_instances.group_by do |economic_profile_instance|
      economic_profile_instance.name
    end
  end

  def load_enrollment_repo_if_data_is_available
    if @repo[:enrollment]
      @enrollment_repo ||= EnrollmentRepository.new
      @enrollment_repo.repo ||= @repo
      hash_of_enrollments ||= enrollment_for_district
      attach_enrollment_instances(hash_of_enrollments)
    end
  end

  def attach_enrollment_instances(enrollments_by_district)
    district_names.each do |district|
      district_instance = find_by_name(district)
      district_instance.enrollment = enrollments_by_district[district].first
    end
  end

  def enrollment_for_district
    @enrollment_repo.enrollment_instances.group_by do |enrollment_instance|
      enrollment_instance.name
    end
  end

  def load_state_wide_testing_if_data_is_available
    if @repo [:statewide_testing]
      @statewide_repo ||= StatewideTestRepository.new
      @statewide_repo.repo ||= @repo
      hash_of_statewide_test ||= statewide_testing_by_district
      attach_statewide_test_instances(hash_of_statewide_test)
    end
  end

  def attach_statewide_test_instances(statewide_testing_by_district)
    district_names.each do |district|
      district_instance = find_by_name(district)
      district_instance.statewide_test = statewide_testing_by_district[district].first
    end
  end

  def statewide_testing_by_district
    @statewide_repo.statewide_test_instances.group_by do |statewide_test_instance|
      statewide_test_instance.name
    end
  end

  def kindergarten_enrollments
    @repo[:enrollment][:kindergarten]
  end

  def district_names
    kindergarten_enrollments.group_by do |enrollment|
      enrollment[:location]
    end.keys
  end

  def district_instance_creator
    @district_instances ||= district_names.map do |district|
      District.new({ name: district })
    end
  end

  def find_by_name(name)
    districts = @district_instances
    districts.find do |district|
      district.name.upcase == name.upcase
    end
  end

  def find_all_matching(name)
    result = []
    districts = @district_instances
    result = districts.find_all do |district|
      district.name.upcase.include?(name.upcase)
    end
    result
  end

end
