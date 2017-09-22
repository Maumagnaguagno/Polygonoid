require_relative '../search/Search'
require_relative 'Circular'

start = Circle.new(0,80,0)
goal = Circle.new(1000,1000,0)
svg = svg_grid(1000,1000) << start.to_svg << goal.to_svg
t = Time.now.to_f
srand(0)
circles = Array.new(100) {Circle.new(50 + rand(1000), 50 + rand(1000), 5 + rand(50))}.each {|c| svg << c.to_svg}
puts 'search'
search(start, goal, circles, 'circular_search', svg)
p Time.now.to_f - t