# NeonPolygon [![Build Status](https://travis-ci.com/Maumagnaguagno/NeonPolygon.svg?token=a1y1UzqtYCxXazSreSDC)](https://travis-ci.com/Maumagnaguagno/NeonPolygon)
**Geometric library for Ruby**

Geometric library currently restricted to 2D operations supporting few primitives, SVG output and Float comparison.
Other libraries, such as [bfoz/geometry](https://github.com/bfoz/geometry) and [DanielVartanov/ruby-geometry](https://github.com/DanielVartanov/ruby-geometry), do not offer Float comparison and may fail due to [rouding errors](http://floating-point-gui.de/).
SVG output also provides a nice way of checking what is happening inside the box.

## API

### [NeonPolygon](NeonPolygon.rb)
- ``Numeric.approx(other, relative_epsilon = nil, epsilon = nil)`` alias for ``==``
- ``Float.approx(other, relative_epsilon = 0.001, epsilon = 0.001)`` compares with epsilon for robustness.
- ``svg_grid(width, height, step = 10, style = 'fill:none;stroke:gray;stroke-width:0.5')`` returns a SVG grid pattern with cells of size ``step``.
- ``svg_text(x, y, text, style = 'font-family:Helvetica;font-size:8px')`` returns a SVG text element at the specified position.
- ``svg_save(filename, svg, width, height, x_min = 0, y_min = 0, x_max = width, y_max = height)`` saves SVG to file ``filename`` with size and viewbox specified.

===

### [Point class](src/Point.rb)
**Attributes:**
- ``attr_reader :x`` is the horizontal position along the X axis.
- ``attr_reader :y`` is the vertical position along the Y axis.

**Methods:**
- ``initialize(x, y)`` creates an instance with the given ``x`` and ``y`` coordinates.
- ``distance(other)`` returns distance to ``other`` point.
- ``==(other)`` returns true if ``self`` is approximately equal to ``other``, false otherwise.
- ``to_svg(style = 'fill:none;stroke:black;stroke-width:0.5')`` returns string with SVG description.

===

### [Line class](src/Line.rb)
**Attributes:**
- ``attr_reader :from`` is the segment origin, a point instance.
- ``attr_reader :to`` is the segment end, a point instance.
- ``attr_reader :slope``
- ``attr_reader :y_intercept`` it the position where line intercepts the Y axis.

**Methods:**
- ``initialize(from, to)`` creates an instance with the given ``to`` and ``from`` points.
- ``perimeter`` returns distance between ``from`` and ``to``.
- ``x_intercept`` returns position where line intercepts the X axis.
- ``vertical?`` returns true if line is vertical, false otherwise.
- ``horizontal?`` returns true if line is horizontal, false otherwise.
- ``parallel_to?(other)`` returns true if self is parallel to ``other`` line, false otherwise.
- ``contain_point?(other)`` returns true if segment ``self`` contains ``other`` point, false otherwise
- ``distance_to_point(other)`` returns distance between ``self`` and ``other`` point.
- ``intersect_line(other)`` returns point of intersection between ``self`` and ``other`` line, ``nil`` if none.
  - **TODO** return line of intersection if lines are coincident.
- ``intersect_line2(other)`` works like ``intersect_line(other)`` for non horizontal/vertical lines.
- ``intersect_line_angle(other)`` **TODO** description and tests.
- ``to_svg(style = 'stroke:black')`` returns string with SVG description.

===

### [Polyline class](src/Polyline.rb)
**Attributes:**
- ``attr_reader :vertices`` is an array of point instances.
- ``attr_reader :edges`` is an array of line instances.

**Methods:**
- ``initialize(*vertices)`` creates an instance with the given array of ``vertices``, each vertice is a point instance.
- ``perimeter`` returns the sum of edge perimeters.
- ``to_svg(style = 'fill:none;stroke:black')`` returns string with SVG description.

===

### [Polygon class](src/Polygon.rb)
**Attributes:**
- ``attr_reader :vertices`` is an array of point instances.
- ``attr_reader :edges`` is an array of line instances, last vertex is connected to first vertex.

**Methods:**
- ``initialize(*vertices)`` creates an instance with the given array of ``vertices``, each vertice is a point instance.
- ``to_svg(style = 'fill:gray;stroke:black')`` returns string with SVG description.

===

### [Circle class](src/Circle.rb)
**Attributes:**
- ``attr_reader :cx`` is the horizontal position along the X axis.
- ``attr_reader :cy`` is the vertical position along the Y axis.
- ``attr_reader :radius`` is how far the circle extends from the center position ``cx`` and ``cy``.

**Methods:**
- ``initialize(cx, cy, radius)`` creates an instance at ``cx`` and ``cy`` with radius ``radius``.
- ``perimeter`` returns perimeter/circumference of circle.
- ``area`` returns area of circle.
- ``contain_point?(other)`` returns true if ``other`` point is within area of circle, false otherwise.
- ``distance_to_point(other)`` returns distance from ``other`` point to circle border.
- ``to_svg(style = 'fill:gray;stroke:black')`` returns string with SVG description.

## ToDo's
- API description
- Tests
- Support Integer and Bigdecimal, check zero division cases