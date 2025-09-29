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

Question 3 - The opposite side tests work on the lines not the line segments, so two points can be correctly opposite of the line but not the line segment. The bounding box basically acts to filter out these situations.


```java
// Question 4

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