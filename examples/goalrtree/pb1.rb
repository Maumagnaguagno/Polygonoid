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

tree = find_goalrtree(environment, goals)
puts tree

abort('Tree is different from expected') if tree != 
'global: [0, 0, 500, 500]
  intermediate: [265, 0, 235, 270]
    local: [370, 0, 130, 120]
      centroid: (435, 60)
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
  intermediate: [0, 120, 245, 150]
    local: [175, 120, 70, 150]
      centroid: (210, 195)
      goal: (200, 150)
    local: [0, 120, 130, 150]
      centroid: (65, 195)
      goal: (100, 150)
  intermediate: [0, 320, 245, 180]
    local: [175, 320, 70, 45]
      centroid: (210, 342)
      goal: (230, 330)
    local: [0, 420, 130, 80]
      centroid: (65, 460)
      goal: (50, 470)
  intermediate: [370, 420, 130, 80]
    local: [370, 420, 130, 80]
      centroid: (435, 460)
      goal: (450, 470)'