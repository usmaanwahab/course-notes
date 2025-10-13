```java
use Point2D.Double;

// Define a line comprised of two points
public class Line {
    public Point2D.Double p1;
    public Point2D.Double p2;
    
    public Line(Point2D.Double p1, Point2D.Double p2) {
	    this.p1 = p1;
	    this.p2 = p2;
    }
}

// Define a polygon comprised of several points
public class PointSet {
    public Point2D.Double[] pointArray;
}

private boolean onOppositeSides(Point2D.Double a, Point2D.Double b, Line l) {
    double g, h;
    g = (l.p2.x - l.p1.x) * (a.y - l.p1.y) - (l.p2.y - l.p1.y) * (a.x - l.p1.x);
    h = (l.p2.x - l.p1.x) * (b.y - l.p1.y) - (l.p2.y - l.p1.y) * (b.x - l.p1.x);

    return g * h <= 0.0;
}

// Question 2
// returns true if the rectangles containg line segments l1 and l2 intersect,  // and returns false otherwise
public boolean boundingBox(Line l1, Line l2) {

	double l1MinX = Math.min(l1.p1.x, l1.p2.x);
	double l1MinY = Math.min(l1.p1.y, l1.p2.y);
	double l1MaxX = Math.max(l1.p1.x, l1.p2.x);
	double l1MaxY = Math.max(l1.p1.y, l1.p2.y);
	
	double l2MinX = Math.min(l2.p1.x, l2.p2.x);
	double l2MinY = Math.min(l2.p1.y, l2.p2.y);
	double l2MaxX = Math.max(l2.p1.x, l2.p2.x);
	double l2MaxY = Math.max(l2.p1.y, l2.p2.y);
	
	// if any fo these are true the bounding boxes do not overlap
	return !(l1MaxX < l2MinX || l1MinX > l2MaxX ||
		l1MaxY < l2MinY || l1MinY > l2MaxY
	);
}

// Question 1
// returns true if the lines l1 and l2 intersect, and returns false otherwise
public boolean intersect(Line l1, Line l2) {
	return onOppositeSides(l1.p1, l1.p2, l2) &&
			onOppositeSides(l2.p1, l2.p2, l1) &&
			boundingBox(l1, l2);
}

```

### Question 3
---
The opposite side tests work on the lines not the line segments, so two points can be correctly opposite of the line but not the line segment. The bounding box basically acts to filter out these situations.


### Question 4
---
This question requires merge sort, not quick sort.
```java
public class Line {
	Point2D.Double p1;
	Point2D.Double p2;
	
	public Line(Point2D.Double p1, Point2D.Double p2) {
		this.p1 = p1;
		this.p2 = p2;
	}
}
public int partition(Line[] lines, int low, int high) {
	Line pivot = arr[high];
	double smaller_pivot_x = Math.min(pivot.p1.x, pivot.p2.x);
	 
	int i = low - 1;
	for (int j = low; j <= high - 1; j++) {
		double point_with_smaller_x = Math.min(lines[j].p1.x, lines[j].p2.x);
		if (point_with_smaller_x < smaller_pivot_x) {
			i++;
			swap(lines, i, j);
		}
	}  
	
	swap(lines, i+1, high);
	return i + 1
}

public void swap(Line[] lines, int i, int j) {
	Line temp = lines[i];
	lines[i] = lines[j];
	lines[j] = temp;
}

public void quicksort(Line[] lines, int low, int high) {
	if (low < high) {
		int pivot = partition(lines, low, high);
		
		quicksort(lines, low, pivot-1);
		quicksort(lines, pivot, high)
	}
}

// Given an input of lines that lie on the x-axis, determines whether any two
// lines segments intersect one another.

public boolean intersect(Line[] lines) {
	// Validate lines
	for (Line l : lines) {
		if (l.p1.y != 0 || l.p2.y != 0) {
			System.out.println("Not all lines lie on the x-axi");
		} 	
	}
	// p1 x should always be smaller than p2 x
	for (Line l: lines) {
		if (l1.p1.x > l1.p2.x) {
			Point2D.Double temp = l1.p1;
			l1.p1 = l1.p2;
			l1.p2 = temp;
		}
	}
	
	// Sorting will now occur based on the first point of each line
	quicksort(lines, 0, lines.length - 1);
	
	
	for (int i = 1; i <= lines.length - 1; i++) {
		if (lines[i-1].p2.x > lines[i].p1.x) {
			return true;
		}
	}
	
	return false;
}
```

### Question 5
---

### Question 6
---

### Question 7
---
Yes, typically we choose the pivot with the largest x (and smallest y to break a tie. This is also the basis for simple polygon construction. A property of the convex hull is that it will include the points with largest and smallest x and y values. If we start at a point that is not on the convex hull, since Graham Scan can only remove predecessors, it will build the temporary hull in memory once it tries to complete the hull it will not be able to handle this cases due to starting at an improper pivot.
### Question 8
---
A point set where the points on the edge of the line zig zag. That is, a point set such that it is constantly turning right after turning left forcing it to exclude and recalculate. This would also incur branch prediction penalties 

### Question 9
---
Initial idea would've just been to $O(n)$ split this space into two separate convex hulls for a furthest pair of points of the same colour.
However, how do we guarantee that we can find a furthest pair of points of different colours. Since rotating calipers doesn't map every distance in the convex hull only points that have a chance of being the the furthest. So unless the points just so happen to be opposite colours we can't generally guarantee a furthest pair of points that have different colours without significant alteration to the algorithm.
### Question 10
---
A - True
B - False

Run the algorithm three times, the first time finds the closest pair say $p,q$. Remove $p$ the second run still keeping $q$. Remove $q$ but still keep $p$. Then return the smallest distance from the second and third run.

C - True

If we have only two points (0, 1) and (0,-1), if we partition we get $d_1$ = 1 and $d_2$ = 1, since we return the largest y instead of `DoubDOUBLE_MAX` we open the possibility for the algorithm to report a distance that doesn't exist. Since you can see that the the closest pair has a distance of 2 units. So we need something that we can guarantee that it can be improved upon.



### Question 11
---
Sort the points by x coordinate, and we break ties by y coordinate.

Iterate in reverse, we maintain a y pointer to the largest y we've found, every time the y_max value gets updated we have another maximal point.
### Question 12
---

### Question 13
---

### Question 14
---