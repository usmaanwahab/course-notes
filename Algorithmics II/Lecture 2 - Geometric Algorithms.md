## Problem 2 - Constructing a simple polygon
---

Given a set of n points in a plane, connect them to form a simple polygon.

- Naive method: join the points in any order (usually fails)
- Better approach: use a circular scan. Choose a pivot point p and connect points in the order they are encountered during the scan

### Pivot selection

- Choose p as one of the points in the input set, e.g., the point with the largest x component
- Each line of the generated polygon lies within a unique region of the circle
```java
public void simplePolygon(PointSet points) {
    double num, denom;
    double[] angle = new double[points.length];
    
    // modifies points so that points[0] contains the point with 
    // the largest x component (and smallest y if a tie)
    select_largest_xcoord(points);

    for (int i = 1; i < points.length; i++) {
        num = points[0].x - points[i].x;
        denom = points[i].y - points[0].y;

        if (denom > 0.0) {
            // points[i] is above points[0]
            angle[i] = Math.atan(num/denom);
        } else if (denom == 0.0) {
            // points[i] is level with points[0]
            angle[i] = Math.PI/2.0;
        } else {
            // points[i] is below points[0]
            angle[i] = Math.atan(num/denom) + Math.PI;
        }
    }

    // sort points[1..n-1] using values of angle[1..n-1]
    sort(points, 1, points.length, angle);
}
```

- Time complexity: O(n log n) dominated by sorting
- Complications: If two or more points are col-linear with the pivot, sort them by increasing distance from the pivot
- Optimizations:
    1. Sorting by line gradients instead of computing `atan`
    2. Sorting by squared distance instead of computing square roots

## Problem 3  - Finding the Convex Hull
---
The convex hull of a set of points (in the plane) is the smallest convex polygon that contains the points, such that any line generated from two randomly picked points within the convex polygon are fully within the polygon.

Formally, given a set $P$ of $n$ points in the plane, find their convex hull. The Graham Scan algorithm is $O(n\ log\ n$) time. Every point of the convex hull of $P$ is itself a member of $P$.

Graham Scan Algorithm
- Choose a point known to be on the hull as the pivot - say the pivot with the largest $x$ coordinate (using the smallest $y$ coordinate to break a tie if necessary). 
- Scan the remaining points in order of angle to the pivot.
- For each point, include it in temporary hull, possibly excluding one or more of its predecessors.

As we trace out the potential hull, we expect to "turn left". If we "turn right" we must exclude one or more points. So if the angle between the two lines created by the last three points is greater than 180 degrees in the clockwise direction, we must exclude one or more points.
```java
// Input: an arbitrary polygon p of n points
// i.e. a sequence of n points
// Output: q, a simply polygon that is the convex hull of the points in p

public PointSet grahamScan(PointSet p) {
	simplyPolygon(p)
	PointSet q = new PointSet(p.length);
	q[0..2] = p[0..2] // create a deepcopy
	int m = 2;
	
	for (int k = 3; k < p.length; k++) {
		while (angle(...) >= Math.PI) { // FILL THE ANGLE IN
			m--;
		}
		q[++m] = p[k];
	}
	return q[0..m];
}
```

The overall complexity is $O(n\ log\ n)$. This derived from the $O(n)$ loop and the sorting of the points into a simple polygon $O(n\ log\ n)$ which is the dominating factor.

An application of Graham's Scan is in robotics. Robots want to travel from $s$ to $t$, avoiding obstacle $P$. 
- Check whether $s-t$ intersects with $P$. 
- If so, compute convex hull of $s, t$ and points of $P$'s boundary.
- Shortest path from $s$ to $t$ is either 
	- Clockwise distance along convex hull from $s$ to $t$ 
	- Anti-clockwise distance along convex hull from $s$ to $t$ 

Another application of Graham's scan is calculating the further pair of points.

Let $P$ be a set of points in the plane, where $n=|P|$.
A naive approach would be to check each pair which is clearly $O(n^2)$.

An approved method is based on the fact that, a furthest pair of points in $P$ are points of the convex hull of $P$. The convex hill may be constructed in $O(n\ log\ n)$ time. Once the convex hull of $P$ has been constructed, a furthest pair of points in $P$ can be found in $O(n)$ time, using the rotating calipers method (described below). Therefore we can find the furthest pair of points in $O(n\ log\ n)$ time overall.

The rotating calipers method is defined as follow:
- Find two points $p,q$, on the convex hull with minimum and maximum y-coordinate respectively.
- Draw two horizontal lines (the "calipers") $l_1$ and $l_2$ through each of $p$ and $q$, and record the distance $d(p,q)$.
- Rotate $l_1$ clockwise around $p$, and rotate $l_2$ clockwise around q, keeping $l_1$ parallel to $l_2$ at all times, until one of the calipers reaches the next point (call it $r$) on the convex hull.
- Repeat steps 2-3 with caliper $l$ rotated clockwise around the next pivot $r$ and with each other caliper rotated around its old pivot until $l_1$ reaches $q$ and $l_2$ reaches p (half circle). Note the perpendicular distance between the calipers may change during the course of their rotation.
- Return the largest distance $d(p,q)$ measured at Step 2 as the furthest distance between points on the convex hull.