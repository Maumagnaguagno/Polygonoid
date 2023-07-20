require_relative 'Circular'

start = Circle.new(0,80,0)
goal = Circle.new(1000,1000,0)
svg = svg_grid << start.to_svg << goal.to_svg
bitangents_clock = Hash.new {|h,k| h[k] = []}
bitangents_counter = Hash.new {|h,k| h[k] = []}
puts 'Bitangent generation'
t = Time.now.to_f
srand(0)
circles = Array.new(100) {Circle.new(50 + rand(1000), 50 + rand(1000), 5 + rand(50))}
circles.each {|c|
  svg << c.to_svg
  # Start to circle
  Circular.bitangents(start, c, bitangents_clock, bitangents_counter, circles, false)
  # Circle to goal
  #bitangents(c, goal, bitangents_clock, bitangents_counter, circles, false)
}
# Circle to circle
# Equivalent but faster than circles.each {|a| circles.each {|b| bitangents(a, b, bitangents_clock, bitangents_counter, circles, false)}}
circles_dup = circles.dup
while a = circles_dup.shift
  circles_dup.each {|b| Circular.bitangents(a, b, bitangents_clock, bitangents_counter, circles, true)}
end

p Time.now.to_f - t
puts 'search'
Circular.precomputed_search(start, goal, circles, bitangents_clock, bitangents_counter, 'circular_search', svg)
p Time.now.to_f - t