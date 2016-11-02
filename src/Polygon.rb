class Polygon < Polyline

  def initialize(*vertices)
    super
    @edges << Line.new(vertices.last, vertices.first)
  end

  def to_svg
    svg = "<polygon points=\""
    @vertices.each {|p| svg << "#{p.x},#{p.y} "}
    svg << "\" style=\"fill:gray;stroke:black;stroke-width:1\"/>\n"
  end
end