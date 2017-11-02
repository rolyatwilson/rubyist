#!/usr/bin/env ruby

puts '9.1 Array and hashes in comparison'

# Arrays are ordered
# Hashes? Old ruby => unordered, new ruby => ordered

array_1 = ['ruby', 'diamond', 'emerald'] #
array_2 = %w[ruby diamond emerald]       #

hash_1  = { 0 => 'ruby', 1 => 'diamond', 2 => 'emerald' }

the_same_1 = array_1.eql? array_2       #
the_same_2 = array_1.eql? hash_1        #
the_same_3 = array_1.eql? hash_1.values #

(0...array_1.length).each do |i|
  puts "#{array_1[i]} is the same as #{hash_1.values[i]} .... yes?"
  puts "\t\t #{array_1[i] == hash_1.values[i]}!"
end

# But if that's ^^^ how you use hashes I think you're using them wrong
hash_2  = { ruby: 'red', diamond: 'idk clearish maybe', emerald: 'green' }

puts hash_2[:ruby]
puts hash_2[:diamond]
puts hash_2[:emerald]

puts 'el fin'
