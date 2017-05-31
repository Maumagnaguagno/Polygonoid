require_relative 'Search'

plan = search(
  # Problem
  'pb5',
  # Start
  Point.new(41,15),
  # Goal
  Point.new(22,8),
  # Angle
  10,
  # Environment
  [
    Polygon.new(
      Point.new(26,8),
      Point.new(26,34),
      Point.new(62,36),
      Point.new(52,26),
      Point.new(42,24)
    ),
    Polygon.new(
      Point.new(38,2),
      Point.new(52,18),
      Point.new(78,30),
      Point.new(68,6)
    ),
    Polygon.new(
      Point.new(2,12),
      Point.new(4,36),
      Point.new(20,36),
      Point.new(18,2)
    ),
    Polygon.new(
      Point.new(18,2),
      Point.new(26,8),
      Point.new(48,12),
      Point.new(38,2)
    )
  ]
)

abort('Plan failed') if plan != [
  Point.new(41,15),
  Point.new(74.8331,36.1970),
  Point.new(20.7988,45.5246),
  Point.new(22,8),
]