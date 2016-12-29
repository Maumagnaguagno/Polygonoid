require_relative '../NeonPolygon'

def rect(x,y,w,h)
  Polygon.new(
    Point.new(x,   y),
    Point.new(x+w, y),
    Point.new(x+w, y+h),
    Point.new(x,   y+h)
  )
end

environment = [
  rect(0,0,500,500),
  rect(350,0,20,150),
  rect(245,120,20,150),
  rect(175,270,175,20),
  rect(245,290,20,130),
  rect(350,270,20,230),
  rect(370,300,130,20),
  rect(0,365,130,20),
#  Circle.new(90,125,25),
#  Circle.new(175,225,25),
#  Circle.new(425,240,25),
#  Circle.new(175,445,25)
]

goals = [
  Point.new(435,75),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0),
  Point.new(0,0)
]

svg = svg_grid(500, 500)
environment.each {|polygon| svg << polygon.to_svg('fill:white;stroke:black')}
goals.each {|point| svg << point.to_svg}
svg_save('partition.svg', svg, 500, 500)