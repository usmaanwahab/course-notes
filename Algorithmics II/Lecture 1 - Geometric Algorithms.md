

Some examples of geometric algorithms are:

- Determining whether two line segments intersect
- Constructing a simple polygon from a set of points
- Finding the convex hull of a set of points - the smallest convex polygon that includes them all
- Finding a closest pair among a set of points
- Finding all the intersections of a set of horizontal and vertical line segments

## Definitions

- **Point** – a pair of coordinates (x, y)
- **Line** – an (ordered) pair of points p, q, denoted as -p-q-
- **Line segment** – a pair of endpoints p, q, denoted as p-q
- **Path** – a sequence of distinct points $p1, …, pn$
- **Polygon** – a path $p1, …, pn$ with $p1 = pn$ (closed)
- **Simple polygon** – a polygon with no self-intersections; it encloses a region (its interior)
- **Convex polygon** – a polygon such that for any two points p, q inside it, the line segment p-q lies entirely inside

```java
use Point2D.Double;

// Define a line comprised of two points
public class Line {
    public Point2D.Double p1;
    public Point2D.Double p2;
}

// Define a polygon comprised of several points
public class PointSet {
    public Point2D.Double[] pointArray;
}
```
## Problem 1 - Determining if two line segments intersect

The standard "high school" method involves:

- Compute the equation of each line
- Solve the system of equations to find the point of intersection (if any)
- Check whether the intersection point lies between the endpoints of both segments

This method involves division, which is relatively costly and can be inaccurate due to floating-point errors

### Alternative method

1. Determine whether points p and q lie on opposite sides of the line through points r and s, and whether points r and s lie on opposite sides of the line through points p and q
2. Determine whether the smallest rectangles whose sides are parallel to the x and y axes containing each of the p-q and r-s segments intersect

To check if points a and b are on opposite sides of line l = -p1-p2-:

```java
private boolean onOppositeSides(Point2D.Double a, Point2D.Double b, Line l) {
    double g, h;
    g = (l.p2.x - l.p1.x) * (a.y - l.p1.y) - (l.p2.y - l.p1.y) * (a.x - l.p1.x);
    h = (l.p2.x - l.p1.x) * (b.y - l.p1.y) - (l.p2.y - l.p1.y) * (b.x - l.p1.x);

    return g * h <= 0.0;
}
```

Bounding box: The smallest rectangle containing a line segment p-q whose sides are parallel to the x and y axes. Two line segments cannot intersect if their bounding boxes do not intersect.
