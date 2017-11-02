#!/usr/bin/env ruby

puts 'why sets?'

require 'set'

# N: experiment by making N bigger
range = 0..10_000
# range = 0..100_000

set = Set.new
array = []

# measure Set#add
start = Time.now
range.each do |i|
  set.add i
end
finish = Time.now
duration = finish - start
puts "Set#add -> #{duration} seconds" # when N =  10_000: "Set#add -> 0.001987 seconds"
                                      # when N = 100_000: "Set#add -> 0.255430 seconds"

# measure Array#<<
start = Time.now
range.each do |i|
  array << i
end
finish = Time.now
duration = finish - start
puts "Array#<< -> #{duration} seconds" # when N =  10_000: "Array#<< -> 0.000647 seconds"
                                       # when N = 100_000: "Array#<< -> 0.005803 seconds"

# measure Set#include?
start = Time.now
range.each do |i|
  set.include? i
end
finish = Time.now
duration = finish - start
puts "Set#include? -> #{duration} seconds" # when N =  10_000: "Set#include? -> 0.000832 seconds"
                                           # when N = 100_000: "Set#include? -> 0.013619 seconds"

# measure Array#include?
start = Time.now
range.each do |i|
  array.include? i
end
finish = Time.now
duration = finish - start
puts "Array#include? -> #{duration} seconds" # when N =  10_000: "Array#include? ->  0.256467 seconds"
                                             # when N = 100_000: "Array#include? -> 26.806433 seconds"

