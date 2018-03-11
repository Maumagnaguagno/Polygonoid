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

  def center
    a = cx = cy = 0
    p2 = @vertices.last
    @vertices.each {|p1|
      a += n = (p1.x * p2.y - p2.x * p1.y)
      cx += (p1.x + p2.x) * n
      cy += (p1.y + p2.y) * n
      p2 = p1
    }
    a6 = a * 3
    Point.new(cx.fdiv(a6), cy.fdiv(a6))
  end

  def contain_point?(point)
    winding = 0
    @edges.each {|e|
      if e.from.y <= point.y
        winding += 1 if e.to.y > point.y and e.point_side(point) > 0
      elsif e.to.y <= point.y and e.point_side(point) < 0
        winding -= 1
      end
    }
    winding != 0
  end

  def to_svg(style = 'fill:gray;stroke:black')
    v = @vertices.map {|p| "#{p.x},#{p.y}"}.join(' ')
    "<polygon points=\"#{v}\" style=\"#{style}\"><title>Polygon #{v}</title></polygon>\n"
  end
end