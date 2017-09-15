class Circle

  attr_reader :x, :y, :radius

  PI2 = Math::PI * 2

  def initialize(x, y, radius)
    @x = x
    @y = y
    @radius = radius
  end

  def ==(other)
    instance_of?(other.class) and @x.approx(other.x) and @y.approx(other.y) and @radius.approx(other.radius)
  end

  def perimeter
    PI2 * @radius
  end

  def area
    Math::PI * @radius ** 2
  end

  def contain_point?(point)
    Math.hypot(@x - point.x, @y - point.y) <= @radius
  end

  def distance_to_point(point)
    (d = Math.hypot(@x - point.x, @y - point.y) - @radius) <= 0 ? 0 : d
  end

  def to_svg(style = 'fill:gray;stroke:black')
    "<circle cx=\"#{@x}\" cy=\"#{@y}\" r=\"#{@radius}\" style=\"#{style}\"><title>Circle #{@x},#{@y} #{@radius}</title></circle>\n"
  end
end