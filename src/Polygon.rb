class Polygon < Polyline

  def initialize(*vertices)
    super
    @edges << Line.new(vertices.last, vertices.first)
  end

  def area
    a = 0
    p2 = @vertices.last
    @vertices.each {|p1|
      a += p1.x * p2.y - p2.x * p1.y
      p2 = p1
    }
    a.fdiv(2)
  end

  def to_svg(style = 'fill:gray;stroke:black')
    v = @vertices.map {|p| "#{p.x},#{p.y}"}.join(' ')
    "<polygon points=\"#{v}\" style=\"#{style}\"><title>Polygon #{v}</title></polygon>\n"
  end
end