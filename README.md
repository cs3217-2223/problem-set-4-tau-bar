# CS3217 Problem Set 4

**Name:** Your name

**Matric No:** Your matric no

## Tips
1. CS3217's docs is at https://cs3217.github.io/cs3217-docs. Do visit the docs often, as
   it contains all things relevant to CS3217.
2. A Swiftlint configuration file is provided for you. It is recommended for you
   to use Swiftlint and follow this configuration. We opted in all rules and
   then slowly removed some rules we found unwieldy; as such, if you discover
   any rule that you think should be added/removed, do notify the teaching staff
   and we will consider changing it!

   In addition, keep in mind that, ultimately, this tool is only a guideline;
   some exceptions may be made as long as code quality is not compromised.
3. Do not burn out. Have fun!

## Dev Guide
You may put your dev guide either in this section, or in a new file entirely.
You are encouraged to include diagrams where appropriate in order to enhance
your guide.

## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Game
To start playing, press the Start button on the Main Menu. If it is your first time loading, you should see 3 pre-loaded levels, named "LEVEL ONE", "LEVEL TWO" and "LEVEL THREE". Press on one of the levels to start playing.

You will see a screen asking you to choose your master, either Rick (left) or Morty (right). Rick should be opaque and Morty should be translucent. Tap to select either one and press "FIGHT!" to start.

### Fighters
If you choose Rick, green pegs are spooky. By the power of Rick's portal gun, when a ball collides with a green peg, it turns yellow to indicate that it is a spooky ball. When it falls out of bounds, it reappears at the top of the board at the same x-coordinate.

If you choose Morty, green pegs are Ka-Boom i.e., will explode on impact with a ball. It will destroy nearby pegs and throw pegs within its blast radius away. If another green peg is within blast range, it will get triggered (light up) and explode after a delay.

### Pegs
The different pegs have different events. Blue and orange pegs are normal pegs, light up when the ball collides with them. Purple pegs are Zombie pegs, and will turn into another ball when a ball collides with it. Green pegs are power up pegs which have different powers depending on which Fighter you chose (explained above). Red pegs are confusement pegs, by the power of Shleemypants, it disrupts the time-space continuum and flips the board upside down (180 degrees)! 

Note that if a ball is stuck on a peg, all the pegs which were hit previously (light up) will get rmeoved from the screen. When the ball falls out of bounds, all the light up pegs (which weren't already removed) get removed.

### Blocks
Blocks are just obstacles. They are square in shape and don't have any effects when the ball collides with it. Note that they can also get destroyed by green Kaboom pegs or get moved away. Note that if a level is designed poorly, the ball can get stuck and the blocks won't get removed, because only pegs can get removed when ball is stuck.

### Cannon Direction
The player aims the cannon by tapping on the board where they want the cannon to shoot. The cannon will rotate and shoot in the direction of the tap such that the ball will head towards the tapped location. If there are no obstacles in the way (pegs/blocks), then the ball will reach the tapped location.

### Win and Lose Conditions
There are 3 different game modes, Classic, Score, and Dodge mode.

In Classic, the player is has to eliminate all the orange pegs with the given number of balls. Each level has a number of balls provided to the player. If the player successfully eliminates all the orange pegs before using up all the available balls, they win. Note that the player can obtain more balls if balls enter the bucket.

In Score, the player has to obtain a certain score in a certain amount of time without running out of balls. Similar to Classic, each level has a number of balls provided to the player. If the player successfully hits the score requirement, then they win. If the player runs out of time, or runs out of balls before hitting the target score, then they lose. Note that the player can obtain an additional ball if a ball lands in the bucket. The target score (as of now) is defined to be floor(90% of the total possible score from the pegs only).

In Dodge, the player has is given a certain number chances to shoot balls without hitting any pegs. The game ends when the player either runs out of chances or runs out of balls. If the player runs out of chances, they lose. If the player manages to clear all the balls with chances remaining, then they win. Note that the player can get an additional +1 chance if a ball lands in the bucket. The number of chances if the number of balls is 1 is 1. If number of balls > 1, then chances = floor(90% of number of balls available).

## Level Designer Additional Features
The following features require a player to select a board object: resizing, rotating.

When user initially opens level designer, user will see 5 different peg buttons, (blue, orange, purple, red, green) and a block (grey color). Initially, the orange peg button will be selected. This means that if player taps the board, an orange peg will be placed. 

Suppose user has already placed a number of board objects. When the user taps on one of the board objects, it will select the board object. The selected object will be opaque, and the other objects will be translucent. This means that the player can now resize/rotate that peg. Two sliders, one labelled with Size and the other labelled with Rotation should have appeared. 

### Peg Rotation
To rotate pegs/blocks, the player can select the peg/block and use the slider. Sliding it left means the object will rotate to the left, sliding it right means the object will rotate to the right. The player is able to rotate the peg/board 180 degrees in each direction (making a total of 360 degrees).

### Peg Resizing
To resize peg/blocks, player can select the peg/block and use slider. Sliding it left decreases the size, sliding it right increases the size.

## Bells and Whistles
### Sound & Music
When player enters Main Menu, the Rick & Morty theme song will play. When user enters Game view, game music will play. When player shoots cannon, a cannon firing sound plays. When ball collides with peg, a pop sound will play. When pegs disappear from screen (either when ball stuck or when ball out of bounds) a death sound will play. When a ball enters the bucket, a sound of a guy saying "Hemorrhage" will play. When one of the green pegs explode, an explosion sound will play.

### Custom Assets
As Rick and Morty, you are fighting the Gromflomites with the help of Shleemypants, Night Morty and Hemhorrage. The pegs have alien assets on them to give a more theme feel.

### Viewing number of pegs/blocks when choosing level
When you press START from Main Menu, you can see all the levels that are saved. You can see the number of each type of peg, blocks, number of balls and the game mode.

### Seeing score when hitting pegs/seeing status update when ball enters bucket
When ball collides with pegs, or enters bucket, you can see the number of points earned for hitting that peg. When ball enters bucket, you can see what status update happens (e.g. +1 ball, or +1 chance in dodge mode).

### Timer in Score mode
In Score Mode, you are able to see a countdown timer at the top left.

### Number of balls left/win-lose conditions
At the top left of the game screen, you can see the game state, e.g. number of balls left. In classic, you see balls and orange pegs left. In score, you see balls left, score, and the target score and the countdown. In dodge, you can see number of balls left and the number of chances left.


## Tests
If you decide to write how you are going to do your tests instead of writing
actual tests, please write in this section. If you decide to write all of your
tests in code, please delete this section.

## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

Your answer here
