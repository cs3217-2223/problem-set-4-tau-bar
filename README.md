# Developer Guide
Do check out my [developer guide](https://github.com/cs3217-2223/problem-set-4-tau-bar/blob/master/dev-guide.md) for my design decisions and justifications :)

# CS3217 Problem Set 4

**Name:** Taufiq Bin Abdul Rahman

**Matric No:** A0218081L

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

In Dodge, the player has is given a certain number chances to shoot balls without hitting any pegs. The game ends when the player either runs out of chances or runs out of balls. If the player runs out of chances, they lose. If the player manages to clear all the balls with chances remaining, then they win. Note that the player can get an additional +1 chance if a ball lands in the bucket. The number of chances if the number of balls is 1 is 1. If number of balls > 1, then chances = floor(90% of number of balls available). The number of remaining chances goes down when the original ball that was shot hits a peg and goes out of bounds without entering the bucket. For example: If a ball hits a zombie peg and the zombie peg ball hits another peg, and the original ball doesn't enter the bucket, the number of remaining chances only goes down by one because the original ball which was shot hit the zombie peg.

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
* Test Palette for Level Designer
  * Board object (pegs, blocks)/Delete buttons
    * When tapped:
      * set `selectedButton` to `bluePegButton`
      * opacity of blue peg button should be 1
      * opacity of other buttons should be 0.2
      * if there was a board object that was selected, it would unselect the board object
  * Board View
    * When board object selected and tapped in a valid location where no overlap and within board bounds:
      * should add a board object into the current `board` with the same asset as the selected button
      * should have a board object appear with its centre at the tapped position
    * When board object selected and tapped in a invalid location where object would be partially/fully out of bounds:
      * `board` should not change (no object added)
      * the board view should not change (no object should be added)
    * When delete button selected and tapped on a position with no objects on it:
      * the board view should not change
  * `BoardObjectView`
    * When delete object button selected and tapped:
      * should remove the object from `board`
      * should remove the `BoardObjectView` from board view
    * When long pressed (any button selected):
      * should remove the object from `board`
      * should remove the `BoardObjectView` from board view
    * When a board object button selected and tapped:
      * should set `selectedObject` to the object represented by the view
      * the board object selected should have alpha of 1.0
      * the other objects on the board should have alpha of 0.5
      * the resize and rotate sliders should appear
    * When a board object is selected and tap a tool that is not resize/rotate
      * set `selectedObject` to nil
      * all board objects should have alpha of 1.0
      * resize and rotate sliders should disappear
    * When panned to a valid location (no overlap and within bounds):
      * `BoardObject` object which represented by view being panned should update its position in `board`
      * BoardObject view should move on the screen to the new position
    * When panned to an invalid location (overlap or out of bounds):
      * `BoardObject` object which represented by view being panned should not update its position in `board`
      * peg view should not move on the screen to the new position
    * When test on different screen size:
      * `height` and `width` of board should adjust based on device screen size
    * When selected and slide rotate slider
      * object should rotate
      * if slide all the way from center position to left should rotate 180 degrees left
      * if slide all the way from center position to right should rotate 180 degrees right
    * When selected and slide size slider
      * object size should change
      * if slide left, size decrease
      * if slide right, size increase
    * When increase slide size slider when object is already colliding with another
      * size slider should not move
      * object size should remain same
      * if decrease, should decrease size 
    * When slide rotation slider towards direction where object is colliding with another
      * rotation slider should not move
      * object rotation should remain same
      * if rotate in other direction, if not obstructed, should rotate 
  * Load Button
    * When tapped:
      * should open Level Select View
      * should show any saved levels in Table View
  * Save Button
    * When tapped and level name is empty
      * should show an alert to enter level name before saving
      * `board` should remain the same
      * board view should not have changed before and after the save
    * When tapped and level name is the name of an existing level
      * should show an alert that level was not saved
      * `board` should remain the same
      * board view should not have changed before and after the save
    * When tapped and level name is a unique name (no other levels currently have that name)
      * should show an alert that level has been saved
      * opening level select view should show one more level than the number of levels before the save
      * `board` should remain the same
      * board view should not have changed before and after the save
    * When close and open app after saving
      * saved level should still be there when opening saved levels 
    * When level name contains non-ASCII
      * should show an error that level was not saved
    * When level name is too long
      * should show an error that level was not saved
  * Reset button
    * When tapped
      * should not have any object views on board view after
      * `board` should not have any objects (`board.objects.count == 0`)
  * Start button
    * When tapped
      * should open the game view controller
  * Level Name Text Field
    * When tapped and level name is not empty
      * should open a keyboard at the bottom of the screen
      * should show a clear ('x') button at the rightmost side of the text field
      * should not change the text that was inside the text field
    * When tapped and level name is empty
      * should open a keyboard at the bottom of the screen
    * When type on keyboard
      * should fill text field with text being typed
      * e.g., type 'abcd' on empty text field should show 'abcd' on text field
      * e.g. type 'abcd' on text field which has 'xz' should show 'xzabcd' on text field
  * Level Select View
    * When tap on a saved level
      * should load `board` with `BoardObject` objects that are at the correct position, rotation and correct colour
      * should load the board view with object views that are at correct position, rotation and correct colour
      * text field should contain the name of the level loaded
      * the balls should be updated to the number of balls for that board
      * the game mode control should be updated to the game mode for that board
    * When tap on new level
      * should hide level select view and show level builder view
      * should show an empty board view (no peg views on board)
      * `board` should be empty (`board.pegs.count == 0`)
      * text field should be empty
      * balls should be 1
      * game mode should be classic
    * When tap on delete all levels
      * should clear all saved levels from table view
      * should delete all saved levels in Core Data that are stored in `BoardData` entity
    * When tap outside the level select view
      * should hide the level select view and show the level builder view
    * When swipe left
      * should show delete button
      * if delete, row should disappear
      * when close and open should stay gone

* Test Palette for Game
  * Menu
    * When loaded
      * theme song should play  
    * When tap start button 
      * theme song should stop playing
      * choose level view should open
      * should see all saved levels if previously saved level
      * if first time, should see 3 preloaded levels, "LEVEL 1", "LEVEL 2", "LEVEL 3" 
    * When tap Level Designer button
      * theme song should stop playing 
      * should open level designer with empty board, balls = 1, game mode classic, level name empty
  * Choose Level
    * When loaded
      * should see all saved levels
      * should see number of each type of peg & block, balls and gamemode
    * When tap level
      * should open game view   
    * When swipe left
      * should show delete button
      * if delete, row should disappear
      * when close and open should stay gone 
    * When press back
      * should go back to main menu 
  * Game view
    * When loaded
      * should start background music
      * should show select master modal
      * rick should be opaque
      * should not be able to dismiss modal except by pressing "FIGHT!"
      * after choosing master, should show bucket, cannon and board objects
    * When load classic mode
      * should show number of balls left
      * should show orange pegs left
    * When load dodge mode
      * should show number of balls left
      * should show number of chances left
      * if balls = 1, then chances should = 1
      * otherwise, chances should = floor(0.9 * balls)
    * When load socre mode
      * should show number of balls left
      * should show timer counting down
      * should show current score = 0
      * should show target score 
    * When tap either Rick or Morty
      * should select that fighter (i.e. selected opaque, other translucent) 
    * When press fight if Rick selected
      * `gameFighter` should be of type `RickFighter`
      * subsequent ball collisions with green peg should be spooky ball
    * When press fight if Morty selected
      * `gameFighter` should be of type `MortyFighter`
      * subsequent ball collisions with green peg should be kaboom    
    * When tapped in a valid location (below the height of the cannon):
      * if there is no ball that was already fired previously and is still on screen:
         * should create a `BallNode` in `BoardScene`
         * `isCannonFired` in `BoardScene` should be set to true
         * should update the rotation of `CannonNode`
         * visually, a ball should appear to emerge from the cannon
         * visually, a ball should move towards the location that was tapped
         * visually, the cannon view should be rotated to aim at the target location
      * else:
         * should do nothing
    * When tapped in an invalid location (above the height of the cannon):
      * should do nothing
    * When ball has been fired and is on the screen:
      * should move around the screen in a realistic looking manner
    * When the ball collides with the edge of the screen/another peg  
      * should bounce off the edge of the screen (regardless of screen size) in a natural & reasonable manner
      * should light up pegs which it collides with
    * When ball collides with same normal peg repeatedly
      * peg should remain lit
      * no visible changes should occur to the peg
      * ball should bounce off peg normally
    * When normal peg has been lit/hit
      * should stay on screen unless ball is stuck or ball falls out of bounds 
    * When the ball is on screen and is stuck on a peg (stationary):
      * should fade out pegs which have been hit
      * should be able to continue moving after the pegs have faded out
    * When the ball falls out of the screen and ball is not spooky:
      * pegs which were hit and are lit should fade from the screen
      * should remove `BallNode` from `BoardScene`
      * `isCannonFired` in `BoardScene` should be set to false
      * should fire another ball if the user taps on the board view again
      * there should not be any ghost objects on the board (no view but ball seems to collide with something)
    * When a ball collides with a zombie peg 
      * ball should collide with the peg as if the peg had no velocity but could move
      * zombie peg should turn into a normal sized ball immediately (not the same size as the zombie peg)
      * there should not be a "ghost" peg where zombie peg once was
     * When a ball collides with a confusement peg
       * confusement peg should light up
       * all board objects should appear at x = boardWidth - position.x and y = boardHeight - position.y
       * ball should have zero velocity after board is rotated
       * if ball collides with confusement peg again, it should rotate the screen again, as long as it is on the screen
     * When ball collides with a green peg when Morty chosen
       * peg should explode and disappear
       * an explosion animation should play
       * objects within 3/4 of the radius of the explosion should disappear
       * objects within the radius of the explosion which were not removed should be thrown off as if they collided with a body
       * the explosion should not destroy the bucket or the cannon or other green pegs
       * the explosion should not destroy the ball
       * the explosion should cause other green pegs to light up (but not explode immediately)
       * the green pegs should explode after a short delay
      * When ball collides with green peg when Rick chosen
        * peg should light up
        * peg should not disappear
        * ball should turn yellow and `isSpooky` should be true
        * when ball falls out of bounds, should reappear at same x-coordinate at top of board
        * if spooky ball goes to either bottom corner of screen, should appear at the top of edge of the screen it was closer to when went out of bounds 
      * When the ball collides with a block
        * should bounce off the polygonal structure realistically  
        * should not change the asset of the block
   * Retreat button (in the game's Board View when came from choose level)
      * When tapped:
         * should dismiss the game view
         * should show the choose level view
   * Exit button (in game's Board view when came from level builder)
     * When tapped:
       * should dismiss game view
       * should show level builder 
    


## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

I think that my PS2 Level Designer was not extensible enough. I tightly coupled the Board with Pegs, and instead should have created a generic board object which can store BoardObjects instead of just Pegs. Eventually, I had to refactor it to store BoardObjects anyway, which took a very long time. 

Another thing I was unhappy with was how I implemented the Core Data, and I found what I thought was a cleaner and clearer way to store the objects in Core Data. The initial way, I had to ensure that my entities conformed to NSObject and NSSecureCoding, which cluttered the model class and tightly coupled it to Core Data since the conforming was done within the main class file. In the new method I use, I use extensions to conform to my custom protocols which allow me to encode and decode from Core Data. This way, my model is not coupled with the persistence logic.

Yet another thing I was unhappy about in my PS2 was the LevelBuilderViewController having too many responsibilities. As I continued developing, the LevelBuilderViewController was slowly becoming a God class and at that point it was too late to be able to refactor it. Therefore, in this PS, I had to refactor the LevelBuilderViewController and split some of the responsibilities to other view controllers.

As for PS3, I think my design was okay, I didn't have to change too much in order to add the new features. I think the most troublesome feature to add was the explosions, but even so I didn't feel like I had to change too much to implement it. One thing I should have done is not assume that there would only be one ball on the board, I think that caused quite a bit of refactoring to be required, since the Zombie Pegs add balls to the board.

Overall, I honestly think I spent more time refactoring/cleaning up my design than working on the actual features, which was quite surprising for me. I tracked the time I took for the refactoring and the time I took for the new features, and while the time taken for the new features wasn't insignificant, it pales in comparison to the time I took to refactor.

If I were to do this PS again, I would fix the stuff I mentioned above, as well as make my UI a little nicer from the get-go in PS2. I spent quite a while redesigning the UI until I was sufficiently happy due to the increased number of buttons & the resize/rotate featres. While I did read PS3 and PS4 before doing PS2, I didn't sufficiently account for those features that I would eventually have to add.

Ultimately this project was a painful but memorable lesson in making my software design extensible and easily maintainable.
