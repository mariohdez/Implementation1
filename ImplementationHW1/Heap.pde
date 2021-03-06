/** //<>// //<>//
 * @description Heap data strcutre that holds Points where each subtree's root is larger than it's children. 
 *              The underlying primitive data structure is an array of points.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
class Heap {
  Point[] points;
  int heapsize;
  Point pivot;

  /**
   * Initalize, and find lowest point.
   */
  Heap( String filename ) {
    pivot = null;
    parseAndBuildInitialArray( filename );
    heapsize = points.length - 1; // Don't want to do work on points[0], so I'm saying that there is only points[1] ..... points[n].
    findAndSwapLowestPoint();
    setPivot( points[ 0 ] );
  }
  /**
   * Parse the file.
   */
  void parseAndBuildInitialArray( String filename ) {
    BufferedReader reader;
    reader = createReader( filename );
    try {
      points = new Point[ Integer.parseInt( reader.readLine() ) ];
      for ( int i = 0; i < points.length; ++i ) {
        String[] ints = reader.readLine().split("\\s+");
        points[ i ] = new Point( Integer.parseInt( ints[ 0 ] ), Integer.parseInt( ints[ 1 ] ) );
      }
      reader.close();
    }
    catch ( Exception e ) {
      System.err.println( "Error occured when parsing " + filename + ". Error msg: " + e.getMessage() );
      points = null;
      return;
    }
    return;
  }

  /**
   * Find the left-lowest point.
   */
  void findAndSwapLowestPoint() {
    int ymin = points[ 0 ].getY();
    int min = 0;
    for (int z = 0; z < points.length; z++) {
      int y = points[ z ].getY();
      // Pick the bottom most or choose the left in case of tie.
      if ( (y < ymin) || ( ymin == y && points[ z ].getX() < points[ min ].getX() ) ) {
        ymin = points[ z ].getY();
        min = z;
      }
    }
    // Swap bottom most to front of the heap
    Point temp = points[ 0 ];
    setIndex( points[min], 0 );
    setIndex( temp, min );
  }

  /**
   * Call maxheapify from the middle all the way to the root.
   * Runs in O(n) time.
   */
  void buildHeap() {
    for ( int i = heapsize/2; i > 0; i-- ) {
      maxHeapify( points, i, heapsize );
    }
  }

  /**
   * Sorts the heap array from the last one to the second to last one.
   * Runs in O( n * log(n) )
   */
  void heapSort() {
    buildHeap();
    Point tmp = null;
    for ( int i = heapsize; i >= 2; --i ) {
      tmp = points[ 1 ];
      points[ 1 ] = points[ i ];
      points[ i ] = tmp;
      heapsize -= 1;
      maxHeapify( points, 1, heapsize );
    }
  }

  /**
   * Difuses the smaller points down the 'heap', and recursively calls its until it is a legal max-heap.
   */
  void maxHeapify( Point[] points, int i, int size ) {
    int left = i * 2;
    int right = ( i * 2 ) + 1;
    int crossProduct = 0;
    int largest = 0;
    if ( left <= size ) {
      crossProduct = calculateCrossProduct( points[ left ], points[ i ] );
    }
    if ( left <= size && crossProduct < 0 ) {
      largest = left;
    } else {
      largest = i;
    }
    if ( right <= size ) {
      crossProduct = calculateCrossProduct( points[ right ], points[ largest ] );
    }
    if ( right <= size && crossProduct < 0 ) {
      largest = right;
    }
    if ( largest != i ) {
      Point temp = points[ largest ];
      points[ largest ] = points[ i ];
      points[ i ] = temp;
      maxHeapify( points, largest, size );
    }
  }

  Point[] getArray() {
    return points;
  }

  void setIndex(Point p, int i) {
    points[i] = p;
  }
  
  int getIndex(Point pt) {
   for(int i = 0; i < points.length; i++) {
    if(pt.isEqual(points[i])) {
     return i; 
    }
   }
   return -1;
  }

  /**
   * Calculate the cross product between 3 points. 
   */
  int calculateCrossProduct( Point p1, Point p2 ) {
    int t1 = ( p1.getX() - getPivot().getX() ) * ( p2.getY() - getPivot().getY() );
    int t2 = ( p1.getY() - getPivot().getY() ) * ( p2.getX() - getPivot().getX() );
    return t1 - t2;
  }

  /**
   * Get the lowest-leftest point.
   */
  public Point getPivot() {
    return this.pivot;
  }

  /**
   * Set the lowest-leftest point.
   */
  public void setPivot( Point pivot ) {
    this.pivot = pivot;
  }

}