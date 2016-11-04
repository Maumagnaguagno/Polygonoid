class Polyline

  attr_reader :vertices, :edges

  def initialize(*vertices)
    @edges = []
    (@vertices = vertices).each_cons(2) {|v1,v2| @edges << Line.new(v1,v2)}
  end

  def perimeter
    @edges.inject(0) {|sum,edge| sum + edge.perimeter}
  end

  def to_svg(style = 'style="fill:none;stroke:black"')
    svg = "<polyline points=\""
    @vertices.each {|p| svg << "#{p.x},#{p.y} "}
    svg << "\" #{style}/>\n"
  end
end