require_relative 'GoalRtree'

environment = [
  # Rects [x,y,w,h]
  [0, 0, 100, 100],
]

goals = [
  Point.new(10, 50),
  Point.new(10, 60),
  Point.new(90, 50),
  Point.new(90, 60)
]

tree = GoalRtree.generate('pb2', environment, goals)
puts tree

abort('Tree is different from expected') if tree !=
'global: [0, 0, 100, 100]
  intermediate: [0, 0, 100, 100]
    local: [0, 0, 100, 100]
      centroid: (50, 50)
      specific: [0, 0, 50, 55]
        goal: (10, 50)
      specific: [0, 55, 50, 45]
        goal: (10, 60)
      specific: [50, 0, 50, 55]
        goal: (90, 50)
      specific: [50, 55, 50, 45]
        goal: (90, 60)'