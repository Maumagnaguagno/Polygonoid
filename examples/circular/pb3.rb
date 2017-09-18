require_relative '../search/Search'
require_relative 'Circular'

def search(svg, start, goal, circles, bitangents_clock, bitangents_counter)
  # Greedy best-first search
  reachable_positions = [[start, start, bitangents_clock[start].concat(bitangents_counter[start])]]
  visited = []
  visible_points = []
  until reachable_positions.empty?
    circle, point, in_bitangents, plan = reachable_positions.shift
    visited << point
    # Build plan if goal visible test
    return build_plan([goal], plan, 'circular_search', svg) if visible?(Line.new(point, goal), circles, circle, goal)
    # Bitangents that go from current circle using current direction
    in_bitangents.each {|c,line,out_bitangents|
      visible_points << [c, line.to, out_bitangents, [line.to, [line.from, plan]]] unless visited.include?(line.to)
    }
    # Visible points are reachable positions
    # TODO consider radius in distance
    reachable_positions.concat(visible_points).sort_by! {|c| center_distance(c.first, goal)}
    visible_points.clear
  end
end

start = Circle.new(0,80,0)
goal = Circle.new(1000,1000,0)
svg = svg_grid(1000,1000) << start.to_svg << goal.to_svg
bitangents_clock = Hash.new {|h,k| h[k] = []}
bitangents_counter = Hash.new {|h,k| h[k] = []}
puts 'Bitangent generation'
t = Time.now.to_f
srand(0)
circles = Array.new(100) {Circle.new(50 + rand(1000), 50 + rand(1000), 5 + rand(50))}
circles.each {|c|
  svg << c.to_svg
  # Start to circle
  bitangents(start, c, bitangents_clock, bitangents_counter, circles, false)
  # Circle to goal
  #bitangents(c, goal, bitangents_clock, bitangents_counter, circles, false)
}
# Circle to circle
# Equivalent but faster than circles.each {|a| circles.each {|b| bitangents(a, b, bitangents_clock, bitangents_counter, circles, false)}}
circles_dup = circles.dup
while a = circles_dup.shift
  circles_dup.each {|b| bitangents(a, b, bitangents_clock, bitangents_counter, circles, true)}
end

p Time.now.to_f - t
puts 'search'
search(svg, start, goal, circles, bitangents_clock, bitangents_counter)
p Time.now.to_f - t