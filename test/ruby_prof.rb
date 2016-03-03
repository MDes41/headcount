require_relative "../lib/district_repository"
require 'ruby-prof'
RubyProf.start

dr = DistrictRepository.new
dr.load_data({
:enrollment => {
          :kindergarten => "../data/Kindergartners in full-day program.csv",
:high_school_graduation => "../data/High school graduation rates.csv"
                  }
            })

district = dr.find_by_name("ACADEMY 20").name

result = RubyProf.stop
printer = RubyProf::MultiPrinter.new(result)
printer.print(:path => "./tmp", :profile => "profile")
