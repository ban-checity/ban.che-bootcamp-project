import processing.sound.*;
SoundFile eat, death;
boolean isPlaying;

// list containing x, y co-ordinates of the blocks that make up the snake
ArrayList<Integer> x = new ArrayList(), y = new ArrayList();

// array containing directions of the snake
int[] xDir = {0, 0, 1, -1};
int[] yDir = {1, -1, 0, 0};
int direction;

int foodX, foodY, score;

int w = 30, h = 30, block = 20; // block size for snake and food

boolean gameOver;

void setup() {
  size(600, 600);

  eat = new SoundFile(this, "eat.mp3");
  death = new SoundFile(this, "death.mp3");
  isPlaying = false;

  gameStart();
}

void draw() {
  gameLook();
  fill(255, 0, 0);
  ellipseMode(CENTER);
  ellipse((2 * w) - 10, h, block, block);

  // creates snake
  fill(0, 125, 0);
  for (int i = 0; i < x.size(); i++) {
    rect(x.get(i) * block, y.get(i) * block, block, block);
    fill(0, 200, 0);
  }

  if (!gameOver) {
    fill(255, 0, 0);
    ellipse((foodX * block) + 10, (foodY * block) + 10, block, block);

    textAlign(CENTER);
    textSize(20);
    fill(255);
    text(score, 80, 37);

    // generates snake block
    if (frameCount % 10 == 0) {
      x.add(0, x.get(0) + xDir[direction]);
      y.add(0, y.get(0) + yDir[direction]);

      // checks if snake hits border
      if (x.get(0) < 1 || y.get(0) < 4 || x.get(0) >= (w - 1) || y.get(0) >= (h - 1)) {
        gameOver = true;
      }

      // checks if snake touches itself
      for (int i = 1; i < x.size(); i++) {
        if (x.get(0) == x.get(i) && y.get(0) == y.get(i)) {
          gameOver = true;
        }
      }

      // checks if snake eats food
      if (x.get(0) == foodX && y.get(0) == foodY) {
        eat.play();
        score++;
        // creates food at random spot
        foodX = int(random(1, (w - 1)));
        foodY = int(random(4, (h - 1)));
        for (int i = 0; i < x.size(); i++) {
          if (x.get(i) == foodX && y.get(i) == foodY) {
            foodX = int(random(1, (w - 1)));
            foodY = int(random(4, (h - 1)));
          }
        }
      } else {
        // prevents existing blocks leaving a trail
        x.remove(x.size() - 1);
        y.remove(y.size() - 1);
      }
    }
  } else {
    background(#bbbffc);
    fill(0);
    textSize(30);
    textAlign(CENTER);
    text("GAME OVER \n Your score: " + score + "\n Press Enter to restart", width / 2, height / 3);

    if (!isPlaying) {
      death.play();
      isPlaying = true;
    }

    if (keyCode == ENTER) {
      gameStart();
      death.stop();
      isPlaying = false;
    }
  }
}

void keyPressed() {
  if (keyCode == DOWN || key == 's' && direction != 1) {     // prevents snake from going in itself
    direction = 0;
  }
  if (keyCode == UP || key == 'w' && direction != 0) {
    direction = 1;
  }
  if (keyCode == RIGHT || key == 'd' && direction != 3) {
    direction = 2;
    if (key != 'd') {
    }
  }
  if (keyCode == LEFT || key == 'a' && direction != 2) {
    direction = 3;
  }
}

void gameStart() {
  x.clear();
  y.clear();
  for (int i = 10; i > 7; i--) {
    x.add(i);
    y.add(15);
  }
  foodX = 20;
  foodY = 15;
  direction = 2;
  score = 0;
  gameOver = false;
}

// adds borders and background, makes the game look nicer
void gameLook() {
  noStroke();
  // chess background
  for (int i = 0; i < w; i++)
  {
    for (int j = 0; j < h; j++)
    {
      if (i % 2 == 0 && j % 2 == 0) {
        fill(#73a8ff);
      }
      if (i % 2 == 0 && j % 2 == 1) {
        fill(#8cb8ff);
      }
      if (i % 2 == 1 && j % 2 == 0) {
        fill(#8cb8ff);
      }
      if (i % 2 == 1 && j % 2 == 1) {
        fill(#73a8ff);
      }

      rect(i * block, j * block, block, block);
    }
  }

  // left & right border
  for (int j = 0; j < h; j++) {
    fill(0, 0, 255);
    rect(0, j * block, block, block);
    rect((w - 1) * block, j * block, block, block);
  }
  // top chunk border
  for (int i = 0; i < w; i++) {
    for (int j = 0; j < 3; j++) {
      fill(0, 0, 155);
      rect(i * block, j * block, block, block);
    }
  }
  // top and bottom border
  for (int i = 0; i < w; i++) {
    fill(0, 0, 255);
    rect(i * block, 3 * block, block, block);
    rect(i * block, (h - 1) * block, block, block);
  }
  stroke(0);
}
