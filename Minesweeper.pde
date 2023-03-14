import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 20;
int NUM_COLS = 20;
int minesNum = 20;
int minesCount;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);

    // make the manager
    Interactive.make( this );

    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    mines = new ArrayList <MSButton>();
    for (int r = 0; r < NUM_ROWS; r++){
       for (int c = 0; c < NUM_ROWS; c++){
         buttons[r][c] = new MSButton (r,c);
    }
    }

for(int m = 0; m < minesNum; m++){
      setMines();
}
}
public void setMines()
{
    //your code
    int row = (int)(Math.random() * NUM_ROWS);
    int col = (int)(Math.random() * NUM_COLS);
    if(mines.contains(buttons[row][col]) == false){
      mines.add(buttons[row][col]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
     for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        if(!mines.contains(buttons[r][c]) && !buttons[r][c].clicked){
          return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    String lose = "rip";
    for(int c = 0; c < lose.length(); c++){
      buttons[0][c].setLabel(lose.substring(c, c + 1));
      }
     for (int i=0; i < mines.size(); i++){
      if (mines.get(i).flagged){
        mines.get(i).flagged = false;
      }
      mines.get(i).clicked = true;
     }
}
public void displayWinningMessage()
{
     String win = "nice";
    for(int c = 0; c < win.length(); c++){
       buttons[0][c].setLabel(win.substring(c, c + 1));
    }
}
public boolean isValid(int r, int c)
{
    //your code here
    return (r < NUM_ROWS) && (c < NUM_COLS) && (r >= 0) && (c >= 0);
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
   if (isValid(row-1,col-1)){
      if (mines.contains(buttons[row-1][col-1])){
        numMines++; // neighbor >> top left
      }
    }
    if (isValid(row-1,col)){
      if (mines.contains(buttons[row-1][col])){
        numMines++; // neighbor >> top mid
      }
    }
    if (isValid(row-1,col+1)){
      if (mines.contains(buttons[row-1][col+1])){
        numMines++; // neighbor >> top right
      }
    }
    if (isValid(row,col-1)){
      if (mines.contains(buttons[row][col-1])){
        numMines++; // neighbor >> mid left
      }
    }
    if (isValid(row,col+1)){
      if (mines.contains(buttons[row][col+1])){
        numMines++; // neighbor >> mid right
      }
    }
    if (isValid(row+1,col-1)){
      if (mines.contains(buttons[row+1][col-1])){
        numMines++; // neighbor >> bottom left
      }
    }
    if (isValid(row+1,col)){
      if (mines.contains(buttons[row+1][col])){
        numMines++; // neighbor >> bottom mid
      }
    }
    if (isValid(row+1,col+1)){
      if (mines.contains(buttons[row+1][col+1])){
        numMines++; // neighbor >> bottom right
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;

    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed ()
    {
        clicked = true;
        if(mouseButton == RIGHT){
          if(flagged == true){
            flagged = clicked = false;
          }
          if(flagged == false){
            flagged = true;
          }
        }
          else if(mines.contains(this)){
            displayLosingMessage();
          }
          else if(countMines(myRow, myCol) > 0){
            setLabel(countMines(myRow, myCol));
          }
          else{
            for(int r = myRow - 1; r <= myRow + 1; r++){
              for(int c = myCol - 1; c <= myCol + 1; c++){
                if(isValid(r, c) == true)
                  if(buttons[r][c].clicked == false)
                    buttons[r][c].mousePressed();
              }
            }
          }
    }
    public void draw ()
    {
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) )
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
