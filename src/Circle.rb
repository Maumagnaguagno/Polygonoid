class Circle

  attr_reader :cx, :cy, :radius

  PI2 = Math::PI * 2

  def initialize(cx, cy, radius)
    @cx = cx
    @cy = cy
    @radius = radius
  end

  def perimeter
    PI2 * @radius
  end

  def area
    Math::PI * @radius ** 2
  end

  def contain_point?(other)
    Math.hypot(@cx - other.x, @cy - other.y) <= @radius
  end

  def distance_to_point(other)
    dis = Math.hypot(@cx - other.x, @cy - other.y)
    dis <= @radius ? 0 : dis - @radius
  end

  def to_svg(style = 'fill:gray;stroke:black')
    "<circle cx=\"#{@cx}\" cy=\"#{@cy}\" r=\"#{@radius}\" style=\"#{style}\"><title>Circle #{@cx},#{@cy} #{@radius}</title></circle>\n"
  end
end