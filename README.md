## Headcount

**Project completed by Matthew DesMarteau and Christine Gamble**

This project was a two week project completed at Turing School of Design and Sofware as a final project for Module 1.  It contains a collection of data centered around schools in Colorado provided by the Annie E. Casey foundation.  

Ultimately, a crude visualization of the structure might look like this:

```
- District: Gives access to all the data relating to a single, named school district
|-- Enrollment: Gives access to enrollment data within that district, including:
|  | -- Dropout rate information
|  | -- Kindergarten enrollment rates
|  | -- Online enrollment rates
|  | -- Overall enrollment rates
|  | -- Enrollment rates by race and ethnicity
|  | -- High school graduation rates by race and ethnicity
|  | -- Special education enrollment rates
|-- Statewide Testing: Gives access to testing data within the district, including:
|  | -- 3rd grade standardized test results
|  | -- 8th grade standardized test results
|  | -- Subject-specific test results by race and ethnicity
|  | -- Higher education remediation rates
|-- Economic Profile: Gives access to economic information within the district, including:
|  | -- Median household income
|  | -- Rates of school-aged children living below the poverty line
|  | -- Rates of students qualifying for free or reduced price programs
|  | -- Rates of students qualifying for Title I assistance
```
All data from the CSV's can be loaded from the commend line through the Data Repository.

```ruby
dr = DistrictRepository.new
dr.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv",
  },
  :statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  }, 
  :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    :title_i => "./data/Title I students.csv"
  }
})
district = dr.find_by_name("ACADEMY 20")
```
###District Names
A list of all the districts included in the project can be accessed through the district repository with:
```ruby
dr.district_names
```
##Statewide Testing Information

The statewide testing information can be called through the district instances with:
```ruby
statewide_test = district.statewide_test
```
Proficiency by grade can be called for grade `3` and grade `8`:
```ruby
statewide_test.proficient_by_grade(grade)
```
Proficiency by race or ethnicity can be called with valid race categories:
```valid_categories = [:asian, :black, :pacific_islander,
          :hispanic, :native_american, :two_or_more, :white]```
```ruby 
statewide_test.proficient_by_race_or_ethnicity(:asian)
```
Other methods in the statewide testing repositoring include:
```ruby
statewide_test.proficient_for_subject_by_grade_in_year(subject,grade,year)
proficient_for_subject_by_race_in_year(subject,race, year)
```
with valid subjects of ```:math```, ```:reading```, and ```:writing``` with valid grades of ```3``` and ```8``` and valid  years ```2000``` through ```2014```.

##Enrollment Repository

The enrollment repository can be accessed through the district repository with:
```ruby
enrollments = district.enrollment
```
The following methods are included in the enrollment repository:
```ruby
enrollments.kindergarten_participation_by_year
enrollments.kindergarten_participation_in_year(year)
enrollments.graduation_rate_by_year
enrollments.graduation_rate_in_year(year)
```
##Economic Profile
The economic profiles can be accessed with:
```ruby
economic_profile = district.economic_profile
```
The following methods are included in the economic profile repository:
```ruby
median_household_income_in_year(year)
median_household_income_average
children_in_poverty_in_year(year)
free_or_reduced_price_lunch_percentage_in_year(year)
free_or_reduced_price_lunch_number_in_year(year)
title_i_in_year(year)
```

## Headcount Analyst

Please check out the ```headcount_analyst.rb``` file for further analysis methods that analyze the data across race and grade type.

**contact one of the collaborators on the repo for further details. Thanks!**



Find the assignment here: https://github.com/turingschool/curriculum/blob/master/source/projects/headcount.markdown
