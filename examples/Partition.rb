require_relative '../NeonPolygon'

def rect_to_svg(x, y, w, h)
  Polygon.new(
    Point.new(x,   y),
    Point.new(x+w, y),
    Point.new(x+w, y+h),
    Point.new(x,   y+h)
  ).to_svg("fill:##{rand(4096).to_s(16)};stroke:black")
end

environment = [
  # Rects [x,y,w,h]
  [0,0,500,500],
  [350,0,20,150],
  [245,120,20,150],
  [175,270,175,20],
  [245,290,20,130],
  [350,270,20,230],
  [370,300,130,20],
  [0,365,130,20]
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

srand(2)
svg = svg_grid(500, 500)
environment.each {|rect| svg << rect_to_svg(*rect)}
goals.each {|point| svg << point.to_svg}
svg_save('partition.svg', svg, 500, 500)


# TODO complete partition
def partition(environment, goals, rect = nil)
  if rect
    # Filter
    environment
    goals
  end
  until goals.empty?
    rect - find_outer_rect(environment) # TODO
     partition(environment, goals, rect)
  end
end