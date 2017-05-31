class Line

  attr_reader :from, :to, :slope, :y_intercept

  def initialize(from, to)
    @from = from
    @to = to
    @slope = (to.y - from.y).fdiv(to.x - from.x)
    @y_intercept = from.y - from.x * @slope unless vertical?
  end

  def ==(other)
    @from == other.from && @to == other.to
  end

  def perimeter
    @from.distance(@to)
  end

  def x_intercept
    @from.x - @from.y / @slope unless horizontal?
  end

  def vertical?
    @to.x.approx(@from.x)
  end

  def horizontal?
    @to.y.approx(@from.y)
  end

  def parallel_to?(other)
    @slope.abs == Float::INFINITY && other.slope.abs == Float::INFINITY || @slope.approx(other.slope)
  end

  def contain_point?(other)
    (@from.distance(other) + @to.distance(other)).approx(@from.distance(@to))
  end

  def distance_to_point(other)
    x1 = @from.x
    y1 = @from.y
    x2_x1 = @to.x - x1
    y2_y1 = @to.y - y1
    (x2_x1 * (y1 - other.y) - (x1 - other.x) * y2_y1).abs / Math.hypot(x2_x1, y2_y1)
  end

  def intersect_line(other)
    x1 = @from.x
    y1 = @from.y
    x2 = @to.x
    y2 = @to.y
    x3 = other.from.x
    y3 = other.from.y
    x4 = other.to.x
    y4 = other.to.y
    # When two lines are parallel or coincident the denominator is zero
    denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    if denominator.zero?
      # TODO return coincident line segment
      if contain_point?(other.from) then return other.from
      elsif contain_point?(other.to) then return other.to
      end
    else
      x1y2_x2y1 = x1 * y2 - x2 * y1
      x3y4_x4y3 = x3 * y4 - x4 * y3
      Point.new(
        (x1y2_x2y1 * (x3 - x4) - (x1 - x2) * x3y4_x4y3).fdiv(denominator),
        (x1y2_x2y1 * (y3 - y4) - (y1 - y2) * x3y4_x4y3).fdiv(denominator)
      )
    end
  end

  def intersect_line2(other)
    # TODO verify use
    return if vertical? or other.vertical?
    n = (other.y_intercept - @y_intercept) / (@slope - other.slope)
    Point.new(n, n * @slope + @y_intercept)
  end

  def intersect_line_angle(other)
    # TODO revise this method
    (Math.atan(@slope) - Math.atan(other.slope)).abs
  end

  def to_svg(style = 'stroke:black')
    "<line x1=\"#{@from.x}\" y1=\"#{@from.y}\" x2=\"#{@to.x}\" y2=\"#{@to.y}\" style=\"#{style}\"><title>Line #{@from.x},#{@from.y} #{@to.x},#{@to.y}</title></line>\n"
  end
end