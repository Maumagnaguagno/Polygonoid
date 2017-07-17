# Goal R-tree
Partition space according to goals (defined by points) and obstacles (defined by rects).
The process starts finding the smallest local rects around goals using the horizontal and vertical lines of obstacles as reference.
If more than one goal is within such rect, it is going to be partitioned again to a more specific rect.
Local rects are clustered in intermediate rects by grouping nearest visible rect centroids.
A global rect contains such intermediate rects.

<p align="center">
<img src="https://cloud.githubusercontent.com/assets/11094484/21973541/3c5a49d4-dba0-11e6-8815-437fff6d9d9c.gif" alt="Animation with goals and rects being clustered"/>
</p>

## Execution
Execute with ``ruby pb1.rb``.
Previously generated SVGs are deleted to avoid mixing executions.

### Input
```Ruby
require_relative 'GoalRtree'

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

puts GoalRtree.generate(environment, goals)
```

### Output
```Ruby
global: [0, 0, 500, 500]
  intermediate: [265, 0, 235, 270]
    local: [370, 0, 130, 150]
      centroid: (435, 75)
      goal: (435, 75)
    local: [370, 150, 130, 120]
      centroid: (435, 210)
      specific: [430, 150, 70, 75]
        goal: (480, 200)
      specific: [370, 225, 60, 45]
        goal: (380, 250)
    local: [265, 150, 85, 120]
      centroid: (307, 210)
      goal: (280, 200)
    local: [265, 0, 85, 120]
      centroid: (307, 60)
      goal: (300, 50)
  intermediate: [0, 120, 245, 380]
    local: [175, 120, 70, 150]
      centroid: (210, 195)
      goal: (200, 150)
    local: [0, 120, 130, 150]
      centroid: (65, 195)
      goal: (100, 150)
    local: [175, 290, 70, 75]
      centroid: (210, 327)
      goal: (230, 330)
    local: [0, 420, 130, 80]
      centroid: (65, 460)
      goal: (50, 470)
  intermediate: [370, 320, 130, 180]
    local: [370, 320, 130, 180]
      centroid: (435, 410)
      goal: (450, 470)
```

Also SVGs are generated to better understand each step of the program.

## Pseudocode
```
environment = set of rectangles that describe walls and regions
goals = set of points of interest

goal_tree = map
for each goal in goals
  find bounding rect and all rects inside to consider as obstacles
  use visible obstacle corners as reference to find the smallest rectangle around goal
  goal_tree[rect] = partition rect in N parts for N goals
end

clusters = set
for each rect1 in goal_tree
  c1 = centroid of rect
  dist = infinity
  c = r = null
  for each rect2 in goal_tree
    c2 = centroid of rect
    d = distance between c1 and c2
    if c1 != c2 and d < dist and no obstacle between c1 and c2
      dist = d
      r = r2
      c = c2
    end
  end
  if c != null
    if find cluster in clusters includes (r1,c1)
      store (r,c) in cluster
      merge clusters if another cluster contains (r,c)
    elseif find cluster in clusters includes (r,c)
      store (r1,c1) in cluster
      merge clusters if another cluster contains (r1,c1)
    else
      clusters add cluster with (r1,c1) and (r,c)
    end
  else
    clusters add cluster with (r1,c1)
  end
end

global_rect = find bounding rect for clusters
print global_rect
for rects in clusters
  intermediate_rect = find bounding rect for rects
  print intermediate_rect
  for rect in rects
    local_rect = rect
    print local_rect
    find rect in goal tree
    if rect is split
      specific_rect = rect
      print specific rect
    end
  end
end
```

## ToDo's
- Intermediate rects may overlap in current implementation