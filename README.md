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

### [Point](src/Point.rb)
**Attributes:**
- ``attr_reader :x`` is the point horizontal position along the X axis.
- ``attr_reader :y`` is the point vertical position along the Y axis.

**Methods:**
- ``initialize(x, y)`` creates an instance with the given ``x`` and ``y`` coordinates.
- ``distance(other)``
- ``==(other)``
- ``to_svg(style = 'fill:none;stroke:black;stroke-width:0.5')`` returns string with SVG description.

### [Line](src/Line.rb)
**Attributes:**
- ``attr_reader :from``
- ``attr_reader :to``
- ``attr_reader :slope``
- ``attr_reader :y_intercept``

**Methods:**
- ``initialize(from, to)`` creates an instance with the given ``to`` and ``from`` points.
- ``perimeter``
- ``x_intercept``
- ``vertical?``
- ``horizontal?``
- ``parallel_to?(other)``
- ``contain_point?(other)``
- ``distance_to_point(other)``
- ``intersect_line(other)``
- ``intersect_line2(other)`` works like ``intersect_line(other)`` for non horizontal/vertical lines.
- ``intersect_line_angle(other)``
- ``to_svg(style = 'stroke:black')`` returns string with SVG description.

### [Polyline](src/Polyline.rb)
**Attributes:**
- ``attr_reader :vertices``
- ``attr_reader :edges``

**Methods:**
- ``initialize(*vertices)`` creates an instance with the given array of ``vertices``.
- ``perimeter``
- ``to_svg(style = 'fill:none;stroke:black')`` returns string with SVG description.

### [Polygon](src/Polygon.rb)
**Attributes:**
- ``attr_reader :vertices``
- ``attr_reader :edges``

**Methods:**
- ``initialize(*vertices)``
- ``to_svg(style = 'fill:gray;stroke:black')`` returns string with SVG description.

### [Circle](src/Circle.rb)
**Attributes:**
- ``attr_reader :cx``
- ``attr_reader :cy``
- ``attr_reader :radius``

**Methods:**
- ``initialize(*vertices)``
- ``perimeter``
- ``area``
- ``to_svg(style = 'fill:gray;stroke:black')`` returns string with SVG description.

## ToDo's
- API description
- Tests
- Add style parameter to ``to_svg`` methods
- Support Integer and Bigdecimal, check zero division cases