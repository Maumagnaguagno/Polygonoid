# NeonPolygon [![Build Status](https://travis-ci.com/Maumagnaguagno/NeonPolygon.svg?token=a1y1UzqtYCxXazSreSDC)](https://travis-ci.com/Maumagnaguagno/NeonPolygon)
**Geometric library for Ruby**

Geometric library currently restricted to 2D operations supporting few primitives, SVG output and Float comparison.
Other libraries, such as [bfoz/geometry](https://github.com/bfoz/geometry) and [ruby-geometry](https://github.com/DanielVartanov/ruby-geometry), do not offer Float comparison and may fail due to [rouding errors](http://floating-point-gui.de/).
SVG output also provides a nice way of checking what is happening inside the box.

## Primitives
- Point
- Line
- Polyline
- Polygon

## ToDo's
- Tests
- Avoid ``to_f`` in Point, support Integer and Bigdecimal