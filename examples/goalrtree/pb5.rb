require_relative 'GoalRtree'

environment = [
  # Rects [x,y,w,h]
  [ 0,  0, 100, 300],
  [40, 80,  20, 220]
]

goals = [
  Point.new(10, 290),
  Point.new(90, 290),
  Point.new(62,  10),
  Point.new(38,  10)
]

tree = find_goalrtree(environment, goals, 'pb5')
puts tree

abort('Tree is different from expected') if tree !=
'global: [0, 0, 100, 300]
  intermediate: [0, 0, 100, 300]
    local: [0, 80, 40, 220]
      centroid: (20, 190)
      goal: (10, 290)
    local: [0, 0, 40, 80]
      centroid: (20, 40)
      goal: (38, 10)
    local: [60, 80, 40, 220]
      centroid: (80, 190)
      goal: (90, 290)
    local: [60, 0, 40, 80]
      centroid: (80, 40)
      goal: (62, 10)'