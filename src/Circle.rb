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

  def to_svg(style = 'fill:gray;stroke:black')
    "<circle cx=\"#{@cx}\" cy=\"#{@cy}\" r=\"#{@radius}\" style=\"#{style}\" title=\"Circle #{@cx},#{@cy} #{@radius}\"/>\n"
  end
end