class Polygon < Polyline

  def initialize(*vertices)
    super
    @edges << Line.new(vertices.last, vertices.first)
  end

  def to_svg(style = 'style="fill:gray;stroke:black"')
    svg = "<polygon points=\""
    @vertices.each {|p| svg << "#{p.x},#{p.y} "}
    svg << "\" #{style}/>\n"
  end
end