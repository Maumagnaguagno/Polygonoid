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

## API

### Point
**Attributes:**
- ``attr_reader :x`` is the point horizontal position along the X axis.
- ``attr_reader :y`` is the point vertical position along the Y axis.

**Methods:**
- ``initialize(x, y)`` creates an instance with the given ``x`` and ``y`` coordinates.
- ``distance(other)``
- ``==(other)``
- ``to_svg``

### Line
**Attributes:**
- ``attr_reader :from``
- ``attr_reader :to``
- ``attr_reader :slope``
- ``attr_reader :y_intercept``

**Methods:**
- ``initialize(from, to)``
- ``perimeter``
- ...
- ``to_svg``

### Polyline
**Attributes:**
- ``attr_reader :vertices``
- ``attr_reader :edges``

**Methods:**
- ``initialize(*vertices)``
- ``perimeter``
- ``to_svg``

### Polygon
**Attributes:**
- ``attr_reader :vertices``
- ``attr_reader :edges``

**Methods:**
- ``initialize(*vertices)``
- ``to_svg``

## ToDo's
- API description
- Tests
- Add style parameter to ``to_svg`` methods
- Support Integer and Bigdecimal, check zero division cases