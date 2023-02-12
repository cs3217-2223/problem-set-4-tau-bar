# CS3217 Problem Set 3

**Name:** Taufiq Bin Abdul Rahman

**Matric No:** A0218081L

## Note to grader:
The code from PS2 is in PeggleClone>PeggleClone>PeggleLevelDesigner. The tests from PS2 are in PeggleCloneTests>LevelBuilderTests. Everything else was written for PS3.

I've integrated the level designer to make it easier to manual test myself. When the app is run, it will show the level designer. Build the level and then press the 'START' button to test the PS3 features.

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

## Notes
If you have changed the specifications in any way, please write your
justification here. Otherwise, you may discard this section.

## Dev Guide
Refer to [dev-guide.md](https://github.com/cs3217-2223/problem-set-3-tau-bar/blob/master/dev-guide.md)

## Tests
The tests below are only for features added for PS3. The test palette for PS2 features (level builder) can be found [here](https://github.com/cs3217-2223/problem-set-2-tau-bar/blob/master/README.md).


UI Tests
* Test Palette 
  * Board view
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
      * should bounce off in a natural & reasonable manner
      * should light up pegs which it collides with
    * When the ball is on screen and is stuck on a peg (stationary):
      * should fade out pegs which have been hit
      * should be able to continue moving after the pegs have faded out
    * When the ball falls out of the screen:
      * pegs which were hit and are lit should fade from the screen
      * should remove `BallNode` from `BoardScene`
      * isCannonFired` in `BoardScene` should be set to false
      * should fire another ball if the user taps on the board view again
   * Exit button (in the game's Board View)
      * When tapped:
         * should dismiss the game view
         * should show the level builder view with the board as it was before the game was started
   * Level Builder (only new features)
      * When START button is tapped:
         * should load the level that was on the level builder view in the game view
         * should show one cannon at the top middle of the screen aiming vertically downwards
    
      

## Written Answers

### Design Tradeoffs
> When you are designing your system, you will inevitably run into several
> possible implementations, in which you need to choose one among all. Please
> write at least 2 such scenarios and explain the trade-offs in the choices you
> are making. Afterwards, explain what choices you choose to implement and why.
>
> For example (might not happen to you -- this is just hypothetical!), when
> implementing a certain touch gesture, you might decide to use the method
> `foo` instead of `bar`. Explain what are the advantages and disadvantages of
> using `foo` and `bar`, and why you decided to go with `foo`.

#### 1. How to implement MSKPhysicsBody
I wanted to create a base representation of a physics body. This representation could either be a class or protocol.

##### Class implementation
If it was a class, it would work except for the collision logic. Since the type of physics body (e.g. whether it is a circle or polygon) is not known in MSKPhysicsBody, there would be no way to implement the `collide()` functions (since we don't know how the body would collide with a circle or polygon unless we knew whether the body was a circle or polygon). Swift doesn’t support abstract functions, so one way to simulate an "abstract function" would be to call `assert(false)` if the functions are called from MSKPhysicsBody instead of its subclasses:

```swift
// MSKPhysicsBody.swift

collide(with body: MSKCirclePhysicsBody) {
   assert(false, "This method must be implemented by a subclass.")
}
```

 However, this is considered as bad practice because if somehow the `collide()` function was called from `MSKPhysicsBody` (e.g. forgot to add the new `collide()` function in one of the subclasses), it would cause the app to crash as a result of `assert(false)`.


##### Protocol implementation
Using protocol, we can define the properties and methods of MSKPhysicsBody, that its subclass should have. For methods which have the same implementation across subclasses, we can provide a default method implementation using protocol extensions:

```swift
// MSKPhysicsBody.swift
protocol MSKPhysicsBody {
   // protocol body
}

extension MSKPhysicsBody {
    /// Updates the positon of the body given the specified `timeInterval` to calculate
    /// the new position of the body using Verlet integration.
    func updatePosition(timeInterval: TimeInterval) {
        // some default implementation
    }
    // other default method implementations
}
```

 As for methods which require custom implementation by the subclass, we can leave them with no default implementation (inside the protocol body), so subclasses of MSKPhysicsBody have to implement the methods:

 ```swift
 protocol MSKPhysicsBody {
   /// Simulates collision with an unspecified type of physics body.
    func collide(with body: MSKPhysicsBody) -> Bool

    /// Simulates collision with a circle type of physics body.
    func collide(with body: MSKCirclePhysicsBody) -> Bool

    /// Simulates collision with a polygon type of physics body.
    func collide(with body: MSKPolygonPhysicsBody) -> Bool
 }

 extension MSKPhysicsBody {
   // no default implementation for collide() functions
 }
     
 ```

Suppose we need to add a new MSKPhysicsBody type, we call it `NewMSKPhysicsBody`, we can make it conform to the `MSKPhysicsBody` protocol. We just need to add `collide(with body: NewMSKPhysicsBody)` into `MSKPhysicsBody`:

```swift
// MSKPhysicsBody.swift
protocol MSKPhysicsBody {
   ...
   collide(with body: NewMskPhysicsBody)
   ...
}
```

The subclasses conforming to `MSKPhysicsBody` will be forced to implement the new method, otherwise the program will not compile. This also makes sense since each subclass should define its own implementation on how to handle collisions with this `NewMSKPhysicsBody`.

##### Choice
I chose to use the protocol method.

#### 2. Handling collisions between different types of bodies
Previously, we've established that `MSKPhysicsBody` should be a protocol, and the `collide(with body: MSKPhysicsBody)` should not have a default implementation in the protocol. There are a few methods which we can use to implement the `collide()` in the subclasses.

##### Checking of types & massive switch.
Within the `collide(with: MSKPhysicsBody)` of each subclass we could implement a massive switch statement to handle collisions between that subclass and another subclass:

```swift
/// MSKCirclePhysicsBody.swift
func collide(with body: MSKPhysicsBody) {
   switch body {
      case is MSKCirclePhysicsBody:
         guard let circleBody = body as? MSKCirclePhysicsBody else {
            return
         }
         // custom collision logic betweeen circle-circle
      // other cases
      default:
         print("body is of an unknown type")
   }
}
```

The pros of this is that this is the most straightforward way to implement colliisons between different bodies. It is easy for developers to understand the logic & flow of the program.

The cons of this is that developers who add a new subclass might forget to add the new `case` within each of the subclasses, causing the program to not handle the collisions correctly. This method also doesn’t follow the OCP principle, since we need to change the `collide(with: MSKPhysicsBody)` everytime we add a new type of physics body.

##### Double Dispatch.
Another method is to use the double dispatch method. At compile time, the `collide(with: MSKPhysicsBody)` function is used, since we have no way of knowing what subclasses are colliding. Inside the `collide(with: MSKPhysicsBody)` method, we can call `body.collide(with: self)`:

```swift
// MSKCirclePhysicsBody.swift

/// Handles collision of the circle body with another unspecified type physics body.
func collide(with body: MSKPhysicsBody) -> Bool {
   if !isCollidable(with: body) {
      return false
   }

   return body.collide(with: self)
}
```

At runtime, this will cause the specific subclass function, (e.g. `collide(with body: MSKCirclePhysicsBody)`), allowing the custom collision logic to be run. This has an advantage over the first method since we don’t need to modify the `collide(with: MSKPhysicsBody)` method if we add a new subclass conforming to `MSKPhysicsBody`, rather we just add a new collision function, e.g. `collide(with body: NewMSKPhysicsBody)` into `MSKPhysicsBody`:

```swift
// MSKPhysicsBody.swift

// This function inside protocol does not have default implementation.
func collide(with body: NewMSKPhysicsBody) 
```


This forces each subclass to implement custom collision logic with the new subclass in order to conform to `MSKPhysicsBody`. 

The pros of this method is that it follows OCP since we did not modify the `collide(with: MSKPhysicsBody)` method in any of the subclasses, but rather extended the `MSKPhysicsBody` class by adding `collide(with body: NewMSKPhysicsBody)`.

The cons of this method is that it is more complex than the switch statement method, and requires more code. On top of that, the flow of execution of the program is not immediately clear unless the developer is aware about how double dispatch works.

##### Choice
I chose to use double dispatch method. The reaason being that it is less prone to errors, since it doesn't cause runtime errors if the developer made an error, but rather the error can be caught in compile time.

#### 3. How MSKView and MSKScene are linked
There are two possible ways, one is to let all communication between the MSKView and MSKScene go through the View Controller or allow MSKView and MSKScene to update each other.

##### First method: Everything through View Controller
A possible way to do this would be:
1. When the `step()` function is called, update the scene by getting it to simulate physics and update the nodes in the scene.
2. Once done, call the View Controller (maybe through delegate/observer pattern).
3. View Controller will be the one to update the view based on the changes in the scene.

A visual representation of this flow:

![image](https://user-images.githubusercontent.com/61085398/218305882-1de29880-e5d0-4172-92ca-b76dd7697c74.png)


The pros of this method is that the MSKView can be completely decoupled from MSKScene, the Scene acting like the Model in the MVC pattern. It also allows multiple views to know about changes, since the controller can update multiple views.

The cons of this method is that developers using MSK will have to manually update the view based on the changes in state (such as movement or rotation of nodes). This could lead to the View Controller having too many responsibilities (propagating UI as well as synchronising scene and view).

##### Second method: View presents a Scene.
How this is done is `MSKView` stores a reference to `MSKScene`.

1. When `step()` is called, call `refresh()` on the view.
2. The view calls `update()` on the scene.
3. The scene updates its state. It uses delegate functions to get the view to update (the view is a delegate of the scene).
4. The view is updated.

A visual representation of this flow:

![image](https://user-images.githubusercontent.com/61085398/218270725-5b3e2076-3723-4f5d-b809-e87e096dec32.png)

The pros of this method is that MSKView and MSKScene are automatically synchronised in terms of view and node positions/rotation. All the controller needs to do is call `refresh()`.

The cons of this method is that MSKView is coupled to MSKScene, so changes in MSKScene could lead to having to make changes in MSKView. This also makes MSKView less reusable. It also means that the scene only can update one component about state changes (its delegate).

##### Choice
I chose the second method. This makes it easier future developers using MSK to implement their own game engines, as basic features such as node movements and rotations are already synchronised between `MSKView` and `MSKScene` if they set the View to be the delegate of the scene. 

In addition, if developer doesn't want to use `MSKScene`, they can implement their own Views, since `MSKScene` only stores a reference to a `MSKSceneDelegate`. Developer just has to ensure that the new view conforms to the `MSKSceneDelegate`.

If developer wants make it such that multiple views will know about changes in the scene, can also create a wrapper component which conforms to `MSKBoardSceneDelegate`, which will inform the observers that the state has changed.

