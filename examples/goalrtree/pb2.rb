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

tree = find_goalrtree(environment, goals)
puts tree