require_relative '../Polygonoid'

def rect_to_svg(x, y, w, h, style)
  Polygon.new(
    Point.new(x,   y),
    Point.new(x+w, y),
    Point.new(x+w, y+h),
    Point.new(x,   y+h)
  ).to_svg(style)
end

def partition_environment(environment, tree = [])
  until environment.empty?
    tree << [environment.shift, []] if tree.none? {|branch|
      rect = environment.first
      outer_rect = branch.first
      if rect != outer_rect and outer_rect[0] <= rect[0] and (rect[0] + rect[2]) <= (outer_rect[0] + outer_rect[2]) and outer_rect[1] <= rect[1] and (rect[1] + rect[3]) <= (outer_rect[1] + outer_rect[3])
        partition_environment(environment, branch.last)
        true
      end
    }
  end
  tree
end

def partition_goals(goals, tree)
  rect_goals = Hash.new {|h,k| h[k] = []}
  until goals.empty?
    goal = goals.shift
    # Find subtree containing goal
    subtree = tree.first
    until subtree.last.none? {|branch|
        rect = branch.first
        subtree = branch if goal.x.between?(rect[0], rect[0] + rect[2]) and goal.y.between?(rect[1], rect[1] + rect[3])
      }
    end
    # Expand to all sides and check collisions
    outer_rect = subtree.first
    rect_right = (rect_left = outer_rect[0]) + outer_rect[2]
    rect_bottom = (rect_top = outer_rect[1]) + outer_rect[3]
    subtree.last.each {|rect,_|
      right = (left = rect[0]) + rect[2]
      bottom = (top = rect[1]) + rect[3]

      rect_left = left if left > rect_left and left < goal.x
      rect_left = right if right > rect_left and right < goal.x

      rect_right = left if left < rect_right and left > goal.x
      rect_right = right if right < rect_right and right > goal.x

      rect_top = top if top > rect_top and top < goal.y
      rect_top = bottom if bottom > rect_top and bottom < goal.y

      rect_bottom = top if top < rect_bottom and top > goal.y
      rect_bottom = bottom if bottom < rect_bottom and bottom > goal.y
    }
    rect_goals[[rect_left, rect_top, rect_right - rect_left, rect_bottom - rect_top]] << goal
  end
  # Further divide goals within same rect
  goal_rects = []
  rect_goals.each {|rect,rgoals|
    if rgoals.size != 1
      # TODO repeat for N goals
      g1 = rgoals.shift
      g2 = rgoals.shift
      # Vertical split
      if (g1.x - g2.x).abs <= (g1.y - g2.y).abs
        g1, g2 = g2, g1 if g1.y > g2.y
        ny = (g1.y + g2.y) / 2
        goal_rects << [
          rect, [
            [[rect[0], rect[1], rect[2], ny - rect[1]], g1],
            [[ny, rect[1], rect[2], rect[1] + rect[3] - ny], g2]
          ]
        ]
      # Horizontal split
      else
        g1, g2 = g2, g1 if g1.x > g2.x
        nx = (g1.x + g2.x) / 2
        goal_rects << [
          rect,
          [
            [[rect[0], rect[1], nx - rect[0], rect[3]], g1],
            [[nx, rect[1], rect[0] + rect[2] - nx, rect[3]], g2]
          ]
        ]
      end
    else goal_rects << [rect, rgoals.first]
    end
  }
  goal_rects
end

if $0 == __FILE__
  environment = [
    # Rects [x,y,w,h]
    [  0,   0, 500, 500],
    [350,   0,  20, 150],
    [245, 120,  20, 150],
    [175, 270, 175,  20],
    [245, 290,  20, 130],
    [350, 270,  20, 230],
    [370, 300, 130,  20],
    [  0, 365, 130,  20]
  ]

  goals = [
    Point.new(435,  75),
    Point.new(480, 200),
    Point.new(380, 250),
    Point.new(300,  50),
    Point.new(280, 200),
    Point.new(200, 150),
    Point.new(100, 150),
    Point.new(230, 330),
    Point.new( 50, 470),
    Point.new(450, 470)
  ]

  srand(2)
  svg = svg_grid(500, 500)
  environment.each {|rect| svg << rect_to_svg(*rect, "fill:##{rand(4096).to_s(16)};stroke:black")}
  svg_save('partition0.svg', svg, 500, 500)

  p environment_tree = partition_environment(environment.dup)
  p goal_tree = partition_goals(goals.dup, environment_tree)

  counter = 0
  queue = [goal_tree]
  until queue.empty?
    queue.shift.each {|rect,content|
      svg << rect_to_svg(*rect, "fill:##{rand(4096).to_s(16)};stroke:white;stroke-dasharray:2;opacity:0.7")
      content.instance_of?(Array) ? queue.push(content) : svg << content.to_svg('fill:none;stroke:black;stroke-width:10')
    }
  end
end