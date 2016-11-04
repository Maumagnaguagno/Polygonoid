class Point

  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    @x.approx(other.x) && @y.approx(other.y)
  end

  def distance(other)
    Math.hypot(@x - other.x, @y - other.y)
  end

  def to_svg(style = '')
    "<circle cx=\"#{@x}\" cy=\"#{@y}\" r=\"2\" #{style}/>\n"
  end
end