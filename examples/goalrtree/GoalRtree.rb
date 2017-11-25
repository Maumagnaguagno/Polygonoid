require_relative '../../Polygonoid'

module GoalRtree
  extend self

  def rect_to_polygon(x, y, w, h)
    Polygon.new(
      Point.new(x,   y),
      Point.new(x+w, y),
      Point.new(x+w, y+h),
      Point.new(x,   y+h)
    )
  end

  def partition_environment(environment, tree = [])
    until environment.empty?
      tree << [environment.shift, []] if tree.none? {|branch|
        rect = environment.first
        outer_rect = branch.first
        if rect != outer_rect and outer_rect[0] <= rect[0] and (rect[0] + rect[2]) <= (outer_rect[0] + outer_rect[2]) and outer_rect[1] <= rect[1] and (rect[1] + rect[3]) <= (outer_rect[1] + outer_rect[3])
          partition_environment(environment, branch.last)
        end
      }
    end
    tree
  end

  def partition_goals(environment_polygons, goals, tree)
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
      # Expand to all sides and check collisions with visible corners
      outer_rect = subtree.first
      rect_right = (rect_left = outer_rect[0]) + outer_rect[2]
      rect_bottom = (rect_top = outer_rect[1]) + outer_rect[3]
      subtree.last.each {|rect,_|
        right = (left = rect[0]) + rect[2]
        bottom = (top = rect[1]) + rect[3]

        visible_top_left     = visible?(goal, Point.new(left,  top), environment_polygons)
        visible_top_right    = visible?(goal, Point.new(right, top), environment_polygons)
        visible_bottom_right = visible?(goal, Point.new(right, bottom), environment_polygons)
        visible_bottom_left  = visible?(goal, Point.new(left,  bottom), environment_polygons)

        if visible_top_left or visible_bottom_left
          if left > rect_left and left < goal.x then rect_left = left
          elsif left < rect_right and left > goal.x then rect_right = left
          end
        end

        if visible_top_right or visible_bottom_right
          if right > rect_left and right < goal.x then rect_left = right
          elsif right < rect_right and right > goal.x then rect_right = right
          end
        end

        if visible_top_left or visible_top_right
          if top > rect_top and top < goal.y then rect_top = top
          elsif top < rect_bottom and top > goal.y then rect_bottom = top
          end
        end

        if visible_bottom_left or visible_bottom_right
          if bottom > rect_top and bottom < goal.y then rect_top = bottom
          elsif bottom < rect_bottom and bottom > goal.y then rect_bottom = bottom
          end
        end
      }
      rect_goals[[rect_left, rect_top, rect_right - rect_left, rect_bottom - rect_top]] << goal
    end
    # Divide goals within same rect
    rect_goals.map {|rect,rgoals| divide_rect(rect, rgoals)}
  end

  def divide_rect(rect, rgoals)
    if rgoals.size != 1
      specific_rects = []
      rgoals.each {|g1|
        g1_right = (g1_left = rect[0]) + rect[2]
        g1_bottom = (g1_top = rect[1]) + rect[3]
        rgoals.each {|g2|
          if g1 != g2
            x = (g1.x + g2.x) / 2
            y = (g1.y + g2.y) / 2
            if g1.x > x then g1_left = x if x > g1_left
            elsif g1.x < x then g1_right = x if x < g1_right
            end
            if g1.y > y then g1_top = y if y > g1_top
            elsif g1.y < y then g1_bottom = y if y < g1_bottom
            end
          end
        }
        specific_rects << [[g1_left, g1_top, g1_right - g1_left, g1_bottom - g1_top], g1]
      }
      [rect, specific_rects]
    else [rect, rgoals.first]
    end
  end

  def connect_rect_to_cluster(clusters, centroids, rects, r, c, include)
    unless include
      # New connection merges two clusters
      if index = clusters.index {|cluster2| cluster2.last.include?(c)}
        rects.concat(clusters[index].first)
        centroids.concat(clusters[index].last)
        clusters.delete_at(index)
      else
        rects << r
        centroids << c
      end
    end
    true
  end

  def cluster_visible_rects(environment_polygons, goal_tree, max_distance, svg = nil, svg_filename = nil, view = nil)
    clusters = []
    # Use rect centroid as reference for visibility
    rect_centroids = goal_tree.map {|r,_| [r, Point.new(r[0] + r[2] / 2, r[1] + r[3] / 2)]}
    rect_centroids.each {|r1,c1|
      dist = max_distance
      c = r = nil
      rect_centroids.each {|r2,c2|
        if c1 != c2 and (d = c1.distance(c2)) < dist and visible?(c1, c2, environment_polygons)
          dist = d
          r = r2
          c = c2
        end
      }
      if c
        svg << Line.new(c1, c).to_svg('stroke:red') if svg
        clusters << [[r1,r], [c1,c]] if clusters.none? {|rects,centroids|
          include_c  = centroids.include?(c)
          include_c1 = centroids.include?(c1)
          if include_c1
            connect_rect_to_cluster(clusters, centroids, rects, r, c, include_c)
          elsif include_c
            connect_rect_to_cluster(clusters, centroids, rects, r1, c1, include_c1)
          end
        }
      # Keep intermediate level with single element cluster
      else clusters << [[r1],[c1]]
      end
    }
    svg_save(svg_filename, svg, view) if svg
    clusters
  end

  def generate(name, environment, goals)
    # Remove old files
    File.delete(*Dir.glob("#{name}*.svg"))

    environment_polygons = environment.map {|rect| rect_to_polygon(*rect)}
    environment_tree = partition_environment(environment.dup)
    goal_tree = partition_goals(environment_polygons, goals.dup, environment_tree)

    srand(2)
    world_rect = environment_tree.first.first
    svg = ''
    environment_polygons.each {|polygon| svg << polygon.to_svg("fill:##{rand(4096).to_s(16)};stroke:black")}
    svg_save("#{name}_0.svg", svg, view = "width=\"#{world_rect[2]}\" height=\"#{world_rect[3]}\" viewBox=\"#{world_rect[0]} #{world_rect[1]} #{world_rect[2]} #{world_rect[3]}\"")

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
        svg_save("#{name}_#{counter += 1}.svg", svg, view)
      }
    end

    global_width = global_right - global_left
    global_height = global_bottom - global_top
    hierarchy = "global: #{[global_left, global_top, global_width, global_height]}"
    cluster_visible_rects(environment_polygons, goal_tree, Math.hypot(global_width, global_height), svg, "#{name}_#{counter += 1}.svg", view).each {|rects,centroids|
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
      svg_save("#{name}_#{counter += 1}.svg", svg, view)
      hierarchy << "\n  intermediate: #{intermediate}"
      rects.zip(centroids) {|r,c|
        hierarchy << "\n    local: #{r}\n      centroid: (#{c.x}, #{c.y})"
        goals_within = goal_tree.assoc(r).last
        if goals_within.instance_of?(Array)
          goals_within.each {|specific,g| hierarchy << "\n      specific: #{specific}\n        goal: (#{g.x}, #{g.y})"}
        else hierarchy << "\n      goal: (#{goals_within.x}, #{goals_within.y})"
        end
      }
    }
    hierarchy
  end
end