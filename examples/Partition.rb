require_relative '../NeonPolygon'

def rect_to_svg(x, y, w, h, style)
  Polygon.new(
    Point.new(x,   y),
    Point.new(x+w, y),
    Point.new(x+w, y+h),
    Point.new(x,   y+h)
  ).to_svg(style)
end

def within?(rect, outer_rect)
  rect_left = outer_rect[0]
  rect_right = rect_left + outer_rect[2]
  rect_top = outer_rect[1]
  rect_bottom = rect_top + outer_rect[3]
  rect != outer_rect and rect_left <= rect[0] and (rect[0] + rect[2]) <= rect_right and rect_top <= rect[1] and (rect[1] + rect[3]) <= rect_bottom
end

def partition_environment(environment, tree = [])
  until environment.empty?
    tree << [environment.shift, []] if tree.none? {|branch|
      if within?(environment.first, branch.first)
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
    # Expand to all sides and check collisions
    outer_rect = subtree.first
    rect_left = outer_rect[0]
    rect_right = rect_left + outer_rect[2]
    rect_top = outer_rect[1]
    rect_bottom = rect_top + outer_rect[3]
    subtree.last.each {|rect, _|
      rect_left = rect[0] if rect[0] > rect_left and rect[0] < goal.x
      rect_left = rect[0] + rect[2] if rect[0] + rect[2] > rect_left and rect[0] + rect[2] < goal.x

      rect_right = rect[0] if rect[0] < rect_right and rect[0] > goal.x
      rect_right = rect[0] + rect[2] if rect[0] + rect[2] < rect_right and rect[0] + rect[2] > goal.x

      rect_top = rect[1] if rect[1] > rect_top and rect[1] < goal.y
      rect_top = rect[1] + rect[3] if rect[1] + rect[3] > rect_top and rect[1] + rect[3] < goal.y

      rect_bottom = rect[1] if rect[1] < rect_bottom and rect[1] > goal.y
      rect_bottom = rect[1] + rect[3] if rect[1] + rect[3] < rect_bottom and rect[1] + rect[3] > goal.y
    }
    yield [rect_left, rect_top, rect_right - rect_left, rect_bottom - rect_top], goal
  end
  tree
end

def find_branch(goal, tree)
  return tree.first
  # TODO fix return value to include branch
  tree.last.each {|branch|
    rect = branch.first
    if goal.x.between?(rect[0], rect[0] + rect[2]) and goal.y.between?(rect[1], rect[1] + rect[3])
      return find_branch(goal, branch)
    end
  }
  tree
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
  Point.new(480,200),
  Point.new(380,250),
  Point.new(300,50),
  Point.new(280,200),
  Point.new(200,150),
  Point.new(100,150),
  Point.new(230,330),
  Point.new(50,470),
  Point.new(450,470)
]

srand(2)
svg = svg_grid(500, 500)
environment.each {|rect| svg << rect_to_svg(*rect, "fill:##{rand(4096).to_s(16)};stroke:black")}
svg_save('partition.svg', svg, 500, 500)

p tree = partition_environment(environment.dup)
counter = 0
partition_goals(goals.dup, tree) {|rect,goal|
  svg << rect_to_svg(*rect, "fill:##{rand(4096).to_s(16)};stroke:black;stroke-dasharray:2;opacity:0.7")
  svg << goal.to_svg('fill:none;stroke:black;stroke-width:10')
  svg_save("partition#{counter += 1}.svg", svg, 500, 500)
}