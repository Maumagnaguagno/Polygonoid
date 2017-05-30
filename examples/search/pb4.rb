require_relative 'Search'

plan = search(
  # Problem
  'pb4',
  # Start
  Point.new(22.0,8.0),
  # Goal
  Point.new(41.0,15.0),
  # Angle
  5,
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
  Point.new(22,8),
  Point.new(23.7187,34.2496),
  Point.new(61.7017,39.3297),
  Point.new(78.7511,31.4559),
  Point.new(41,15),
]