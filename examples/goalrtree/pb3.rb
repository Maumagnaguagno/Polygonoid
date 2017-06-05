require_relative 'GoalRtree'

environment = [
  # Rects [x,y,w,h]
  [0, 0, 100, 100],
]

goals = [
  Point.new(10, 50),
  Point.new(10, 60),
  Point.new(90, 50),
  Point.new(90, 60),
  Point.new(25, 25)
]

tree = GoalRtree.generate('pb3', environment, goals)
puts tree

abort('Tree is different from expected') if tree !=
'global: [0, 0, 100, 100]
  intermediate: [0, 0, 100, 100]
    local: [0, 0, 100, 100]
      centroid: (50, 50)
      specific: [0, 37, 17, 18]
        goal: (10, 50)
      specific: [0, 55, 17, 45]
        goal: (10, 60)
      specific: [57, 37, 43, 18]
        goal: (90, 50)
      specific: [57, 55, 43, 45]
        goal: (90, 60)
      specific: [17, 0, 40, 37]
        goal: (25, 25)'