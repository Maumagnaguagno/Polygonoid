require_relative '../NeonPolygon'

def rect_to_svg(x, y, w, h)
  Polygon.new(
    Point.new(x,   y),
    Point.new(x+w, y),
    Point.new(x+w, y+h),
    Point.new(x,   y+h)
  ).to_svg("fill:##{rand(4096).to_s(16)};stroke:black")
end

def within?(rect, outer_rect)
  rect_left = outer_rect[0]
  rect_right = rect_left + outer_rect[2]
  rect_top = outer_rect[1]
  rect_bottom = rect_top + outer_rect[3]
  rect != outer_rect and rect_left <= rect[0] and (rect[0] + rect[2]) <= rect_right and rect_top <= rect[1] and (rect[1] + rect[3]) <= rect_bottom
end

def partition_environment(environment, tree = [])
  while rect = environment.shift
    tree << [rect, []] if tree.none? {|branch|
      if within?(rect, branch.first)
        partition_environment(environment, branch.last)
        true
      end
    }
  end
  tree
end

def partition_goals(goals, tree)
  until goals.empty?
    goal = goals.shift
    subtree = find_branch(goal, tree)
    
  end
  tree
end

def find_branch(goal, tree)
  tree.each {|branch|
    rect = branch.first
    if goal.x.between?(rect[0], rect[0] + rect[2]) and goal.y.between?(rect[1], rect[1] + rect[3])
      return find_branch(goal, branch.last)
    end
  }
end

# This method is not completed and may be destroyed in the future
def partition(environment, goals, rect = nil)
  if rect
    # Filter
    rect_left = rect[0]
    rect_right = rect_left + rect[2]
    rect_top = rect[1]
    rect_bottom = rect_top + rect[3]
    environment = environment.select {|r| rect != r and rect_left <= r[0] and (r[0] + r[2]) <= rect_right and rect_top <= r[1] and (r[1] + r[3]) <= rect_bottom}
    goals = goals.select {|g| g.x.between?(rect_left, rect_right) and g.y.between?(rect_top, rect_bottom)}
  end
  until goals.empty?
    rect = find_bounding_box(environment) # TODO implement
    partition(environment, goals, rect)
  end
end

environment = [
  # Rects [x,y,w,h]
  [0,0,500,500],
  [350,0,20,150],
  [245,120,20,150],
  [175,270,175,20],
  [245,290,20,130],
  [350,270,20,230],
  [370,300,130,20],
  [0,365,130,20]
]

goals = [
  Point.new(435,75),
=begin
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0)
=end
]

srand(2)
svg = svg_grid(500, 500)
environment.each {|rect| svg << rect_to_svg(*rect)}
goals.each {|point| svg << point.to_svg}
svg_save('partition.svg', svg, 500, 500)

p tree = partition_environment(environment)
partition_goals(goals, tree)
p tree