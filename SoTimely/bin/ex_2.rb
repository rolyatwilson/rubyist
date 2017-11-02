#!/usr/bin/env ruby

puts '8.4.1 Instantiating date/time objects'
puts 'Creating Date Objects'

require 'date'

# What is Today's date?
not_new   = Date.new   #
not_civil = Date.civil #
but_today = Date.today #

# What are the default values for the constructor?
init_1 = Date.new 2013         #
init_2 = Date.new 2013, 12     #
init_3 = Date.new 2013, 12, 17 #

# String parsing
from_string_1 = Date.parse '2013/12/17'
# from_string_2 = Date.parse '12/17/2013'

# Rubyisms
101.times do |year|
  date = Date.parse "#{year}/12/17"
  puts "year => #{year}   \t date => #{date}"
end

which_century_1 = Date.parse '13/12/17'
which_century_2 = Date.parse '68/12/17'
which_century_3 = Date.parse '69/12/17'

# Date is smart
smart_1 = Date.parse 'december 17 2013'   #
smart_2 = Date.parse 'dec 17 2013'        #
smart_3 = Date.parse '17 dec 2013'        #
smart_5 = Date.parse '2013 dec 17'        #
smart_4 = Date.parse '2013 17 dec'        #
smart_5 = Date.parse 'dec seventeen 2013' #
smart_6 = Date.parse 'dec seventeen'      #

# Monday-based vs Sunday-based
today_jd = Date.today.jd            #
today_cm = Date.commercial today_jd #

# Scanning
scan_2 = Date.strptime '2013-12-17', '%Y-%m-%d'
scan_3 = Date.strptime '17-2013-12', '%d-%Y-%m'
scan_4 = Date.strptime '03-09-2013', '%m-%d-%Y'
scan_5 = Date.strptime '03-09-2013', '%d-%m-%Y'
scan_6 = Date.strptime '03-09-2013', '%d-%m-%y'
scan_7 = Date.strptime '2013 dates_are_hard', '%Y'
scan_8 = Date.strptime '2013 dates_are_hard 12 really 17', '%Y dates_are_hard %m really %d'

puts 'el fin'
