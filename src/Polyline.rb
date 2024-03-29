class Polyline

  attr_reader :vertices, :edges

  def initialize(*vertices)
    @edges = []
    (@vertices = vertices).each_cons(2) {|v1,v2| @edges << Line.new(v1,v2)}
  end

  def perimeter
    @edges.sum(&:perimeter)
  end

  def contain_point?(point)
    @edges.any? {|e| e.segment_contain_point?(point)}
  end

  def to_svg(style = 'fill:none;stroke:black')
    v = @vertices.map {|p| "#{p.x},#{p.y}"}.join(' ')
    "<polyline points=\"#{v}\" style=\"#{style}\"><title>Polyline #{v}</title></polyline>\n"
  end
end