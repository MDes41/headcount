## Headcount

**Project completed by Matthew DesMarteau and Christine Gamble**

This project was a two week project completed at Turing School of Design and Sofware as a final project for Module 1.  It contains a colleton of data centered around schools in Colorado provided by the Annie E. Casey foundation.  

Ultimately, a crude visualization of the structure might look like this:

```ruby
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
statewide_test = district.statewide_test
```
Original Assigment Markdown (https://github.com/turingschool/curriculum/blob/master/source/projects/headcount.markdown)



Find the assignment here: https://github.com/turingschool/curriculum/blob/master/source/projects/headcount.markdown
