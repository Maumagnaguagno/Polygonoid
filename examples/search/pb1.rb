require_relative 'Linear'

plan = search(
  # Problem
  'pb1',
  # Start
  Point.new(80,50),
  # Goal
  Point.new(15,50),
  # Angle
  10,
  # Environment
  [
    Polygon.new(
      Point.new(35,30),
      Point.new(50,30),
      Point.new(50,50),
      Point.new(60,50),
      Point.new(55,70),
      Point.new(35,70)
    )
  ]
)

abort('Plan failed') if plan != [
  Point.new(80,50),
  Point.new(53.9287,25.0944),
  Point.new(34.4357,26.6385),
  Point.new(15,50)
]