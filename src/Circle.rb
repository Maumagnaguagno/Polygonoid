class Circle

  attr_reader :cx, :cy, :radius

  def initialize(cx, cy, radius)
    @cx = cx
    @cy = cy
    @radius = radius
  end

  def perimeter
    
  end

  def area
    
  end

  def to_svg(style = '')
    "<circle cx=\"#{@cx}\" cy=\"#{@cy}\" r=\"#{@radius}\" #{style}/>\n"
  end
end