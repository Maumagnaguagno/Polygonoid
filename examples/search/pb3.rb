require_relative 'Linear'

plan = search(
  # Problem
  'pb3',
  # Start
  Point.new(5,40),
  # Goal
  Point.new(95,50),
  # Angle
  10,
  # Environment
  [
    Polygon.new(
      Point.new(10,5),
      Point.new(35,5),
      Point.new(35,80),
      Point.new(10,80),
    ),
    Polygon.new(
      Point.new(50,30),
      Point.new(90,30),
      Point.new(90,90),
      Point.new(50,90),
    )
  ]
)

abort('Plan failed') if plan != [
  Point.new(5,40),
  Point.new(2.9781,80.2605),
  Point.new(47.5943,98.0173),
  Point.new(90.7479,97.4854),
  Point.new(95,50)
]