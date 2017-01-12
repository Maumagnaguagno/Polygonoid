# Goal R-tree

```
environment = set of rectangles that describe walls and regions
goals = set of points of interest

goal_tree = map
for each goal in goals
  find bounding rect and all rects inside to consider as obstacles
  use obstacles vertical and horizontal lines as reference to find the smallest rectangle around goal
  if rect maps to more than one goal
    r1, r2 = split rect in horizontal or vertical
  else
    goal_tree[rect] = goal
  end
end

clusters = set
for each rect1 in goal_tree
  c1 = centroid of rect
  dist = infinity
  c = r = null
  for each rect2 in goal_tree
    c2 = centroid of rect
    if c1 != c2 and (d = c1.distance(c2)) < dist and no obstacle between c1 and c2
      dist = d
      r = r2
      c = c2
    end
  end
  if c
    if cluster in clusters includes (r1,c1)
      store (r,c) in cluster
      merge clusters if another cluster contains (r,c)
    elseif cluster in clusters includes (r,c)
      store (r1,c1) in cluster
      merge clusters if another cluster contains (r1,c1)
    else
      clusters add (r1,c1) and (r,c)
    end
  else
    clusters add [(r1,c1)]
  end
end

global_rect = find bounding rect for environment
for rects in clusters
  intermediary_rect = find bounding rect for rects
  for rect in rects
    local_rect = rect
    find rect in goal tree
    if rect is split
      specific_rect = rect
    end
  end
end
```