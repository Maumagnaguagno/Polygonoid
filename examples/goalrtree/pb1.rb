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

find_tree(environment, goals)