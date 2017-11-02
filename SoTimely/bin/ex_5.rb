#!/usr/bin/env ruby

puts '8.4.2 Date/time query methods'

require 'time'

dt_now = DateTime.now
t_now  = Time.now

# DateTime queries
dt_year   = dt_now.year   #
dt_month  = dt_now.month  #
dt_day    = dt_now.day    #
dt_hour   = dt_now.hour   #
dt_minute = dt_now.minute #
dt_second = dt_now.second #

# Time queries
t_year    = t_now.year    #
t_month   = t_now.month   #
t_day     = t_now.day     #
t_hour    = t_now.hour    #
t_minute  = t_now.min     #
t_second  = t_now.sec     #

# Days of the week
sunday    = dt_now.sunday?    #
monday    = dt_now.monday?    #
tuesday   = dt_now.tuesday?   #
wednesday = dt_now.wednesday? #
thursday  = dt_now.thursday?  #
friday    = dt_now.friday?    #
saturday  = dt_now.saturday?  #

# Leap year
leap_year    = dt_now.leap?      #
dt_2020      = DateTime.new 2020 #
dt_2020_leap = dt_2020.leap?     #

puts 'el fin'
