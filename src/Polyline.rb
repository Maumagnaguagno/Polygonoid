class Polyline

  attr_reader :vertices, :edges

  def initialize(*vertices)
    @edges = []
    (@vertices = vertices).each_cons(2) {|v1,v2| @edges << Line.new(v1,v2)}
  end

  def perimeter
    @edges.inject(0) {|sum,edge| sum + edge.perimeter}
  end

  def to_svg(style = 'fill:none;stroke:black')
    v = @vertices.map {|p| "#{p.x},#{p.y}"}.join(' ')
    "<polyline points=\"#{v}\" style=\"#{style}\"><title>Polyline #{v}</title></polyline>\n"
  end
end