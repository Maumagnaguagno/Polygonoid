require_relative '../../Polygonoid'

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
      # Horizontal split
      if (g1.x - g2.x).abs <= (g1.y - g2.y).abs
        g1, g2 = g2, g1 if g1.y > g2.y
        ny = (g1.y + g2.y) / 2
        goal_tree << [
          rect, [
            [[rect[0], rect[1], rect[2], ny - rect[1]], g1],
            [[rect[0], ny, rect[2], rect[1] + rect[3] - ny], g2]
          ]
        ]
      # Vertical split
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
  goal_tree
end

def divide_rect(rect, goals)
  if rgoals.size != 1
    specific_rects = []
    specific_top = rect[0]
    specific_left = rect[1]
    specific_right = rect[0] + rect[2]
    specific_bottom = rect[1] + rect[3]
    rgoals.each {|g1|
      rgoals.each {|g2|
        if g1 != g2
          # TODO
        end
      }
      specific_rects << [specific_top, specific_left, specific_right - specific_left, specific_bottom - specific_top]
    }
    [rect, specific_rects]
  else [rect, rgoals.first]
  end
end

def cluster_visible_rects(environment, goal_tree, max_distance, svg = nil, svg_filename = 'partition_clusters.svg')
  clusters = []
  # Use rect centroid as reference for visibility
  rect_centroids = goal_tree.map {|r,_| [r, Point.new(r[0] + r[2] / 2, r[1] + r[3] / 2)]}
  rect_centroids.each {|r1,c1|
    dist = max_distance
    c = r = nil
    rect_centroids.each {|r2,c2|
      if c1 != c2 and (d = c1.distance(c2)) < dist and visible?(c1, c2, environment)
        dist = d
        r = r2
        c = c2
      end
    }
    if c
      svg << Line.new(c1, c).to_svg('stroke:red') if svg
      clusters << [[r1,r], [c1,c]] if clusters.none? {|cluster|
        if cluster.last.include?(c1)
          unless cluster.last.include?(c)
            # TODO check if this connection merges two clusters
            cluster.first << r
            cluster.last << c
          end
          true
        elsif cluster.last.include?(c)
          unless cluster.last.include?(c1)
            # TODO check if this connection merges two clusters
            cluster.first << r1
            cluster.last << c1
          end
          true
        end
      }
    # Keep intermediate level with single element cluster
    else clusters << [[r1],[c1]]
    end
  }
  svg_save(svg_filename, svg) if svg
  clusters
end

def find_goalrtree(environment, goals)
  # Remove old files
  File.delete(*Dir.glob('partition*.svg'))

  environment_tree = partition_environment(environment.dup)
  goal_tree = partition_goals(goals.dup, environment_tree)

  srand(2)
  world_rect = environment_tree.first.first
  svg = svg_grid(world_rect[2], world_rect[3])
  environment.each {|rect| svg << rect_to_polygon(*rect).to_svg("fill:##{rand(4096).to_s(16)};stroke:black")}
  svg_save('partition0.svg', svg)

  global_right = goal_tree.first.first[2] - (global_left = goal_tree.first.first[0])
  global_bottom = goal_tree.first.first[3] - (global_top = goal_tree.first.first[1])
  counter = 0
  queue = [goal_tree]
  until queue.empty?
    queue.shift.each {|rect,content|
      # Global rect
      right = (left = rect[0]) + rect[2]
      bottom = (top = rect[1]) + rect[3]
      global_left = left if left < global_left
      global_right = right if right > global_right
      global_top = top if top < global_top
      global_bottom = bottom if bottom > global_bottom
      # Local rect
      svg << rect_to_polygon(*rect).to_svg("fill:##{rand(4096).to_s(16)};stroke:white;stroke-dasharray:2;opacity:0.7")
      content.instance_of?(Array) ? queue.push(content) : svg << content.to_svg('fill:none;stroke:black;stroke-width:10')
      svg_save("partition#{counter += 1}.svg", svg)
    }
  end

  global_width = global_right - global_left
  global_height = global_bottom - global_top
  hierarchy = "global: #{[global_left, global_top, global_width, global_height]}"
  cluster_visible_rects(environment, goal_tree, Math.hypot(global_width, global_height), svg, "partition#{counter += 1}.svg").each {|rects,centroids|
    # Intermediate rect
    rect = rects.shift
    rect_right = (rect_left = rect[0]) + rect[2]
    rect_bottom = (rect_top = rect[1]) + rect[3]
    rects.each {|left,top,width,height|
      right = left + width
      bottom = top + height
      rect_left = left if left < rect_left
      rect_right = right if right > rect_right
      rect_top = top if top < rect_top
      rect_bottom = bottom if bottom > rect_bottom
    }
    rects.unshift(rect)
    intermediate = [rect_left, rect_top, rect_right - rect_left, rect_bottom - rect_top]
    svg << rect_to_polygon(*intermediate).to_svg("fill:#fff;stroke:white;stroke-dasharray:2;opacity:0.5")
    svg_save("partition#{counter += 1}.svg", svg)
    hierarchy << "\n  intermediate: #{intermediate}"
    rects.zip(centroids) {|r,c|
      hierarchy << "\n    local: #{r}\n      centroid: (#{c.x}, #{c.y})"
      goals_within = goal_tree.assoc(r).last
      if goals_within.instance_of?(Array)
        goals_within.each {|specific,g|
          hierarchy << "\n      specific: #{specific}\n        goal: (#{g.x}, #{g.y})"
        }
      else
        hierarchy << "\n      goal: (#{goals_within.x}, #{goals_within.y})"
      end
    }
  }
  hierarchy
end