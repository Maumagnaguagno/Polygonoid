# Polygonoid [![Build Status](https://travis-ci.org/Maumagnaguagno/Polygonoid.svg)](https://travis-ci.org/Maumagnaguagno/Polygonoid)
**Geometric library for Ruby**

Geometric library currently restricted to 2D operations supporting few primitives, SVG output and Float comparison.
Other libraries, such as [bfoz/geometry](https://github.com/bfoz/geometry) and [DanielVartanov/ruby-geometry](https://github.com/DanielVartanov/ruby-geometry), do not offer Float comparison and may fail due to [rounding errors](http://floating-point-gui.de/).
SVG output also provides a nice way of checking what is happening inside the box.

## API

### [Polygonoid](Polygonoid.rb)
- ``Numeric.approx(other, relative_epsilon = 0.001, epsilon = 0.001)`` compares with epsilon for robustness.
- ``svg_grid(width, height, step = 10, style = 'fill:none;stroke:gray;stroke-width:0.5')`` returns a SVG grid pattern with cells of size ``step``.
- ``svg_text(x, y, text, style = 'font-family:Helvetica;font-size:8px')`` returns a SVG text element at the specified position.
- ``svg_save(filename, svg, options = nil)`` saves SVG to file ``filename`` with specified ``options``.

---

### [Point class](src/Point.rb)
**Attributes:**
- ``attr_reader :x`` is the horizontal position along the X axis.
- ``attr_reader :y`` is the vertical position along the Y axis.

**Methods:**
- ``initialize(x, y)`` creates an instance with the given ``x`` and ``y`` coordinates.
- ``==(other)`` returns ``true`` if ``self`` is approximately equal to ``other`` point, ``false`` otherwise.
- ``distance(other)`` returns distance to ``other`` point.
- ``to_svg(style = 'fill:none;stroke:black;stroke-width:0.5')`` returns string with SVG description.

---

### [Line class](src/Line.rb)
**Attributes:**
- ``attr_reader :from`` is the segment origin, a point instance.
- ``attr_reader :to`` is the segment end, a point instance.
- ``attr_reader :slope`` the ratio between the y-change over the x-change of the origin and end points.
- ``attr_reader :y_intercept`` is the position where the line intercepts the Y axis, ``nil`` for vertical lines.

**Methods:**
- ``initialize(from, to)`` creates an instance with the given ``from`` and ``to`` points.
- ``==(other)`` returns ``true`` if ``self`` is approximately equal to ``other`` line, ``false`` otherwise.
- ``perimeter`` returns distance between ``from`` and ``to``.
- ``x_intercept`` returns position where ``self`` intercepts the X axis, ``nil`` for horizontal lines.
- ``vertical?`` returns ``true`` if ``self`` is vertical, ``false`` otherwise.
- ``horizontal?`` returns ``true`` if ``self`` is horizontal, ``false`` otherwise.
- ``parallel_to?(other)`` returns ``true`` if ``self`` is parallel to ``other`` line, ``false`` otherwise.
- ``point_side(point)`` returns less or greater than zero according to which side of ``self`` the ``point`` is, ``0`` if on ``self``.
- ``contain_point?(point)`` returns ``true`` if ``point`` is on ``self``, ``false`` otherwise.
- ``segment_contain_point?(point)`` returns ``true`` if ``point`` is on ``self``, ``false`` otherwise.
- ``distance_to_point(point)`` returns distance between ``self`` and ``point``.
- ``segment_distance_to_point(point)`` returns distance between ``self`` segment and ``point``.
- ``intersect_line(other)`` returns point of intersection between ``self`` and ``other`` line, ``nil`` if none.
  - **TODO** return line of intersection if lines are coincident.
- ``intersect_line2(other)`` works like ``intersect_line(other)`` for non-horizontal/vertical lines.
  - **TODO** verify implementation and add tests.
  - **TODO** return line of intersection if lines are coincident.
- ``intersect_line_angle(other)`` returns angle between lines based on their slope.
- ``to_svg(style = 'stroke:black')`` returns string with SVG description.

---

### [Polyline class](src/Polyline.rb)
**Attributes:**
- ``attr_reader :vertices`` is an array of point instances.
- ``attr_reader :edges`` is an array of line instances.

**Methods:**
- ``initialize(*vertices)`` creates an instance with the given array of ``vertices``, each vertice is a point instance.
- ``perimeter`` returns the sum of edge perimeters.
- ``contain_point?(point)`` returns ``true`` if ``point`` is on ``self``, ``false`` otherwise.
- ``to_svg(style = 'fill:none;stroke:black')`` returns string with SVG description.

---

### [Polygon class](src/Polygon.rb)
**Attributes:**
- ``attr_reader :vertices`` is an array of point instances.
- ``attr_reader :edges`` is an array of line instances, last vertex is connected to first vertex.

**Methods:**
- ``initialize(*vertices)`` creates an instance with the given array of ``vertices``, each vertice is a point instance.
- ``area`` returns area of simple polygon ``self``.
- ``center`` returns centroid point of ``self``.
- ``contain_point?(point)`` returns ``true`` if ``point`` is within area of ``self``, ``false`` otherwise.
- ``to_svg(style = 'fill:gray;stroke:black')`` returns string with SVG description.

---

### [Circle class](src/Circle.rb)
**Attributes:**
- ``attr_reader :x`` is the center position along the X axis.
- ``attr_reader :y`` is the center position along the Y axis.
- ``attr_reader :radius`` is how far the circle extends from the center position ``x`` and ``y``.

**Methods:**
- ``initialize(x, y, radius)`` creates an instance with center at ``x`` and ``y`` with ``radius``.
- ``==(other)`` returns ``true`` if ``self`` is approximately equal to ``other`` circle, ``false`` otherwise.
- ``perimeter`` returns perimeter/circumference of ``self``.
- ``area`` returns area of ``self``.
- ``contain_point?(point)`` returns ``true`` if ``point`` is within area of ``self``, ``false`` otherwise.
- ``distance_to_point(point)`` returns distance between ``self`` border and ``point``.
- ``to_svg(style = 'fill:gray;stroke:black')`` returns string with SVG description.