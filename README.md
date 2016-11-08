# NeonPolygon [![Build Status](https://travis-ci.com/Maumagnaguagno/NeonPolygon.svg?token=a1y1UzqtYCxXazSreSDC)](https://travis-ci.com/Maumagnaguagno/NeonPolygon)
**Geometric library for Ruby**

Geometric library currently restricted to 2D operations supporting few primitives, SVG output and Float comparison.
Other libraries, such as [bfoz/geometry](https://github.com/bfoz/geometry) and [DanielVartanov/ruby-geometry](https://github.com/DanielVartanov/ruby-geometry), do not offer Float comparison and may fail due to [rouding errors](http://floating-point-gui.de/).
SVG output also provides a nice way of checking what is happening inside the box.

## Primitives
- Point
- Line
- Polyline
- Polygon
- Circle

## API

### [``Point``](src/Point.rb)

**Attributes:**
- ``attr_reader :x`` is the horizontal position along the X axis.
- ``attr_reader :y`` is the vertical position along the Y axis.

**Methods:**
- ``initialize(x, y)`` creates an instance with the given ``x`` and ``y`` coordinates.
- ``distance(other)`` returns distance to ``other`` point.
- ``==(other)`` returns true if ``self`` is approximately equal to ``other``, false otherwise.
- ``to_svg(style = 'fill:none;stroke:black;stroke-width:0.5')`` returns string with SVG description.

===

### [``Line``](src/Line.rb)
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

### [``Polyline``](src/Polyline.rb)
**Attributes:**
- ``attr_reader :vertices`` is an array of point instances.
- ``attr_reader :edges`` is an array of line instances.

**Methods:**
- ``initialize(*vertices)`` creates an instance with the given array of ``vertices``, each vertice is a point instance.
- ``perimeter`` returns the sum of edge perimeters.
- ``to_svg(style = 'fill:none;stroke:black')`` returns string with SVG description.

===

### [``Polygon``](src/Polygon.rb)
**Attributes:**
- ``attr_reader :vertices`` is an array of point instances.
- ``attr_reader :edges`` is an array of line instances, last vertex is connected to first vertex.

**Methods:**
- ``initialize(*vertices)`` creates an instance with the given array of ``vertices``, each vertice is a point instance.
- ``to_svg(style = 'fill:gray;stroke:black')`` returns string with SVG description.

===

### [``Circle``](src/Circle.rb)
**Attributes:**
- ``attr_reader :cx`` is the horizontal position along the X axis.
- ``attr_reader :cy`` is the vertical position along the Y axis.
- ``attr_reader :radius`` is how far the circle extends from the center position defined by ``cx,cy``.

**Methods:**
- ``initialize(cx, cy, radius)`` creates an instance at ``cx`` ``cy`` with radius ``radius``.
- ``perimeter`` returns perimeter/circumference of circle.
- ``area`` returns area of circle.
- ``contain_point?(other)`` returns true if ``other`` point is within area of circle, false otherwise.
- ``distance_to_point(other)`` returns distance from ``other`` point to circle border.
- ``to_svg(style = 'fill:gray;stroke:black')`` returns string with SVG description.

## ToDo's
- API description
- Tests
- Add style parameter to ``to_svg`` methods
- Support Integer and Bigdecimal, check zero division cases