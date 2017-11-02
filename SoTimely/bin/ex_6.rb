#!/usr/bin/env ruby

puts '8.4.2 Date/time query methods'

require 'time'

# #strftime uses the Unix strftime(3) system library

now = Time.now

now_str_01 = now.strftime('%m-%d-%y')  #
now_str_02 = now.strftime('%m %d %y')  #
now_str_03 = now.strftime('%M %d %Y')  #
now_str_04 = now.strftime('%B %d %Y')  #
now_str_05 = now.strftime('%B %d, %Y') #
now_str_06 = now.strftime('%B %D, %Y') #
now_str_07 = now.strftime('%D')        #
now_str_08 = now.strftime('%c')        #
now_str_09 = now.strftime('%x')        #
now_str_10 = now.strftime('%C')        #
now_str_12 = now.strftime('%I:%M:%s')  #
now_str_13 = now.strftime('%s')        #
now_str_14 = now.strftime('%I:%M:%S')  #
now_str_15 = now.strftime('now is %I:%M:%S on this day %D')

# Locale
locale_1 = now.strftime('%c')
locale_2 = now.strftime('%x')

# Specifications
email   = now.rfc2822  #
http    = now.httpdate #
iso8601 = now.iso8601  #

# Why iso8601?
# https://canvas.instructure.com/doc/api/live#!/courses.json/create_new_course_post_2

puts 'el fin'
