class Line

  attr_reader :from, :to, :slope, :y_intercept

  def initialize(from, to)
    @from = from
    @to = to
    @slope = (to.y - from.y).fdiv(to.x - from.x)
    @y_intercept = from.y - from.x * @slope unless vertical?
  end

  def ==(other)
    instance_of?(other.class) and @from == other.from and @to == other.to
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
    @slope.abs == Float::INFINITY and other.slope.abs == Float::INFINITY or @slope.approx(other.slope)
  end

  def point_side(point)
    (point.x - @from.x) * (@to.y - @from.y) - (point.y - @from.y) * (@to.x - @from.x)
  end
  
  def contain_point?(point)
    point.y.approx(@slope * point.x + @y_intercept)
  end

  def segment_contain_point?(point)
    @from == point or @to == point or (
      (@from.x < @to.x ? point.x.between?(@from.x, @to.x) : point.x.between?(@to.x, @from.x)) and
      (@from.y < @to.y ? point.y.between?(@from.y, @to.y) : point.y.between?(@to.y, @from.y)) and
      contain_point?(point)
    )
  end

  def distance_to_point(point)
    x1 = @from.x
    y1 = @from.y
    x2_x1 = @to.x - x1
    y2_y1 = @to.y - y1
    (x2_x1 * (y1 - point.y) - (x1 - point.x) * y2_y1).abs / Math.hypot(x2_x1, y2_y1)
  end

  def segment_distance_to_point(point)
    x = @to.x - @from.x
    y = @to.y - @from.y
    l2 = x * x + y * y
    return point.distance(@to) if l2 == 0
    t = ((point.x - @from.x) * x + (point.y - @from.y) * y).fdiv(l2)
    t = (t > 0 ? (t < 1 ? t : 1) : 0)
    Math.hypot(point.x - @from.x - t * x, point.y - @from.y - t * y)
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
      if segment_contain_point?(other.from) then other.from
      elsif segment_contain_point?(other.to) then other.to
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
    Math.atan((@slope - other.slope) / (1 + @slope * other.slope)).abs
  end

  def to_svg(style = 'stroke:black')
    "<line x1=\"#{@from.x}\" y1=\"#{@from.y}\" x2=\"#{@to.x}\" y2=\"#{@to.y}\" style=\"#{style}\"><title>Line #{@from.x},#{@from.y} #{@to.x},#{@to.y}</title></line>\n"
  end
end