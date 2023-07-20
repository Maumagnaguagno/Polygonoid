require_relative 'Linear'

plan = search(
  # Problem
  'pb2',
  # Start
  Point.new(65,65),
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
  Point.new(65,65),
  Point.new(56.0200,71.6505),
  Point.new(35.0309,73.6753),
  Point.new(15,50)
]