#!/usr/bin/env ruby

puts '8.4.3 Date/time conversion methods'

require 'time'

# Date/time arithmetic
t_now         = Time.now   #
t_before_now  = t_now - 20 #
t_after_now   = t_now + 20 #

dt_now        = DateTime.now #
dt_before_now = dt_now - 20  #
dt_after_now  = dt_now + 20  #

dt_way_before_now = dt_now << 20
dt_way_after_now  = dt_now >> 20

today       = Date.today     #
tomorrow_1  = today.next     #
tomorrow_2  = today.next_day #

# yesterday_1 = today.prev     #
yesterday_2 = today.prev_day #

next_week   = today + 7
last_week   = today - 7

next_month  = today.next_month #
# last_month  = today.last_month #

next_year   = today.next_year  #
last_year   = today << 12      #

# Upto when?
puts "\n\nBetween today and tomorrow..."
today.upto(tomorrow_1) do |d|
  puts "date: #{d.to_s}"
end

puts "\n\nBetween today and next week"
today.upto(next_week) do |d|
  puts "date: #{d.to_s}"
end

# Downto when?
puts "\n\nBetween today and last week"
today.downto(last_week) do |d|
  puts "date: #{d.to_s}"
end

# Why iso8601?
# https://canvas.instructure.com/doc/api/live#!/courses.json/create_new_course_post_2

require_relative '../lib/sotimely'

def course_args(start_at, end_at)
  { 'course[name]'     => "So Timely #{Time.now.iso8601}",
    'course[start_at]' => start_at,
    'course[end_at]'   => end_at,
    'offer'            => true }
end

api = SoTimely::CanvasAPI.new

course_0   = api.create_course course_args((t_now - 10_000_000).strftime('%d %m %Y'), (t_now + 10_000_000).strftime('%Y %m %d'))
start_at_0 = course_0[:start_at] #
end_at_0   = course_0[:end_at]   #


course_1   = api.create_course course_args((t_now - 10_000_000).iso8601, (t_now + 10_000_000).iso8601)
start_at_1 = course_1[:start_at] #
end_at_1   = course_1[:end_at]   #

course_2   = api.create_course course_args(t_now.rfc2822, t_now.rfc2822)
start_at_2 = course_2[:start_at] #
end_at_2   = course_2[:end_at]   #

course_3   = api.create_course course_args(t_now.httpdate, t_now.httpdate)
start_at_3 = course_3[:start_at] #
end_at_3   = course_3[:end_at]   #

course_4   = api.create_course course_args(t_now.getlocal.iso8601, t_now.getlocal.iso8601)
start_at_4 = course_4[:start_at] #
end_at_4   = course_4[:end_at]   #

course_5   = api.create_course course_args((today << 12).strftime('%Y-%m-%d'), (today >> 12).strftime('%Y-%m-%d'))
start_at_5 = course_5[:start_at] #
end_at_5   = course_5[:end_at]   #

course_6   = api.create_course course_args(today.next_month.iso8601, today.next_year.iso8601)
start_at_6 = course_6[:start_at] #
end_at_6   = course_6[:end_at]   #

course_7   = api.create_course course_args((today << 12).iso8601, (today << 1).iso8601)
start_at_7 = course_7[:start_at] #
end_at_7   = course_7[:end_at]   #

puts 'el fin'
