require_relative "../lib/district_repository"
require_relative "../lib/headcount_analyst"
require 'ruby-prof'
RubyProf.start

dr = DistrictRepository.new
dr.load_data({
  :enrollment => {
        :kindergarten => "../data/Kindergartners in full-day program.csv",
:high_school_graduation => "../data/High school graduation rates.csv"
                }
          })
ha = HeadcountAnalyst.new(dr)
evaluate = ha.kindergarten_participation_correlates_with_high_school_graduation(for: "ACADEMY 20")


result = RubyProf.stop
printer = RubyProf::MultiPrinter.new(result)
printer.print(:path => "./tmp", :profile => "profile")
