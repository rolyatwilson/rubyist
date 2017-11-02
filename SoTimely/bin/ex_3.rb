#!/usr/bin/env ruby

puts '8.4.1 Instantiating date/time objects'
puts 'Creating Time Objects'

require 'time'

# What time is it now?
now = Time.new

# What are the default values for the constructor?
init_01 = Time.new 2013                           #
init_02 = Time.new 2013, 12                       #
init_03 = Time.new 2013, 12, 17                   #
init_04 = Time.new 2013, 12, 17, 14               #
init_05 = Time.new 2013, 12, 17, 14, 37           #
init_06 = Time.new 2013, 12, 17, 14, 37, 11       #
init_07 = Time.new 2013, 12, 17, 14, 37, 11, 0    #

# Is #mktime any different?
init_08 = Time.mktime 2013                        #
init_09 = Time.mktime 2013, 12                    #
init_10 = Time.mktime 2013, 12, 17                #
init_11 = Time.mktime 2013, 12, 17, 14            #
init_12 = Time.mktime 2013, 12, 17, 14, 37        #
init_13 = Time.mktime 2013, 12, 17, 14, 37, 11    #
init_14 = Time.mktime 2013, 12, 17, 14, 37, 11, 0 #

# What about #local?
init_15 = Time.local 2013                         #
init_16 = Time.local 2013, 12                     #
init_17 = Time.local 2013, 12, 17                 #
init_18 = Time.local 2013, 12, 17, 14             #
init_19 = Time.local 2013, 12, 17, 14, 37         #
init_20 = Time.local 2013, 12, 17, 14, 37, 11     #
init_21 = Time.local 2013, 12, 17, 14, 37, 11, 0  #

# And #gm?
init_22 = Time.gm 2013                            #
init_23 = Time.gm 2013, 12                        #
init_24 = Time.gm 2013, 12, 17                    #
init_25 = Time.gm 2013, 12, 17, 14                #
init_26 = Time.gm 2013, 12, 17, 14, 37            #
init_27 = Time.gm 2013, 12, 17, 14, 37, 11        #
init_28 = Time.gm 2013, 12, 17, 14, 37, 11, 4     #

# String parsing
from_string_01 = Time.parse '2013/12/17'                      #
# from_string_02 = Time.parse '12/17/2013'                      #
from_string_03 = Time.parse '2013/12/17 14'                   #
from_string_04 = Time.parse '2013/12/17 14:37'                #
from_string_05 = Time.parse '2013/12/17 14:37:11'             #
from_string_06 = Time.parse '2013/12/17 14 37 11'             #
from_string_07 = Time.parse '2013/12/17 14_37_11'             #
# from_string_08 = Time.parse '2013/12/17 14-37-11'             #
from_string_09 = Time.parse '2013/12/17 14:37:11 UTC'         #
from_string_10 = Time.parse '2013/12/17 14:37:11 GMT'         #
from_string_11 = Time.parse '2013/12/17 14:37:11 EST'         #
from_string_12 = Time.parse '2013/12/17 14:37:11 CST'         #
from_string_13 = Time.parse '2013/12/17 14:37:11 MST'         #
from_string_14 = Time.parse '2013/12/17 14:37:11 PST'         #
from_string_15 = Time.parse '2013/12/17 14:37:11 LOCAL'       #
from_string_16 = Time.parse '2013/12/17 14:37:11 JIBBERISH'   #
from_string_17 = Time.parse '2013/12/17 2:37:11 AM JIBBERISH' #
from_string_18 = Time.parse '2013/12/17 2:37:11 PM JIBBERISH' #

# Scanning
scan_1 = Time.strptime '2013-12-17 02:37:11', '%Y-%m-%d %I:%M:%S'
scan_2 = Time.strptime '17-2013-12 37:02:11', '%d-%Y-%m %M:%I:%S'
scan_3 = Time.strptime '03-09-2013 14:37:11', '%m-%d-%Y %H:%M:%S'

puts 'el fin'
