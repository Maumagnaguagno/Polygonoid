require_relative '../Polygonoid'

def rect_to_polygon(x, y, w, h)
  Polygon.new(
    Point.new(x,   y),
    Point.new(x+w, y),
    Point.new(x+w, y+h),
    Point.new(x,   y+h)
  )
end

def visible?(a, b, environment)
  # Check if a line betweem a and b points intersects with each polygon edge from environment
  line = Line.new(a, b)
  environment.all? {|rect|
    rect_to_polygon(*rect).edges.none? {|e|
      (intersection = line.intersect_line(e)) && intersection != b && e.contain_point?(intersection) && line.contain_point?(intersection)
    }
  }
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
  # Divide goals within same rect
  goal_tree = []
  rect_goals.each {|rect,rgoals|
    if rgoals.size != 1
      # TODO repeat for N goals
      g1 = rgoals.shift
      g2 = rgoals.shift
      # Vertical split
      if (g1.x - g2.x).abs <= (g1.y - g2.y).abs
        g1, g2 = g2, g1 if g1.y > g2.y
        ny = (g1.y + g2.y) / 2
        goal_tree << [
          rect, [
            [[rect[0], rect[1], rect[2], ny - rect[1]], g1],
            [[ny, rect[1], rect[2], rect[1] + rect[3] - ny], g2]
          ]
        ]
      # Horizontal split
      else
        g1, g2 = g2, g1 if g1.x > g2.x
        nx = (g1.x + g2.x) / 2
        goal_tree << [
          rect,
          [
            [[rect[0], rect[1], nx - rect[0], rect[3]], g1],
            [[nx, rect[1], rect[0] + rect[2] - nx, rect[3]], g2]
          ]
        ]
      end
    else goal_tree << [rect, rgoals.first]
    end
  }
  # TODO expand rects to create upper layers
  goal_tree
end

if $0 == __FILE__
  # Remove old files
  File.delete(*Dir.glob('*.svg'))

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
  environment.each {|rect| svg << rect_to_polygon(*rect).to_svg("fill:##{rand(4096).to_s(16)};stroke:black")}
  svg_save('partition0.svg', svg)

  environment_tree = partition_environment(environment.dup)
  goal_tree = partition_goals(goals.dup, environment_tree)

  counter = 0
  queue = [goal_tree]
  until queue.empty?
    queue.shift.each {|rect,content|
      svg << rect_to_polygon(*rect).to_svg("fill:##{rand(4096).to_s(16)};stroke:white;stroke-dasharray:2;opacity:0.7")
      content.instance_of?(Array) ? queue.push(content) : svg << content.to_svg('fill:none;stroke:black;stroke-width:10')
      svg_save("partition#{counter += 1}.svg", svg)
    }
  end

  # Centroid visibility cluster
  clusters = []
  rect_centroids = goal_tree.map {|r,_| [r, Point.new(r[0] + r[2] / 2, r[1] + r[3] / 2)]}
  rect_centroids.each {|r1,c1|
    dist = 500 ** 2 # TODO rect_to_polygon(*rect).area
    c = r = nil
    rect_centroids.each {|r2,c2|
      if c1 != c2 and (d = c1.distance(c2)) < dist and visible?(c1, c2, environment)
        dist = d
        r = r2
        c = c2
      end
    }
    if c
      svg << Line.new(c1, c).to_svg('stroke:red')
      clusters << [[r1,r], [c1,c]] if clusters.none? {|cluster|
        if cluster.last.include?(c1)
          cluster.first << r
          cluster.last << c
          true
        elsif cluster.last.include?(c)
          cluster.first << r1
          cluster.last << c1
          true
        end
      }
    end
  }
  svg_save("partition#{counter += 1}.svg", svg)

  clusters.each {|rects,_|
    rect = rects.shift
    rect_right = (rect_left = rect[0]) + rect[2]
    rect_bottom = (rect_top = rect[1]) + rect[3]

    rects.each {|rect|
      right = (left = rect[0]) + rect[2]
      bottom = (top = rect[1]) + rect[3]

      rect_left = left if left > rect_left
      rect_left = right if right > rect_left

      rect_right = left if left < rect_right
      rect_right = right if right < rect_right

      rect_top = top if top > rect_top
      rect_top = bottom if bottom > rect_top

      rect_bottom = top if top < rect_bottom
      rect_bottom = bottom if bottom < rect_bottom
    }
    svg << rect_to_polygon(rect_left, rect_top, rect_right - rect_left, rect_bottom - rect_top).to_svg("fill:#fff;stroke:white;stroke-dasharray:2;opacity:0.5")
    svg_save("partition#{counter += 1}.svg", svg)
  }
end