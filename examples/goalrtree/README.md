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
    goal_tree[r1] = goal
    goal_tree[r2] = already stored goal
  else
    goal_tree[rect] = goal
  end
end

clusters = array
for each rect1 in goal_tree
  c1 = centroid of rect
  dist = infinity
  c = r = null
  for each rect2 in goal_tree
    c2 = centroid of rect
    if c1 != c2 and (d = c1.distance(c2)) < dist and visible(c1, c2, environment)
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
      clusters add [(r1,c1), (r,c)]
    end
  else
    clusters add [(r1,c1)]
  end
end
```