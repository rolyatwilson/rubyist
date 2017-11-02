#!/usr/bin/env ruby

puts '8.4.1 Instantiating date/time objects'
puts 'Creating DateTime Objects'

# Which import do we need?
# require 'time'
require 'date'

DateTime.new

# What times is it now?
not_new = DateTime.new
but_now = DateTime.now

# What are the default values for the constructor?
init_1 = DateTime.new 2013                        #
init_2 = DateTime.new 2013, 12                    #
init_3 = DateTime.new 2013, 12, 17                #
init_4 = DateTime.new 2013, 12, 17, 14            #
init_5 = DateTime.new 2013, 12, 17, 14, 37        #
init_6 = DateTime.new 2013, 12, 17, 14, 37, 11    #
init_7 = DateTime.new 2013, 12, 17, 14, 37, 11, 3 #

# String parsing
from_string_01 = DateTime.parse '2013/12/17'                      #
# from_string_02 = DateTime.parse '12/17/2013'                      #
from_string_03 = DateTime.parse '2013/12/17 14'                   #
from_string_04 = DateTime.parse '2013/12/17 14:37'                #
from_string_05 = DateTime.parse '2013/12/17 14:37:11'             #
from_string_06 = DateTime.parse '2013/12/17 14 37 11'             #
from_string_07 = DateTime.parse '2013/12/17 14_37_11'             #
# from_string_08 = DateTime.parse '2013/12/17 14-37-11'             #
from_string_09 = DateTime.parse '2013/12/17 14:37:11 UTC'         #
from_string_10 = DateTime.parse '2013/12/17 14:37:11 GMT'         #
from_string_11 = DateTime.parse '2013/12/17 14:37:11 EST'         #
from_string_12 = DateTime.parse '2013/12/17 14:37:11 CST'         #
from_string_13 = DateTime.parse '2013/12/17 14:37:11 MST'         #
from_string_14 = DateTime.parse '2013/12/17 14:37:11 MDT'         #
from_string_15 = DateTime.parse '2013/12/17 14:37:11 PST'         #
from_string_16 = DateTime.parse '2013/12/17 14:37:11 PDT'         #
from_string_17 = DateTime.parse '2013/12/17 14:37:11 LOCAL'       #
from_string_18 = DateTime.parse '2013/12/17 14:37:11 JIBBERISH'   #
from_string_19 = DateTime.parse '2013/12/17 2:37:11 AM JIBBERISH' #
from_string_20 = DateTime.parse '2013/12/17 2:37:11 PM JIBBERISH' #
from_string_21 = DateTime.parse '2017-01-01T00:00:00+00:00'
from_string_22 = DateTime.parse '2017-05-01T00:00:00+00:00'

# Scanning
scan_1 = DateTime.strptime '2013-12-17 02:37:11', '%Y-%m-%d %I:%M:%S'
scan_2 = DateTime.strptime '17-2013-12 37:02:11', '%d-%Y-%m %M:%I:%S'
scan_3 = DateTime.strptime '03-09-2013 14:37:11', '%m-%d-%Y %H:%M:%S'

puts 'el fin'
