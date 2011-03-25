//This is a Scheme program, Runnable in Dr. Scheme
import draw.*;
import colors.*;
import geometry.*;
import java.util.Random;

// SnakeWorld is our world and it extends from the World class
// the world of Snake and Food
class SnakeWorld extends World{
 
 //CONSTANTS
 private int WIDTH = 100;
 private int HEIGHT = 100;
 
 private int score;
 private Snake snake;
 private Food food;
     
  // Constructor   
  public SnakeWorld(Snake snake,Food food,int score){
    this.snake = snake;
    this.food = food;
    this.score = score;
  }
  
// Draws this world on the canvas of WIDTH x HEIGHT 
// and shows the canvas   
public boolean draw(){
    return this.theCanvas.show() 
    && this.snake.draw(this.theCanvas)
    && this.food.draw(this.theCanvas);
  }

// what happens to this world on every tick of the clock
// Checks if the snake is in rest or has collided or has eaten the food or moving
// Example 1: onTick() of initial world will retrun the same world
public World onTick(){
    if(this.snake.head.dir.equals("rest")){
     return this;
    }
    else{
      if(this.snake.collided(this.HEIGHT,this.WIDTH)){
        return this.endOfWorld("You Lost: ".concat
         ("Your Final Score Is: ").concat(String.valueOf(score)));
       }
       else{
        if(this.food.isConsumed(this.snake)){
          score = score + 1; 
          return new SnakeWorld(this.snake.addSegment(),
                               this.food.getNewFood
                               (this.HEIGHT,this.WIDTH),
                               score);
                             }
                             else{
          return new SnakeWorld(this.snake.move(),this.food,score);
        }
      }
    }
  }

// what happens to this world on a key event
// checks for the four arrow keys and the snake corresponds 
// with appropriate movements
// Example 1:Pressing the "up" arrow on the existing world will 
//            create and return a new World by steering the snake on "up"
//         2.Pressing the "right" arrow on the existing world will 
//            create and return a new World by steering the snake on "right"
public World onKeyEvent(String k){
   if(k.equals("up") || k.equals("down") 
      || k.equals("left") || k.equals("right")){
     return new SnakeWorld(this.snake.steer(k),this.food,score);
   }
   else{
     return this;
   }
 }
 
// invokes BIGBANG to start this world 
public boolean run(){
    return this.bigBang(this.WIDTH,this.HEIGHT,.1) && this.draw();
  }
}

//-----------------------------------------------------------------------------
// Snake class is basically a combination of head and a tail of the snake
// Head is another class and Tail is a cons type of object
class Snake{
  public Head head;
  private IWorm tail;
  
  // Constructor
  public Snake(Head head,IWorm tail){
   this.head = head;
   this.tail = tail;
 }
 
 // Draws this head and this tail of the snake on the canvas by invoking draw()
 public boolean draw(Canvas c){
    return this.head.draw(c) &&  this.tail.draw(c);
  }
  
  // Moves this head of the snake and this tail of the snake 
  // according to the heads movement 
  public Snake move(){
    return new Snake(this.head.move(),this.tail.move(this.head));
  } 
  
  // Checks for collision of this head with the wall or with this Tail
  // Examples: 1.Snake collides return true
  //           2.Snake does not collide return false
  public boolean collided(int height,int width){
    return this.head.collided(height,width) || this.tail.collided(this.head);
  }
  
 // Adds one segment to this tail of the snake
 // Example: 1.Snake has only head and the first segment of the tail is added
 public Snake addSegment(){
   return new Snake(this.head.move(),this.tail.addSegment(this.head));
  }
  
  // Steers or turns this head of the snake as per the key event passed here 
  // Examples:1.Snake is at rest and up arrow key is pressed, 
  //             steers the direction of the head of the snake to "up"
  //          2.Snake is at rest and right arrow key is pressed, 
  //             steers the direction of the head of the snake to "right"
  //          3.Snake is moving "right" and up arrow key is pressed, 
  //             steers the direction of the head of the snake to "up"
  public Snake steer(String k){
    return new Snake(this.head.steer(k),this.tail);
  }
}
//-----------------------------------------------------------------------------
// Commonalities of all the classes extending AProperty
// Its the property for Food, Head and Worm classes
abstract class AProperty{
  protected IColor color;
  protected Posn loc;
  protected int RADIUS = 3;
  
  // Constructor
  protected AProperty(Posn loc,IColor color){
    this.loc = loc;
    this.color = color;
  }
   
  //Draws the Disk of __this__ color on the canvas
  protected boolean draw(Canvas c){
    return c.drawDisk(this.loc,RADIUS,this.color);
  }
}

//-----------------------------------------------------------------------------
// Head is head of the snake which can move, collide and steer
class Head extends AProperty{
 public String dir;
 private int DELTA = 2*RADIUS;
 Posn newP;
 
 // Constructor
 public Head(Posn loc,IColor color,String dir){
   super(loc,color);
   this.dir = dir;
 }
 // Draws this head with a marker in it on the canvas
 public  boolean draw(Canvas c){
   c.drawDisk(this.loc,RADIUS,this.color);
   return c.drawDisk(this.loc,RADIUS-2,new Black());
 }
 
 // Moves this head of the Snake depending on the four arrow keys
 // Examples:1.If the head of the snake is moving right then it will keep moving in
 //            the same direction by DELTA
 //          2.If the head of the snake is moving up then it will keep moving in
 //            the same direction by DELTA
 public Head move(){
   if(this.dir.equals("up")){
     newP = new Posn(this.loc.x,this.loc.y-DELTA);
     return new Head(newP,this.color,this.dir);
   }
   else 
   {
     if(this.dir.equals("down")){
       newP = new Posn(this.loc.x,this.loc.y+DELTA);
       return new Head(newP,this.color,this.dir);
     }
     else{
       if(this.dir.equals("right")){
         newP = new Posn(this.loc.x+DELTA,this.loc.y);
         return new Head(newP,this.color,this.dir);
         }
         else{
         if(this.dir.equals("left")){
            newP = new Posn(this.loc.x-DELTA,this.loc.y);
           return new Head(newP,this.color,this.dir);
         }
         else{
           return this;
         } 
       }
     } 
   }
 }
 
 // Checks for collision of this head with the four walls of the canvas
 //Examples:1.Head is at (0,50) collides with the left wall, return true
 //         2.Head is at (101,50) collides with the right wall, return true
 //         3.Head is at (50,0) collides with the upper wall, return true
 //         4.Head is at (50,101) collides with the lower wall, return true
 //         5.Head is at (50,50) does not collide, return false
 public boolean collided(int height,int width){
   if((this.loc.x+RADIUS >= (width - RADIUS))
      || (this.loc.y+RADIUS >= (height - RADIUS))
      || (this.loc.x-RADIUS <= RADIUS)
      || (this.loc.y-RADIUS <= RADIUS)){
     return true;
   }
   else{
     return false;
   }
 }
 
 // Steers this head depending on the four arrow keys
 // If the opposite arrow key of which the snake is currently moving 
 // is pressed the snake wont respond  
 // Examples: 1.If the head of the snake is at "rest" and left arrow key is
 //             pressed, the head moves in the left direction
 //           2.If the head of the snake is moving in the "left" direction 
 //             and the right key is pressed then too the head of the 
 //             snake still keeps movin towards left 
 public Head steer(String k){
   if((this.dir.equals("up") && k.equals("down")) ||
      (this.dir.equals("down") && k.equals("up")) ||
    (this.dir.equals("left") && k.equals("right")) ||
    (this.dir.equals("right") && k.equals("left"))){
     return new Head(this.loc,this.color,this.dir);
   }
   else{
     return new Head(this.loc,this.color,k);
   }    
 }
}
 
//-----------------------------------------------------------------------------
// Represents the tail of the Snake, its a collection of MTWorm and ConsWorm i.e.
// (cons Worm empty)
// (cons Worm IWorm)
interface IWorm{
  public boolean draw(Canvas c);
  public IWorm move(Head head);
  public boolean collided(Head head);
  public IWorm addSegment(Head head);
 }

//----------------------------------------------------------------------------
// Abstracting the commonalities of the classes extending IWorm
abstract class AWorm implements IWorm{
 protected int RADIUS = 3;
 
 // Adds the segment to the Tail of the snake
 protected IWorm addSegment(Head head){
    Worm worm = new Worm(head.loc,new Red(),head.dir); 
    return new ConsWorm(worm,this);
  }
}

//-----------------------------------------------------------------------------
// Empty Worm represents empty
class MTWorm extends AWorm{
 
 // Constructor
 public MTWorm(){
  }
  
 // Returns true
 public boolean draw(Canvas c){
    return true;
  }
  
 // Returns the current object i.e. this
 public IWorm move(Head head){
    return this;
  }

 // Empty object can never collide so returns false
  public boolean collided(Head head){
    return false;
  }
}

//-----------------------------------------------------------------------------
//Class of type ConsWorm represents (cons Worm IWorm)
class ConsWorm extends AWorm{
  
 private Worm first;
 private IWorm rest;

 // Constructor
 public ConsWorm(Worm first,IWorm rest){
    this.first=first;
    this.rest=rest;
  }
  
  // draws the Tail of the snake on the canvas
  public boolean draw(Canvas c){
    return this.first.draw(c) && this.rest.draw(c);
  }
  
  // Moves the Tail of the Snake by takin the direction from 
  //the head segment
  public IWorm move(Head head){
    Head newHead = new Head(first.loc,first.color,first.dir);
    return new ConsWorm(this.first.move(head),this.rest.move(newHead));
  }
  
  // Check if the Head collides with the Tail of the snake
  // Examples:1.Head does not collide return false
  //          2.Head collides with second segment of the tail return true
  //          3.Head collides with first segment of the tail return true
 public boolean collided(Head head){
    if(((Math.abs(this.first.loc.x - head.loc.x))< 2*RADIUS) && 
       ((Math.abs(this.first.loc.y-head.loc.y)) < 2*RADIUS)){
           return true;
    }
    else{
      return this.rest.collided(head);
    }
  }
 }

//-----------------------------------------------------------------------------
// Worm class represents one segment of the tail and 
// which is the first of the ConsWorm and extends the AProperty class
class Worm extends AProperty{
  public String dir;
     
 // Constructor
 public Worm(Posn loc,IColor color,String dir){
    super(loc,color);
    this.dir = dir;
  }
 
 // Moves this Worm by takin the direction of the head segment
 public Worm move(Head head){
     this.loc = head.loc;
     this.dir = head.dir;
     return new Worm(this.loc,this.color,this.dir);
    }
}

//-----------------------------------------------------------------------------
// Food class ramdomly generates the food and draws at a random location on the
// canvas,it also checks if that food has been consumed and does the needful
class Food extends AProperty{
 private Random r = new Random();

  // Constructor
  public Food(Posn loc,IColor color){
    super(loc,color);
   }
   
  // Checks if the food is consumed or not
  // Examples:1.Head of snake is at (50,32) and Food is at (50,32), food is
  //            consumed return true 
  //          2.Head of snake is at (50,52) and Food is at (50,32), food is
  //            not consumed return false 
  public boolean isConsumed(Snake snake){
   return ((Math.abs(this.loc.x - snake.head.loc.x))< 2*RADIUS) && 
   ((Math.abs(this.loc.y-snake.head.loc.y)) < 2*RADIUS);
 }
   
  // Returns the new Location of the Food
  public Food getNewFood(int height,int width){
    int x= getNewXY(width);
    int y =getNewXY(height);
    return new Food(new Posn (x,y),new Green()); 
  }
   
  // Generates a newfood at a random location on the canvas
  private int getNewXY(int length){ 
    int newValue = r.nextInt(length);
    if((newValue>length-10) || (newValue<10))
    {
     return getNewXY(length);
    }
    else{
      return newValue;
    }
  }
}
//-----------------------------------------------------------------------------
//Examples class for Snake Game
class Examples{
  //----------------------------------------------------------------------------
  // Start the game
  //---------------------------------------------------------------------------- 
  // Initially head is at (50,50) and "rest"
  // Food is at (50,32)
  // and change its direction to "up"
  Posn locWorm = new Posn(50,50); //Worm Location
  Head head = new Head(locWorm,new Red(),"rest");//Head object
  IWorm mtWorm = new MTWorm();//IWorm object with MTWorm
  Snake snake = new Snake(head,mtWorm);//Snake object

  
  Posn locFood = new Posn(50,32);  //Food Location
  Food food1 = new Food(locFood,new Green());//food object
  
  SnakeWorld sw = new SnakeWorld(this.snake,this.food1,0);//SnakeWorld object
  
  boolean testRun = check this.sw.run() expect true;  
  
  //--------------------------------------------------------------------------- 
  //Collision tests
  //---------------------------------------------------------------------------
  
  //--------------------------------
  //Head collision with the wall
  //--------------------------------
  // Example 1: Head collision with the left wall
  Posn locLeftWorm = new Posn(0,50); //Worm Location
  Head headLeft = new Head(locLeftWorm,new Red(),"left");//Head object
  boolean t1=check this.headLeft.collided(100,100) expect true;
 
  // Example 2: Head collision with the right wall
  Posn locRightWorm = new Posn(101,50); //Worm Location
  Head headRight = new Head(locRightWorm,new Red(),"right");//Head object
  boolean t2=check this.headRight.collided(100,100) expect true;
  
  // Example 3: Head collision with the upper wall
  Posn locUpWorm = new Posn(50,0); //Worm Location
  Head headUp = new Head(locUpWorm,new Red(),"up");//Head object
  boolean t3=check this.headUp.collided(100,100) expect true;
  
  // Example 4: Head collision with the lower wall
  Posn locDownWorm = new Posn(50,101); //location object for wormm
  Head headDown = new Head(locDownWorm,new Red(),"down");//Head object
  boolean t4=check this.headDown.collided(100,100) expect true;
  
  // Example 5: No collision
  boolean t5=check this.head.collided(100,100) expect false;
  
  //--------------------------------------------------
  //Head collision with the Tail
  //--------------------------------------------------
  // Example 1: No collision with tail
  Worm worm=new Worm(new Posn(50,55),new Red(),"right");//worm object
  Worm worm2=new Worm(new Posn(0,55),new Red(),"right");
  Worm worm3=new Worm(new Posn(58,55),new Red(),"left");
  Worm worm4=new Worm(new Posn(90,90),new Red(),"up");
  Worm worm5=new Worm(new Posn(60,90),new Red(),"down");
  
  IWorm tail1 =new ConsWorm
  (worm,new ConsWorm(worm2,new ConsWorm(worm3,mtWorm))); //IWorm object
  Snake snake1 = new Snake(headUp,tail1);//snake object
  boolean t6= check this.tail1.collided(headRight) expect false;
  
  // Example 2: Head collides with second segment of the tail
  boolean t7= check this.tail1.collided(headLeft) expect true;
 
  // Example 3: Head collides with the first segment of the tail
  boolean t8= check this.tail1.collided(head) expect true; 
  
  //---------------------------------------
  //Snake collision
  //---------------------------------------
  // Example 1: Snake collides
  boolean t9= check this.snake1.collided(100,100) expect true; 
  
  // Example 2: Snake doesnt collides
  IWorm tail2 =new ConsWorm
  (worm2,new ConsWorm
   (worm3,new ConsWorm(worm4,new ConsWorm(worm5,mtWorm)))); //IWorm object
  Snake snake2 = new Snake(head,tail2);//snake object
 
  boolean t10= check this.snake2.collided(100,100) expect false; 
  
  //----------------------------------------------------------------------------
  //Food Tests
  //----------------------------------------------------------------------------
  // Example 1: Food is consumed
  Posn locFoodWorm = new Posn(50,32); //Worm Location
  Head headFood = new Head(locFoodWorm,new Red(),"down");//Head object for food
  Snake snakeFood= new Snake(this.headFood,this.tail1.addSegment(this.head));
 
  boolean t11=check this.food1.isConsumed(snakeFood) expect true;   
  
  // Example 2: Food is not consumed
  Posn locFood2Worm = new Posn(50,52); //Worm Location
  Head headFood2 = new Head(locFood2Worm,new Red(),"down");//Head object for food
  Snake snakeFood2= new Snake(this.headFood2,this.tail1.addSegment(this.head));

  boolean t12=check this.food1.isConsumed(snakeFood2) expect false; 
  
  //-----------------------------------------------------------------------------
  //Steer Tests
  //-----------------------------------------------------------------------------
  // Snake Steer
  //--------------------------------------------------
  // Example 1: Steering the direction of the head of the snake at rest as "up"
  Posn locSteer = new Posn(50,50); //Worm Location
  Head headSteer = new Head(locSteer,new Red(),"up");//Head object
  Snake snakeSteer = new Snake(headSteer,mtWorm);//Snake object
  
  boolean t14 = check this.snake.steer("up") expect snakeSteer;

  // Example 2: Steering the direction of the head of the snake at 
  // rest as "right"
  Posn locSteer2 = new Posn(50,50); //Worm Location
  Head headSteer2 = new Head(locSteer2,new Red(),"right");//Head object
  Snake snakeSteer2 = new Snake(headSteer2,mtWorm);//Snake object
  boolean t17 = check this.snake.steer("right") expect snakeSteer2;
  
  // Example 3: Steering the direction of the head of the snake 
  // moving in "right" to "up"
  Posn locmid = new Posn(50,50); //location object for wormm
  Head headmid = new Head(locmid,new Red(),"right");//Head object for food
  Snake snakesteer1 = new Snake(headmid,mtWorm);//snake object
  
  Posn locSteer3 = new Posn(50,50); //location object for wormm
  Head headSteer3 = new Head(locSteer3,new Red(),"up");//Head object
  Snake snakeSteer3 = new Snake(headSteer3,mtWorm);//snake object
  boolean t18 = check this.snakesteer1.steer("up") expect snakeSteer3;
  
  //--------------------------------------------
  //Head Steer
  //--------------------------------------------
  // Example 1: Steering the direction of the head at rest as "left"
  Posn locSteer4 = new Posn(50,50); //Worm Location
  Head headSteer4 = new Head(locSteer,new Red(),"left");//Head object
  boolean t19 = check this.head.steer("left") expect headSteer4;
  
  // Example 2: Steering the direction of the head moving in "left" to "right" 
  // will keep the direction of the head as "left"
  Posn locSteer5 = new Posn(50,50); //Worm Location
  Head headSteer5 = new Head(locSteer,new Red(),"left");//Head object
  boolean t20 = check this.headSteer4.steer("right") expect headSteer5;
  
  //-------------------------------------------------------------------------
  // AddSegment Tests
  //--------------------------------------------------------------------------
  // Snake AddSegment
  //----------------------------
  // Example 1: Snake has only head and the first segment of the tail is added
  Worm wormMove=new Worm(new Posn(50,50),new Red(),"rest");
  IWorm tail3= new ConsWorm(wormMove,mtWorm);
  Snake snakemid = new Snake(headmid,mtWorm);//Snake object
  Snake snakeSegment = new Snake(headmid,tail3);//snake object
 
  boolean t13 =check this.snakemid.addSegment() expect snakeSegment;
  
  //---------------------------------------------------------------------------
  // Move Tests
  //---------------------------------------------------------------------------
  // Head move
  //----------------------------------------------------
  // Example 1: Moves the head by 2*RADIUS in the same direction i.e."right"
  Posn locmove4 = new Posn(40,50); //Worm Location
  Head headmove4 = new Head(locmove4,new Red(),"right");//Head object
  Posn newPt = new Posn(46,50);
  Head newheadmove4 = new Head(newPt,new Red(),"right");
  boolean t21 = check this.headmove4.move() expect newheadmove4;
  
  // Example 2: Moves the head by 2*RADIUS in the same direction i.e. "up"
  Posn locmove5 = new Posn(20,10); //Worm Location
  Head headmove5 = new Head(locmove5,new Red(),"up");//Head object
  Posn newPt2 = new Posn(20,4);
  Head newheadmove5 = new Head(newPt2,new Red(),"up");
  
  boolean t22 = check this.headmove5.move() expect newheadmove5;
  
  //---------------------------------------------------------------------------
  //SnakeWorld Tests
  //---------------------------------------------------------------------------
  // onKeyEvent() Tests
  //--------------------------------
  // Example 1: Pressing the "up" arrow on the initial world will 
  // create and return a new World by steering the snake on "up"
  boolean testkeyevent1 = check this.sw.onKeyEvent("up") 
  expect(new SnakeWorld(this.snake.steer("up"),this.food1,0));
  
  // Example 2: Pressing the "right" arrow on the initial world will 
  // create and return a new World by steering the snake on "right"
  boolean testkeyevent2 = check this.sw.onKeyEvent("right") 
  expect (new SnakeWorld(this.snake.steer("right"),this.food1,0));
  
  // onTick() Tests
  //--------------------------------
  // Example 1: onTick() on the initial world will return the same world
  boolean testtick1 = check this.sw.onTick() expect sw;
  
  //-----------------------------------------------------------------------------
}