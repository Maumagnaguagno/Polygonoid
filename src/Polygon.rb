class Polygon < Polyline

  def initialize(*vertices)
    super
    @edges << Line.new(vertices.last, vertices.first)
  end

  def to_svg(style = 'fill:gray;stroke:black')
    v = @vertices.map {|p| "#{p.x},#{p.y}"}.join(' ')
    "<polygon points=\"#{v}\" style=\"#{style}\"><title>Polygon #{v}</title></polygon>\n"
  end
end