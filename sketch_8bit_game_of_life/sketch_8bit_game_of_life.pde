

class Grid {
  private int[][] matrix;      //   0      1      2      3     4      5      6      7      8
  private boolean[] stay_alive = {false, true, true, false, false, false, false, false, false};
  private boolean[] new_alive  = {false, true, false, false, false, false, false, false, false};
  private int rows, cols;
  
  Grid(int rows, int cols, float p) {
     this.matrix = new int[rows][cols];
     this.rows = rows;
     this.cols = cols;
     
     // initialize random pattern
     for (int i = 0; i < this.rows; i++) {
       for (int j = 0; j < this.cols; j++) {
         this.matrix[i][j] = random(1) < p ? 1 : 0;
       }
     }
  }
  
  void update() {
    // clone matrix
    int[][] next_state = new int[this.rows][this.cols];
    
    // update status
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        // damn you modulo op
        i += this.rows;
        j += this.cols;
        // count alive neighborhood
        int alive_count = this.matrix[(i-1) % this.rows][(j-1) % this.cols] +
                          this.matrix[(i)   % this.rows][(j-1) % this.cols] +
                          this.matrix[(i+1) % this.rows][(j-1) % this.cols] +
                          this.matrix[(i-1) % this.rows][(j)   % this.cols] +
                          this.matrix[(i+1) % this.rows][(j)   % this.cols] +
                          this.matrix[(i-1) % this.rows][(j+1) % this.cols] +
                          this.matrix[(i)   % this.rows][(j+1) % this.cols] +
                          this.matrix[(i+1) % this.rows][(j+1) % this.cols];
        // fix i,j
        i -= this.rows;
        j -= this.cols;
        if (this.matrix[i][j] == 1 && !this.stay_alive[alive_count] || this.matrix[i][j] == 0 && this.new_alive[alive_count]) {
           next_state[i][j] = 1 - this.matrix[i][j];
        }
      }
    }
    
    this.matrix = next_state;
  }
  
  void draw() {
    float w = (float)width / this.cols;
    float h = (float)height / this.rows;
    
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        if (this.matrix[i][j] == 1)
          rect(j*w, i*h, w, h);
      }
    }
  }
}

Grid g;

void setup() {
  size(1080, 1920);
  frameRate(6);
  background(255);
  g = new Grid(160, 90, 0.0001);
}

void draw() {
  g.update();
  
  background(0);
  noStroke();
  fill(255);
  g.draw();
  //saveFrame("frames.nosync/frame-######.tif");
}

void keyPressed() {
  if (key == 'q') {
    exit();
  }
}
