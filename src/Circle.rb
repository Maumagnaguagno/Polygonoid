class Circle

  attr_reader :cx, :cy, :radius

  PI2 = Math::PI * 2

  def initialize(cx, cy, radius)
    @cx = cx
    @cy = cy
    @radius = radius
  end

  def ==(other)
    instance_of?(other.class) and @cx.approx(other.cx) and @cy.approx(other.cy) and @radius.approx(other.radius)
  end

  def perimeter
    PI2 * @radius
  end

  def area
    Math::PI * @radius ** 2
  end

  def contain_point?(point)
    Math.hypot(@cx - point.x, @cy - point.y) <= @radius
  end

  def distance_to_point(point)
    (d = Math.hypot(@cx - point.x, @cy - point.y) - @radius) <= 0 ? 0 : d
  end

  def to_svg(style = 'fill:gray;stroke:black')
    "<circle cx=\"#{@cx}\" cy=\"#{@cy}\" r=\"#{@radius}\" style=\"#{style}\"><title>Circle #{@cx},#{@cy} #{@radius}</title></circle>\n"
  end
end