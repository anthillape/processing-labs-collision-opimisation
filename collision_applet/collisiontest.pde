ArrayList balls;
ArrayList grid;
int boxSize;
int numBoxesX;
int numBoxesY;
Boolean isBruteForce;

void setup()
{
  boxSize = 8;
  size(610,450);
  background(0);
  smooth();
  balls = new ArrayList();
  for( int i = 0; i< 3600;i++ )
  {
    Ball ball = new Ball(random(width), random(height/2), random(2)+2);
    balls.add( ball );
  }
  setupGrid();
  isBruteForce = false;
}

void mouseClicked()
{
  isBruteForce = !isBruteForce;
}

void draw()
{
  moveBalls();
  noStroke();
  //fill(0,0,0,10);
  //rect(0,0,width,height);
  background(0);
  fill(0xffffffff);
  if( isBruteForce )
  {
    bruteForceCollisions();
  }
  else
  {
    gridCollisions();
    drawGrid();
  }
  noStroke();
  int n = balls.size();
  for( int i = 0; i < n; i++)
  {
    Ball ball = (Ball) balls.get(i);
    if( ball.hit )
    {
      fill(0xffe0256c);
    }
    else
    {
      fill(0xffffffff);
    }
    ellipse(ball.x,ball.y,ball.r*2,ball.r*2);
  }
  
  
}

void drawGrid()
{
  noFill();
  noStroke();
  int n = grid.size();
  for( int i = 0; i < n; i++)
  {
    GridBox boxx = (GridBox) grid.get(i);
    if( boxx.balls.size() > 0 )
    {
      rect(boxx.x,boxx.y, boxSize,boxSize);
    }
    if( boxx.collideTest )
    {
      fill(0x33ffffff);
      rect(boxx.x,boxx.y, boxSize,boxSize);
      noFill();
    }
  }
}

void setupGrid()
{
  
  numBoxesX = ceil( width / boxSize ) + 1;
  numBoxesY = ceil( height / boxSize ) + 1;
  print("numBoxesX : " + numBoxesX + "\n");
  print("numBoxesY : " + numBoxesY + "\n");
  grid = new ArrayList();
  for( int x = 0; x < numBoxesX;x++ )
  {
    for( int y = 0; y < numBoxesY; y++ )
    {
      GridBox boxx = new GridBox();
      boxx.x = x * boxSize;
      boxx.y = y * boxSize;
      grid.add(boxx);
    }
  }
}

void gridCollisions()
{
  //reset the grid
  int n = grid.size();
  for( int i = 0; i < n; i++)
  {
    GridBox boxx = (GridBox) grid.get(i);
    boxx.balls = new ArrayList();
    boxx.collideTest = false;
    boxx.numBalls = 0;
  }
  //assign each ball ta a grid box
  int t = balls.size();
  for( int i = 0; i < t; i++)
  {
    Ball ball = (Ball) balls.get(i);
    ball.hit = false;
    int x = floor(ball.x / boxSize);
    int y = floor(ball.y / boxSize);
    int index = x * numBoxesY + y;
    GridBox boxx = (GridBox) grid.get(index);
    boxx.balls.add(ball);
    boxx.numBalls++;
  }
  //for each box in the grid
  for( int i = 0; i < n; i++)
  {
    GridBox boxx = (GridBox) grid.get(i);
    //if it contains balls
    if( boxx.balls.size() > 0 )
    {
      //make a list of all boxes to test for a collision against
      ArrayList collidables = new ArrayList();
      collidables.add( boxx );
      int numCollidables = 0;
      //s
      if( i + 1 < n )
      {
        collidables.add( grid.get( i + 1 ) );
        numCollidables++;
      }
      //n
      if( i - 1 >= 0  )
      {
        collidables.add( grid.get( i - 1 ) );
        numCollidables++;
      }
      //e
      if( i - numBoxesY >= 0 )
      {
        collidables.add( grid.get( i - numBoxesY ) );
        numCollidables++;
      }
      //w
      if( i + numBoxesY < n )
      {
        collidables.add( grid.get( i + numBoxesY ) );
        numCollidables++;
      }
      //se
      if( i + 1 - numBoxesY >= 0 )
      {
        collidables.add( grid.get( i + 1 - numBoxesY ) );
        numCollidables++;
      }
      //sw
      if( i - 1 - numBoxesY >= 0 )
      {
        collidables.add( grid.get( i - 1 - numBoxesY ) );
        numCollidables++;
      }
      //ne
      if( i + 1 + numBoxesY < n )
      {
        collidables.add( grid.get( i + 1 + numBoxesY ) );
        numCollidables++;
      }
      //nw
      if( i - 1 + numBoxesY < n )
      {
        collidables.add( grid.get( i - 1 + numBoxesY ) );
        numCollidables++;
      }
      
      ArrayList collisionBalls = new ArrayList();
      int collisionBallsNum = 0;
      for( int s = 0; s<numCollidables;s++)
      {
        GridBox boxCollide = (GridBox) collidables.get(s);
        boxCollide.collideTest = true;
        if( boxCollide.numBalls > 0 )
        {
          for( int p = 0; p < boxCollide.numBalls; p++)
          {
            collisionBalls.add( boxCollide.balls.get(p) );
            collisionBallsNum++;
          }
        }
      }
      
      for( int h = 0; h < collisionBallsNum; h++)
      {
        Ball ball = (Ball) collisionBalls.get(h);
        for( int j = h + 1; j < collisionBallsNum; j++)
        {
          Ball ball2 = (Ball) collisionBalls.get(j);
          if( dist( ball.x,ball.y,ball2.x,ball2.y) < ball.r + ball2.r )
          {
            ball.hit = true;
            ball2.hit = true;
          }
        }
      }
    }
  }
  
}

void bruteForceCollisions( )
{
  int n = balls.size();
  for( int i = 0; i < n; i++)
  {
    Ball ball = (Ball) balls.get(i);
    ball.hit = false;
  }
  for( int i = 0; i < n; i++)
  {
    Ball ball = (Ball) balls.get(i);
    for( int j = i + 1; j < n; j++)
    {
      Ball ball2 = (Ball) balls.get(j);
      if( dist( ball.x,ball.y,ball2.x,ball2.y) < ball.r + ball2.r )
      {
        ball.hit = true;
        ball2.hit = true;
      }
    }
  }
}

void moveBalls()
{
  int n = balls.size();
  for( int i = 0; i < n; i++)
  {
    Ball ball = (Ball) balls.get(i);
    ball.x += ball.vx;
    ball.y += ball.vy;
    if( ball.x <= 0 || ball.x >= width )
    {
      ball.x -= ball.vx;
      ball.vx *= -1;
      ball.x += ball.vx;
    }
    if( ball.y <= 0 || ball.y >= height )
    {
      ball.y -= ball.vy;
      ball.vy *= -1;
      ball.y += ball.vy;
    }
  } 
}

class GridBox
{
  ArrayList balls;
  int numBalls;
  float x;
  float y;
  boolean collideTest;
  GridBox()
  {
    balls = new ArrayList();
  }
}

class Ball
{
  float x;
  float y;
  float r;
  float vx;
  float vy;
  boolean hit;
  
  
  Ball( float x, float y, float r )
  {
    hit = false;
    this.x = x;
    this.y = y;
    this.r = r;
    vx = random(2) - 1;
    vy = random(2) - 1;
  }
}
