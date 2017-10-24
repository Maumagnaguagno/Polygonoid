# Based on https://redblobgames.github.io/circular-obstacle-pathfinding/
require_relative '../../Polygonoid'

CLOCK = true
COUNTER = false

def move(x, y, amount, angle)
  Point.new(x + amount * Math.cos(angle), y + amount * Math.sin(angle))
end

def internal_bitangent_lines(a, b, d)
  angle = Math.acos((a.radius + b.radius).fdiv(d))
  ab = Math.atan2(b.y - a.y, b.x - a.x)
  ba = Math.atan2(a.y - b.y, a.x - b.x)
  [
    Line.new(move(a.x, a.y, a.radius, ab - angle), move(b.x, b.y, b.radius, ba - angle)), # C to F
    Line.new(move(a.x, a.y, a.radius, ab + angle), move(b.x, b.y, b.radius, ba + angle)) # D to E
  ]
end

def external_bitangent_lines(a, b, d)
  angle = Math.acos((a.radius - b.radius).fdiv(d))
  ab = Math.atan2(b.y - a.y, b.x - a.x)
  [
    Line.new(move(a.x, a.y, a.radius, ab - angle), move(b.x, b.y, b.radius, ab - angle)), # C to F
    Line.new(move(a.x, a.y, a.radius, ab + angle), move(b.x, b.y, b.radius, ab + angle)) # D to E
  ]
end

def visible?(line, circles, a, b)
  circles.all? {|c| c == a or c == b or line.segment_distance_to_point(c) >= c.radius}
end

def center_distance(a, b)
  Math.hypot(a.x - b.x, a.y - b.y)
end

def bitangents(a, b, bitangents_clock, bitangents_counter, circles, bidir)
  d = center_distance(a, b)
  if a.radius + b.radius <= d
    l1, l2 = internal_bitangent_lines(a, b, d)
    if visible?(l1, circles, a, b)
      bitangents_clock[a] << [b, l1, bitangents_counter[b]]
      bitangents_clock[b] << [a, Line.new(l1.to, l1.from), bitangents_counter[a]] if bidir
    end
    if visible?(l2, circles, a, b)
      bitangents_counter[a] << [b, l2, bitangents_clock[b]]
      bitangents_counter[b] << [a, Line.new(l2.to, l2.from), bitangents_clock[a]] if bidir
    end
  end
  if (a.radius - b.radius).abs <= d
    l3, l4 = external_bitangent_lines(a, b, d)
    if visible?(l3, circles, a, b)
      bitangents_clock[a] << [b, l3, bitangents_clock[b]]
      bitangents_counter[b] << [a, Line.new(l3.to, l3.from), bitangents_clock[a]] if bidir
    end
    if visible?(l4, circles, a, b)
      bitangents_counter[a] << [b, l4, bitangents_counter[b]]
      bitangents_clock[b] << [a, Line.new(l3.to, l3.from), bitangents_clock[a]] if bidir
    end
  end
end

def each_bitangent(a, in_dir, circles)
  circles.each {|b|
    d = center_distance(a, b)
    if a.radius + b.radius <= d
      l1, l2 = internal_bitangent_lines(a, b, d)
      yield [b, l1, COUNTER] if in_dir == CLOCK and visible?(l1, circles, a, b)
      yield [b, l2, CLOCK] if in_dir == COUNTER and visible?(l2, circles, a, b)
    end
    if (a.radius - b.radius).abs <= d
      l3, l4 = external_bitangent_lines(a, b, d)
      yield [b, l3, CLOCK] if in_dir == CLOCK and visible?(l3, circles, a, b)
      yield [b, l4, COUNTER] if in_dir == COUNTER and visible?(l4, circles, a, b)
    end
  }
end

def precomputed_search(start, goal, circles, bitangents_clock, bitangents_counter, name = nil, svg = nil)
  # Greedy best-first search
  reachable_positions = [[start, start, bitangents_clock[start].concat(bitangents_counter[start])]]
  visited = []
  until reachable_positions.empty?
    circle, point, in_bitangents, plan = reachable_positions.shift
    # Build plan if goal visible
    return build_plan([goal], plan, name, svg) if visible?(Line.new(point, goal), circles, circle, goal)
    visited << point
    # Bitangents that go from current circle using current direction
    in_bitangents.each {|c,line,out_bitangents|
      reachable_positions << [c, line.to, out_bitangents, [line.to, [line.from, plan]]] unless visited.include?(line.to)
    }
    # Visible points are reachable positions
    # TODO consider radius in distance
    reachable_positions.sort_by! {|c| center_distance(c.first, goal)}
  end
end

def search(start, goal, circles, name = nil, svg = nil)
  # Greedy best-first search
  reachable_positions = [[start, start, CLOCK], [start, start, COUNTER]]
  visited = []
  until reachable_positions.empty?
    circle, point, in_dir, plan = reachable_positions.shift
    # Build plan if goal visible
    return build_plan([goal], plan, name, svg) if visible?(Line.new(point, goal), circles, circle, goal)
    visited << point
    # Bitangents that go from current circle using current direction
    each_bitangent(circle, in_dir, circles) {|c,line,out_dir|
      reachable_positions << [c, line.to, out_dir, [line.to, [line.from, plan]]] unless visited.include?(line.to)
    }
    # Visible points are reachable positions
    # TODO consider radius in distance
    reachable_positions.sort_by! {|c| center_distance(c.first, goal)}
  end
end