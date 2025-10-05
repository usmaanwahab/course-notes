Problem 4 - **Finding a closest pair of points**
Definition - Given a set $P$ of $n$ points in the plane, find a pair whose distance from each other is as small as possible.

The naive algorithm where we check each possible pair has a time complexity of $O(n^2)$.

However, we find that there is a divide and conquer algorithm, based on sorting that allows us to achieve an $O(n\ log\ n)$ time complexity.

The basic idea for the closest pair algorithm is as follows:
- sort $P$ by $x$-coordinate once at the outset
- divide $P$ into two equal-sized subsets $Q$, $R$ based on $x$-coordinate
- solve for each subset recursively
- combine, and find that the closest pair $(x,y)$ satisfies either:
	- $x\in Q, y\in Q$ (solved already)
	- $x\in R, y\in R$ (solved already)
	- $x\in Q, y\in R$ (distance apart $\le d$ )

In partition $Q$ we define $d_1$ as the smallest distance in this partition.
In partition $R$ we define $d_2$ as the smallest distance in this partition.

We then define $d = min \{d_1, d_2\}$.

We also define a partition $L$, that overlaps points from $Q$ and $R$ such that all points are at most $d$ distance from the centre of the whole space. Essentially, $L$ is a strip down the middle of the whole space of $P$.

In case three, we can eliminate point with distances $\le d$ from $L$, in the worst-case this might not eliminate any points.

If we sort the remaining points on their $y$-coordinate, any such points can be at distance $\le d$ from only a small number of its successors in this list.

We need to sort all points in the strip in increasing order of their $y$-coordinates. If we do this every time we "combine", it leads to an $O(n\ log^2\ n)$ algorithm.

The trick is to mimic merge-sort. 
- Assume that the points in $Q$ are sorted in increasing order of $y$-coordinate (when we solve Closest Pair on $Q$).
- Assume that the points in $R$ are sorted in increased order of $y$-coordinate (when we solve Closest pair on $R$).
- At the "Combine" step, merge the two sorted sets to get all points in the strip sorted in increasing order of $y$-coordinate.

```java
public double closestPair(PointSet p) {
	sortOnXCoord(p);
	return cPRec(p, 0, p.length-1);
}

private double cPRec(PointSet p, int i, int k) {
	/*
	assumes p[i..k] sorted on x-coordinate;
	returns the distance between a closest pair of points in p[i..k];
	also returns, in p[i..k], the points initially in p[i..k] sorted on y

	*/
	double d;
	
	if (i == k) {
		d = Double.MAX_VALUE;
	} else {
		int j = (i+k)/2; // mid-point of p[i..k]
		double mid = (p[j].x + p[j+1].x) / 2.0; // x coord of mid-line
		double d1 = cPRec(p, i, j); // p[i..j] sorted on y coord
		double d2 = cPRec(p, j+i, k); // p[j+1..k] sorted on y coord
		
		merge(p, i, j, k); // p[i..k] sorted on y coord
		d = Math.min(d1, d2);
		
		// the points in the "strip"
		PointSet s = filter(p, i, k, d, mid);
		
		int m = s.length;
		for (int a=0; a < m-1; a++) {
			for (int b=a+1; b <= Math.min(a+5, m-1); b++) {
				if (dist(s[a], s[b]) < d) {
					d = dist(s[a], s[b]);
				}
			}
		}
	}
	return d;
}

private PointSet filter(PointSet p, int i, int k, double d, double z);
// returns a PointSet containg points in p[i..k] with x-coord within distance d of z; preserves relative order

private double dist(Point2D.Double a, Point2D.Double b)
// returns the distance between the points a and b
```

Every time $d$ is updated, store the two points `s[a]` and `s[b]` that were responsible for the update being made.

Sorting is $O(n\ log\ n)$ 
Merge is $O(n)$
Filter is $O(n)$

The nested for loops contribute $O(n)$. This is because the outer loop is execute $m$ $(\le n)$ times, and for each of these, the inner loop is executes $\le 5$ times.

Let $f(n)$ be the worst-case complexity, then
- $f(n) \le 2f(\frac{n}{2}) + cn$ where $(n>1)$
- f(1) = d
where $c$ and $d$ are constants.

Therefore $f(n) = O(n\ log\ n)$ 