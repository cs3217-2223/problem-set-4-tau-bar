<!-- vscode-markdown-toc -->
* [Peggle Clone Architecture](#PeggleCloneArchitecture)
* [Control Flows](#ControlFlows)
	* [User Interactions](#UserInteractions)
	* [Game Loop](#GameLoop)
* [MSKPhysicsEngine](#MSKPhysicsEngine)
	* [MSKPhysicsWorld](#MSKPhysicsWorld)
	* [MSKPhysicsBody](#MSKPhysicsBody)
	* [MSKCirclePhysicsBody & MSKPolygonPhysicsBody](#MSKCirclePhysicsBodyMSKPolygonPhysicsBody)
	* [MSKPhysicsBodyDelegate](#MSKPhysicsBodyDelegate)
* [MSKSceneRenderers](#MSKSceneRenderers)
	* [MSKScene](#MSKScene)
	* [MSKNode & MSKSpriteNode](#MSKNodeMSKSpriteNode)
	* [MSKView](#MSKView)
* [BoardScene](#BoardScene)
* [Nodes](#Nodes)
	* [PegNode](#PegNode)
	* [BluePegNode, OrangePegNode](#BluePegNodeOrangePegNode)
	* [Special Peg Nodes](#SpecialPegNodes)
	* [BallNode](#BallNode)
	* [CannonNode](#CannonNode)
	* [BucketNode](#BucketNode)
* [Physics](#Physics)
	* [BallPhysicsBody](#BallPhysicsBody)
	* [PegPhysicsBody](#PegPhysicsBody)
	* [BucketPhysicsBody & BucketBasePhysicsBody](#BucketPhysicsBodyBucketBasePhysicsBody)
* [Game State](#GameState)
* [GameFighter](#GameFighter)
* [Level Designer](#LevelDesigner)
	* [Architecture](#Architecture)
	* [Model Component](#ModelComponent)
		* [Component Structure](#ComponentStructure)
		* [`NSObject`, `NSSecureCoding` Protocol](#NSObjectNSSecureCodingProtocol)
		* [`BoardKeys`, `PegKeys`, `PositionKeys`](#BoardKeysPegKeysPositionKeys)
	* [View Component](#ViewComponent)
		* [Level Builder View](#LevelBuilderView)
		* [Level Select View](#LevelSelectView)
	* [Controller Component](#ControllerComponent)
		* [`LevelBuilderViewController`](#LevelBuilderViewController)
		* [`LevelSelectViewController`](#LevelSelectViewController)
	* [Storage Component](#StorageComponent)
		* [`BoardsTransformer`](#BoardsTransformer)
		* [`DataManager`](#DataManager)
* [Implementation](#Implementation)
	* [Select Peg Button](#SelectPegButton)
	* [Add Peg](#AddPeg)
	* [Delete Peg](#DeletePeg)
		* [Tapping `BoardPegView`](#TappingBoardPegView)
		* [Long pressing `BoardPegView`](#LongpressingBoardPegView)
	* [Move Peg](#MovePeg)
	* [Reset Board](#ResetBoard)
	* [Save Board](#SaveBoard)
	* [View saved levels](#Viewsavedlevels)
	* [Load saved level](#Loadsavedlevel)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# Overall Structure
## <a name='PeggleCloneArchitecture'></a>Peggle Clone Architecture
The `GameViewController` controls the Peggle Game Engine.

The Peggle Game Engine is built upon MySpriteKit.

![image](https://user-images.githubusercontent.com/61085398/218303956-bad4bb10-ec03-4614-9bca-a2adea9cc61c.png)


## <a name='ControlFlows'></a>Control Flows
There are two main flows. 

### <a name='UserInteractions'></a>User Interactions
First, the handling of user interactions:

![image](https://user-images.githubusercontent.com/61085398/218270661-724caebf-1bc6-45c8-ae6c-bdac86edb946.png)

The user interacts with the Board View (e.g. tapping the board to shoot the ball).

The event is propagated to the Board Scene. The Board Scene updates its internal state. A more detailed sequence for the example of shooting the cannon can be seen here:

![image](https://user-images.githubusercontent.com/61085398/218303137-1fc51d31-bc26-4ed0-9e4a-c69064d87313.png)

Suppose we consider the event of shooting a cannon. The user taps the screen where they want to fire the cannon. The `didTapBoardView()` method is called in the `GameViewController`. If it is a valid tap location, `fireCannon()` is called. `BoardScene` updates its state such that the cannon is fired, and then calls `cannon?.updateAngle()` to update the cannon node's angle. The refresh loop (explained in [Game Loop](GameLoop)) refreshes the view and the user sees the cannon rotated to the shooting angle.

### <a name='GameLoop'></a>Game Loop
The second flow would be continuous update of the scene based on the game loop. The flow is illustrated below:

![image](https://user-images.githubusercontent.com/61085398/218270725-5b3e2076-3723-4f5d-b809-e87e096dec32.png)

For a more detailed view, refer to the following sequence diagram:

![image](https://user-images.githubusercontent.com/61085398/218302494-966ac603-ee7b-487a-92c3-d6ee1771a4fe.png)


The game loop (implemented using `CADisplayLink`) is done within the `GameViewController`. The game loop calls the `step()` function, whch calls the `refresh()` function of the Board View. The BoardView then calls `update()` on the scene. The update() function in MSKScene calls `physicsWorld.simulatePhysics()` and `didSimulatePhysics`:

```swift
/// Updates the scene with the current time interval.
func update(timeInterval: TimeInterval) {
    // Simulate physics over the time interval
    physicsWorld.simulatePhysics(timeInterval: timeInterval)

    // Logic to be run after the physics has been simulated,
    // e.g. update, add, remove nodes.
    didSimulatePhysics()
}
```

The `didSimulatePhysics()` function updates the positions & rotations of the nodes, and calls the delegate functions, `didUpdateNode()` and `didRotateNode()`. `BoardView`, which is the delegate, will update the rotation and position of the subviews, and this is seen by the user.

In `BoardScene`, the `update()` function is overridden to add some Peggle-specific logic:

```swift
/// Updates the state of the scene over the `timeInterval`.
    override func update(timeInterval: TimeInterval) {
        super.update(timeInterval: timeInterval)
        updateBucketPos()

        for node in nodes {
            guard let ballNode = node as? BallNode else { continue }
            if isOutOfBounds(node: ballNode) {
                handleResetBall(ballNode: ballNode)
            }
        }
    }
```
It checks that if a ball is out of bounds, the ball is reset. In the case that a ball is spooky, it is put at the top of the screen at the same x-coorindate, otherwise it is removed from the scene. If the original ball that was fired goes out of bounds and it is not spooky, then the pegs which were hit are removed. Upon removing the pegs, the `delegate?.didRemoveNode()` is called. `BoardView`, being the delegate, removes the subviews from the screen, and the user sees the hit pegs fading out of the screen.


# MySpriteKit
MySpriteKit (MSK) is a lightweight framework inspired by Apple's SpriteKit framework for simulating physics worlds and rendering. It consists of two main components, the Physics Engine, and the Scene Renderers.

## <a name='MSKPhysicsEngine'></a>MSKPhysicsEngine
The Physics Engine is a standalone capability which is able to simulate physics worlds and handle the interactions between the bodies between the worlds. Below is a class diagram to illustrate the relationship between the classes in MSKPhysicsEngine.

![image](https://user-images.githubusercontent.com/61085398/218266704-a2d57c18-11e6-45b4-904a-45273741290b.png)

The Physics Engine uses [Verlet Integration](https://www.algorithm-archive.org/contents/verlet_integration/verlet_integration.html) for the simulations & calculations.

### <a name='MSKPhysicsWorld'></a>MSKPhysicsWorld
This represents the physics world which is being simulated. It contains `MSKPhysicsBody` objects, stored in the `bodies` attribute. The most important function is the `simulatePhysics()`, which simulates the physics within a certain time interval.

``` swift
/// Conducts physics simulations on the physics world within the specified time interval.
func simulatePhysics(timeInterval: TimeInterval) {
    for _ in 0..<substeps {
        applyGravity()
        handleCollisions(timeInterval: timeInterval / Double(substeps))
        updateObjects(timeInterval: timeInterval / Double(substeps))
    }
}
```

The `for` loop within is to allow for more realistic looking simulation by updating the bodies' states mulitple times within a time interval, however it affects performance. The default is set to 2.

`applyGravity()` function applies gravity to the bodies by adding acceleration to the body.
`handleCollisions()` function checks for collisions between all the bodies and updates the physics state of the objects if there is a collision.
`updateObjects()` function updates the positions of the objects after all the collisions have been handled.

To prevent external classes from misusing the physics simulation, only the `simulatePhysics()` method is exposed.

### <a name='MSKPhysicsBody'></a>MSKPhysicsBody
This is a protocol which is conformed to by classes which represent bodies in the physics world. Most notably, it has the `collide(with: MSKPhysicsBody)` function. It also has the `collide(with: MSKCirclePhysicsBody)` and `collide(with: MSKPolygonPhysicsBody)` functions. All the other functions which help with updating the state of the physics body have a default implementation, using protocol extension.

```swift
extension MSKPhysicsBody {
// default method implementations
}
```

The classes which implement `MSKPhysicsBody` must implement custom collision logic with other bodies, such as `MSKCirclePhysicsBody` and `MSKPoylgonPhysicsBody`.

This is done using the double dispatch method.

```swift
func collide(with body: MSKPhysicsBody) -> Bool {
        if !isCollidable(with: body) {
            return false
        }

        return body.collide(with: self)
}
```

At compile-time, the type of body being collided with is unknown, so `collide(with body: MSKPhysicsBody)` is used. At runtime, the type is known, either `MSKCirclePhysicsBody` or `MSKPolygonPhysicsBody`. So, either `collide(with body: MSKCirclePhysicsBody)` or `collide(with body: MSKPolygonPhysicsBody)` will be used when `body.collide(with: self)` is called.

The `isCollidable()` method uses the `categoryBitMask` property to check whether two bodies can collide. The `categoryBitMask` property is a `UInt32` type. If the AND of two bodies' `categoryBitMask` is not equal to zero, it means that they can collide.

### <a name='MSKCirclePhysicsBodyMSKPolygonPhysicsBody'></a>MSKCirclePhysicsBody & MSKPolygonPhysicsBody
These are classes implementing the `MSKPhysicsBody` protocol.

`MSKCirclePhysicsBody` has a radius.

`MSKPolygonPhysicsBody` stores the vertices relative to the `position` of the physics body, to determine the shape of the body. The vertices should be in order, either clockwise or anticlockwise.

As mentioned above, collisions are handled using double dispatch method.

### <a name='MSKPhysicsBodyDelegate'></a>MSKPhysicsBodyDelegate
This is a protocol implemented by classes which use `MSKPhysicsBody`. There are two methods, `didUpdatePosition()` and `didUpdateAngle()`, which are called whenever the physics body has updated its position or angle respectively.

Classes implementing `MSKPhysicsBody` has a reference to an `Optional<MSKPhysicsBodyDelegate>`.

## <a name='MSKSceneRenderers'></a>MSKSceneRenderers
The Scene Renderers are used for managing the state of the scene and to render the scene onto a view. The class diagram below illustrates how the components interact:

![image](https://user-images.githubusercontent.com/61085398/218269781-21c0ccbf-4406-4712-8159-17a74b48ee79.png)

### <a name='MSKScene'></a>MSKScene
This class represents the scene that's being rendered. It stores a reference to a `MSKPhysicsWorld`, and to the nodes within the scene. There is a 1:1 mapping between each node in the scene and a physics body in the physics world.

There are two important functions in MSKScene, `update()` and `didSimulatePhysics()`.

```swift
/// Updates the scene with the current time interval.
func update(timeInterval: TimeInterval) {
    // Simulate physics over the time interval
    physicsWorld.simulatePhysics(timeInterval: timeInterval)

    // Logic to be run after the physics has been simulated,
    // e.g. update, add, remove nodes.
    didSimulatePhysics()
}
```

```swift
/// Updates the visual representation of the scene  once `physicsWorld` has completed physics simulation.
func didSimulatePhysics() {
    updateNodePositions()
    updateNodeRotation()
}
```

`didSimulatePhysics()` updates positions of the nodes and their rotations after the physics simulation is done.

These functions help to update the state in accordance with the loop.

### <a name='MSKNodeMSKSpriteNode'></a>MSKNode & MSKSpriteNode
Represents the nodes within the scene. Each node stores a reference to its physics body, and it is a `MSKPhysicsBodyDelegate`.

Upon changes in the physics body, `didUpdatePosition()` or `didUpdateAngle()` are called by the physics body, which updates the position/rotation of the node.

### <a name='MSKView'></a>MSKView
View which renders `MSKScene`. It stores a reference to the scene that it is presenting, and also serves as `MSKSceneDelegate` for the `MSKScene` object.

The important function is `refresh()`, which refreshes the view, allowing user to visually see the updates in the state of the scene.
```swift
/// Refreshes the state of the scene to the current time.
    func refresh(timeInterval: TimeInterval) {
        scene?.update(timeInterval: timeInterval)
    }
```

The `refresh()` function calls `scene?.update()`. Upon changes in the scene, the delegate functions (`didRemoveNode()`, `didAddNode()`, `didUpdateNode()`, `didRotateNode()`), are called, causing the view to update itself to stay synced with the scene.

# Game Engine
To implement Peggle specific logic & UI, MSK is used to implement the custom physics, scene and view.

## <a name='BoardScene'></a>BoardScene
`BoardScene` stores the state of the game. It inherits from `MSKScene`.

The custom property added on top of `MSKScene` is `isCannonFired`. If true, the cannon can't be fired (as it has already been fired).

There are a few important functions, `fireCannon()`, `handleResetBall()` and `removeHitPegs()`.

`fireCannon(at tapLocation: CGPoint)` shoots the cannon by creating a `BallNode`. The `tapLocation` is used to calculate the angle to fire the ball, as well as to rotate the cannon. If `isCannonFired` is false, nothing happens.

`handleResetBall()` resets the ball when it goes out of bounds. If the ball is spooky, it calls `resetSpookyBall()`. If the ball is not spooky, it calls `removeHitPegs()` and updates the game state (e.g. reducing balls left by 1).

`removeHitPegs()` removes the pegs that were hit by the ball when the ball goes out of the scene (falls out the bottom).

## <a name='Nodes'></a>Nodes
There are a number of different node classes, which represent the pegs, the ball and the cannon.

### <a name='PegNode'></a>PegNode
Represents the pegs in the scene. It contains a `isHit` property to indicate whether the ball has hit the peg. It also stores a reference to a `PegNodeDelegate`.

It conforms to the `PegPhysicsBodyDelegate` protocol, so it has `didCollideWithBall()` function.

```swift
func didCollideWithBall(ballBody: BallPhysicsBody) {
    isHit = true
    delegate?.didCollideWithBall(pegNode: self)
}
```

### <a name='BluePegNodeOrangePegNode'></a>BluePegNode, OrangePegNode
There are 2 basic subclasses, `BluePegNode` and `OrangePegNode`. These classes override the `didCollideWithBall()` function to implement custom logic upon colliding with the ball (changing the image to be the glowing variant). For example:

```swift
override func didCollideWithBall(ballBody: BallPhysicsBody) {
        image = UIImage(named: "peg-blue-glow")
        super.didCollideWithBall()
}
 ```
 
### <a name='SpecialPegNodes'></a>Special Peg Nodes
In addition, there are 3 special peg nodes, `RedPegNode`, `GreenPegNode`, `PurplePegNode`. These pegs represent the Confusement, Power and Zombie pegs respectively.

The Red Peg calls the custom Confusement peg logic as such:
```swift
override func didCollideWithBall(ballBody: BallPhysicsBody) {
	image = UIImage(named: "peg-red-glow")
	if !isHit {
    		delegate?.didUpsideDown(pegNode: self)
	}
	super.didCollideWithBall(ballBody: ballBody)
}
```

The Green Peg calls the custom power logic as such:
```swift
override func didCollideWithBall(ballBody: BallPhysicsBody) {
        image = UIImage(named: "peg-green-glow")
        delegate?.didActivatePower(pegNode: self, ballBody: ballBody)
        super.didCollideWithBall(ballBody: ballBody)
    }
```

The Purple Peg calls the custom Zombie logic as such:
```swift
override func didCollideWithBall(ballBody: BallPhysicsBody) {
        image = UIImage(named: "peg-purple-glow")
        delegate?.didTurnIntoBall(pegNode: self)
        super.didCollideWithBall(ballBody: ballBody)
    }
```

 
### <a name='BallNode'></a>BallNode
 Represents the ball in the scene. It stores a reference to a `BallNodeDelegate`.
 
 It conforms to the `BallPhysicsBodyDelegate` protocol, so it has the `handleBallStuck()` function.
 
 ```swift
 func handleBallStuck() {
        delegate?.handleBallStuck()
 }
 ```

A Ball Node can also be spooky (if it collided with a Spooky Peg previously). It stores this in `isSpooky`:
```swift
var isSpooky = false {
        didSet {
            if isSpooky {
                image = BallNode.spookyImage
            } else {
                image = BallNode.defaultImage
            }
            delegate?.didChangeSpooky(ballNode: self)
        }
    }
```
The `image` is automatically changes using the `didSet` observer.

### <a name='CannonNode'></a>CannonNode
 It represents the cannon. The notable thing is that its physics body has a `categoryBitMask` of 0 (i.e. 0x00000000) so it does not collide with anything.

### <a name='BucketNode'></a>BucketNode
This represents the bucket at the bottom of the screen. It conforms to `BucketBasePhysicsBodyDelegate`, which has the function `didBallCollideWithBucketBase()` which is called by `BucketBasePhysicsBody` when it collides with a ball (i.e. ball enters the bucket). It also stores a reference to `BucketNodeDelegate`, which has the function `didEnterBucket(ball: BallPhysicsBody)`.

### BlockNode
This represents a square block. It has no special collision logic, and there is nothing notable.

## <a name='Physics'></a>Physics
The physics bodies implemented for this game use `MSKPhysicsEngine`. 

### <a name='BallPhysicsBody'></a>BallPhysicsBody
This class subclasses `MSKCirclePhysicsBody`, and stores a reference to a `BallPhysicsBodyDelegate`. This class is implemented so that we can implement custom Ball physics body collision logic, such as checking whether the ball is stuck using the `isStationary()` method in `BallPhysicsBody`:

```swift
// BallPhysicsBody.swift
override func collide(with body: MSKPhysicsBody) -> Bool {
    let didCollide = super.collide(with: body)

    if isStationary(), didCollide {
        ballPhysicsBodyDelegate?.handleBallStuck()
    }

    return didCollide
}
```

Should the be stuck, we can call `ballPhysicsBodyDelegate?.handleBallStuck()`. We can also add more custom logic in the future in this class.

### <a name='PegPhysicsBody'></a>PegPhysicsBody
This class subclasses `MSKCirclePhysicsBody`, and stores a reference to a `PegPhysicsBodyDelegate`. This class is implemented so that we can implement custom Peg physics body collision logic with a ball physics body. If the peg did collide with a ball physics body, we can call `pegPhysicsBodyDelegate?.didCollideWithBall()`.

```swift
func collide(with body: BallPhysicsBody) -> Bool {
    if super.collide(with: body) {
        pegPhysicsBodyDelegate?.didCollideWithBall(ballBody: body)
        return true
    } else {
        return false
    }
}
```

### <a name='BucketPhysicsBodyBucketBasePhysicsBody'></a>BucketPhysicsBody & BucketBasePhysicsBody
The BucketPhysicsBody represents the physics body of the bucket. It stores references to 3 physics bodies, to represent the left, right and bottom of the bucket (since the bucket is not a convex polygonal shape). It has the `move()` function (to move the entire bucket):
```swift
/// Moves the entire bucket, including base and sides.
func move(by displacement: SIMD2<Double>) {
	position += displacement
	bucketBase.position += displacement
	bucketLeft.position += displacement
	bucketRight.position += displacement

	delegate?.didUpdatePosition()
}
```

The BucketBasePhysicsBody stores a reference to a `BucketBaseDelegate` which it uses when a ball collides with it. It overrides the `collide()` function and has a `collide(with body: BallPhysicsBody)` for custom collision logic with `BallPhysicsBody`.

```swift
override func collide(with body: MSKPhysicsBody) -> Bool {
        guard let body = body as? BallPhysicsBody else {
            return super.collide(with: body)
        }

        let didCollideWithBall = self.collide(with: body)

        return didCollideWithBall
}

func collide(with body: BallPhysicsBody) -> Bool {
	if super.collide(with: body) {
	    bucketBaseDelegate?.didBallCollideWithBucketBase(ball: body)
	    return true
	} else {
	    return false
	}
}
```

## <a name='GameState'></a>Game State
Game State represents the state of the game mode. There are 3 game modes, Classic, Score and Dodge. As such, there are 3 classes, `ClassicState`, `DodgeState`, `ScoreState` which conform to `GameState` protocol.

The important functions are `isGameWon()`, `isGameLost()`, `didCollideWithBall()` and `didBallEnterBucket()`. These are customizable by the subclass conforming to `GameState`, since they are varying for the different game modes.

For example, `isGameWon()` in `ScoreState`:
```swift
func isGameWon() -> Bool {
        currentScore >= scoreToHit
}
```

It is easy to imagine that there are different win-conditions in different game modes, and they are defined in this function. Similarly for the rest of the functions, the subclass can customize the logic that should run when any of the events occur (e.g. ball entering bucket, ball hitting peg node, etc.).

## <a name='GameFighter'></a>GameFighter
GameFighter represents the 'Master' that is chosen at the start of the game. There are 2 fighters currently, `RickFighter` and `MortyFighter` which conform to `GameFighter` protocol. The important function is `performPower()`, where the subclass can decide what logic to run to represent the special power of the fighter.

For example, in `MortyFighter` (whose special power is to make green pegs explode when colliding with a ball):
```swift
func performPower(pegNode: PegNode, ballNode: BallNode) {
	fighterDelegate?.createExplosionAt(pegNode: pegNode)
}
```
## Preloaded Levels
There are 3 preloaded levels. They are stored within `DefaultLevelOne`, `DefaultLevelTwo` and `DefaultLevelThree`, which conform to `PreloadedLevel` protocol. The `LoadLevel` class assists in converting the level data to the current device using `convertObject()`.

```swift
func convertObject(oldHeight: Double,
	       oldWidth: Double,
	       newHeight: Double,
	       newWidth: Double,
	       obj: BoardObjectWrapper) -> BoardObjectWrapper {
	let widthRatio = newWidth / oldWidth
	let heightRatio = newHeight / oldHeight
	let multiplier: Double = min(heightRatio, widthRatio)
	if let peg = obj.object as? Peg {
	    peg.radius *= multiplier
	    peg.position.x *= widthRatio
	    peg.position.y *= heightRatio
	} else if let block = obj.object as? Block {
	    block.width *= multiplier
	    block.height *= multiplier
	    block.position.x *= widthRatio
	    block.position.y *= heightRatio
	}
	return obj
}
```

This ensures that the levels are loaded with the same layout for any device.

## <a name='LevelDesigner'></a>Level Designer
On top of the Peggle Game, there is also the Level designer.

### <a name='Architecture'></a>Architecture
The overall application architecture is as follows:

![image](https://user-images.githubusercontent.com/61085398/215256438-a3d92cb8-d496-4465-b953-ab5c1d1e74b2.png)

The arrows above represent the control flow of the application.

The user interacts with the View component, which represents the UI of the application.

The View propagates these actions to a controller (controller depends on which view was interacted with). The controller will then either update the Model (e.g. adding a peg, deleting a peg) or interact with Storage (e.g. saving, loading).

When the Model is updated, it sends a Notification using `NotificationCenter`. In this application, the `LevelBuilderViewController` is a listener for certain notifications that are emitted by the Model. Upon receiving the notification, the controller then updates the View to reflect the latest state of the Model.

For Storage interactions, the controller either saves data/loads data to/from the Storage. In the case of saving, the Storage sends a Notification to the controller if the save is successful or if there was an error while saving. The controller then presents an alert to the user that their save was successful or there was an error while saving.

### <a name='ModelComponent'></a>Model Component
The Model is a standalone capability which represents the domain logic of the problem. 

#### <a name='ComponentStructure'></a>Component Structure
![image](https://user-images.githubusercontent.com/61085398/221410882-88c3ee8e-792d-4839-bd06-6e01cd272d9c.png)

The `Board` class stores a reference to the objects on it, stored in a set.

The `BoardObjectWrapper` class serves as a wrapper to `BoardObject`, since the Set cannot store protocol type objects & we cannot make `BoardObject` conform to Hashable. This allows the objects to be stored in a `Set`.

`BoardObject` represents objects on the board. It defines the functions shown above, for subclasses which conform to it to implement their custom implementation. `Peg` and `Block` conform to `BoardObject`. For example, `isOverlapping()` is implemented differently in `Peg` and `Block`.

The `Board` class sends a notification using `NotificationCenter` whenever the board is updated (adding, removing pegs and reset). In certain cases, e.g. add, remove pegs, the peg involved (e.g. the peg that was added or removed) in the update will be sent in the notification.

### <a name='ViewComponent'></a>View Component
The view component represents the UI seen by the user when the application is running. In the level designer, there are two main views, the level builder view and the level select view.

#### <a name='LevelBuilderView'></a>Level Builder View
The level builder view represents the UI that the user sees when they are at the level builder screen. The level builder view consists of `ToolsViewController`, which is the view controller for the tools (peg buttons, delete, resize, rotate) as well as the ControlsView which consits of the action buttons (Save, Load, Reset, Start) which are of `UIButton` class. The level builder view also consists of a board view, which is the view where `BoardObjectView` views (which are the objects on the board view) are shown and added as the user builds the level. These views were added using Interface Builder, and set to fit different iPad sizes by setting up Auto Layout constraints. Refer to the image below for the Interface Builder for this view:

![image](https://user-images.githubusercontent.com/61085398/221411204-ff90c457-b21e-443b-ae36-45baf68808db.png)

##### Board View & `BoardObjectView`
The Board View, is where `BoardObjectView` views get added as subviews of the Board View when the user builds/modifies the level. The Board View has an `UIImageView` as a subview which represents the background of the board being seen. Visually, the Board View represents the board that the user is editing.

`BoardObjectView` represents the object views that get added/removed/moved on the board view.

`BoardObjectView` has three gesture recognizers, tap, pan and long press. To get actions to occur based on these gestures, `BoardObjectView` uses a Delegate pattern, storing a reference to a delegate which conforms to the `BoardObjectViewDelegate` protocol. Refer to the class diagram below:

![image](https://user-images.githubusercontent.com/61085398/221411504-573b3495-a41d-4ba1-a7e7-da695f8ec150.png)

The gesture recognizer handlers run when the gestures are done by the user on a `BoardObjectView`. The screenshot below shows the gesture recognizer handlers in `BoardObjectView` class:

![image](https://user-images.githubusercontent.com/61085398/214992326-d86994ef-14da-409f-8448-ccb1701270c8.png)

`BoardObjectView` views are added to the Board View at runtime programatically, whenever the user loads a level or starts building the level. The `BoardObjectView` views are stored as subviews of the Board View.


#### <a name='LevelSelectView'></a>Level Select View
The level select view represents the UI seen by user when they want to select a level to load. The level select view consists of two `UIButton` views for creating a new level and deleting all the existing levels, as well as a `UITableView` which loads the levels stored on the device using `LevelTableViewCell` views. The `LevelTableViewCell` views are added programatically at runtime. Refer to the image below for the Interface Builder for this view:

![Screenshot 2023-01-27 at 10 04 04 AM](https://user-images.githubusercontent.com/61085398/214994708-82ad64d8-cdca-4c6f-ba7e-487e87d237cd.png)

The table view (default `UITableView`) in the Level Select View uses a Delegate pattern. The delegate which conforms to `UITableViewDelegate` handles the loading of cells and deletion of cells by swiping left. How the delegate implements these actions will be explained further in [the controller section of the developer guide](#controller-component). 

##### `LevelTableViewCell`
The `LevelTableViewCell` is a table cell view that conforms to `UITableViewCell` and has a label (where the level name is programatically set at runtime).

### <a name='ControllerComponent'></a>Controller Component
There are two controllers for the application, `LevelBuilderViewController` and `LevelSelectViewController`. The `LevelSelectViewController` controls the Level Select view, and the `LevelBuilderViewController` controls the Level Builder view. 

The `LevelSelectViewController` stores a reference to its delegate, the `LevelBuilderViewController`. The delegate is used by `LevelSelectViewController` when the user creates a new level or loads an existing level. The relationship between the two controllers can be seen in the following class diagram:

![image](https://user-images.githubusercontent.com/61085398/215009411-b632f0e3-f9e6-4deb-a961-228381ef9cfd.png)

#### <a name='LevelBuilderViewController'></a>`LevelBuilderViewController`
The `LevelBuilderViewController` controls the user interactions on the level builder UI and propagates the actions to the board model, as well as updates the level builder UI when the model changes.

##### ToolsViewController
The logic of what should happen when a tool is selected (e.g. reduce opacity of other tools and make selected tool opaque) is abstracted out into `ToolsViewController`:

![image](https://user-images.githubusercontent.com/61085398/221412393-700b7b63-620e-4fe6-a781-89a5a91abd1f.png)


It conforms to `LevelBuilderActionsDelegate`, which is defined as such:
```swift
protocol LevelBuilderActionsDelegate: AnyObject {
    func didTapBoardObject(_ object: BoardObjectWrapper)
    func didTapBoard(at location: CGPoint)
    func unselectAllTools()
}
```
This is because the action that gets run for each of these events is dependent on which tool is selected, which is managed by `ToolViewController`.

`ToolsViewController` stores a reference to `ToolsViewControllerDelegate` which allows it to add, remove, change size, select and unselect objects on the BoardView since `LevelBuilderViewController` conforms to `ToolsViewControllerDelegate`.

##### Protocols
As mentioned in previous sections, the `LevelBuilderViewController` serves as the delegate for `BoardPegView` views, `LevelSelectViewController` and `ToolsViewController`. As such, it conforms to `BoardPegViewDelegate`, `LevelSelectViewControllerDelegate` and `ToolsViewControllerDelegate` protocols.

##### Variables and Properties
`LevelBuilderViewController` stores variables that are essential to the control flow of the Level Builder view.

Controls:
```swift
    @IBOutlet var levelNameTextField: UITextField!
    @IBOutlet var boardView: UIView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var loadButton: UIButton!
    @IBOutlet var ballStepper: UIStepper!
    @IBOutlet var ballCountLabel: UILabel!
    @IBOutlet var gameModeSelect: UISegmentedControl!
    
    @IBOutlet var rotationLabel: UILabel!
    @IBOutlet var rotationSlider: UISlider!
```
These are used to modify the board or objects or carry out actions.

Helper properties:
```swift
// Helper variables & properties
var objectsToViews: [BoardObjectWrapper: BoardObjectView] = [:]
var viewsToObjects: [BoardObjectView: BoardObjectWrapper] = [:]
```

`objectToViewDict` is a dictionary storing `BoardObject` objects as the key and `BoardObjectView` views which represent the peg on the screen. 
`viewsToObjects` is the reverse lookup dictionary used for removing `BoardObjects` (e.g. when user taps a `BoardObjectView`).

##### UI Actions
The `LevelBuilderViewController` has `@IBAction` handler functions which handle taps on the action buttons (save, load, reset) and taps on the Board View as well as modifying objects.

##### Notification
As mentioned in the previous section, certain user actions cause the controller to interact with the model. The controller is a listener to the model, which communicates through `NotificationCenter`. This requires the controller to listen to notifications from the model, as set up in the controller's `viewDidLoad()`:

```swift
// Register for relevant notifications
NotificationCenter.default.addObserver(self, selector: #selector(addObjectToBoardView),
				       name: .objectAdded, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(deleteObjectFromBoardView),
				       name: .objectDeleted, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(moveObjectOnBoardView),
				       name: .objectMoved, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(clearBoardView),
				       name: .boardCleared, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(resizeObjectOnBoardView),
				       name: .objectResizeSuccess, object: nil)
```

When a notification is received from the model, e.g. a peg has been added to the model, the controller updates the Board View to reflect the changes in the model.

#### <a name='LevelSelectViewController'></a>`LevelSelectViewController`
The `LevelSelectViewController` controls the user interactions on the level select UI and uses its delegate, in this case `LevelBuilderViewController`, to carry out actions based on the user's input.

##### Protocols
The `LevelSelectViewController` serves as the delegate for the `UITableView` which displays the saved levels. As such, it conforms to [`UITableViewDelegate`](https://developer.apple.com/documentation/uikit/uitableviewdelegate) protocol. The controller also conforms to [`UITableViewDataSource`](https://developer.apple.com/documentation/uikit/uitableviewdatasource) since the data source for the table comes from the `boards` variable stored in the controller.

##### Variables and Properties
The controller only stores two variables which are required for the control flow of the level select view.

<img width="372" alt="Screenshot 2023-01-27 at 6 25 30 PM" src="https://user-images.githubusercontent.com/61085398/215064132-458a2473-14e0-4111-b3bf-b9a4e5a14729.png">

`boards`, which represent the all the boards that are stored and displayed in the `UITableView`.

`delegate`, which is of type `LevelSelectViewControllerDelegate` and is used by the controller for user interactions such as tapping on a saved level, or creating a new level.

##### UI Actions
The `LevelSelectViewController` has `@IBAction` handler functions which handle taps on the action buttons (delete all levels, create new level). The controller also has UI actions on the table such as swiping to delete a level as it conforms to `UITableViewDelegate`, and has the following function: 

![Screenshot 2023-01-28 at 1 30 38 PM](https://user-images.githubusercontent.com/61085398/215247911-588561c8-0920-4b18-bdac-c842f0432299.png)

The delete all levels and delete a single level cause data stored in Core Data to be modified. Afterwards, `reloadTableData()` is called to refresh the table with the latest saved data.

### <a name='StorageComponent'></a>Storage Component
The application data is saved to Core Data. In the `BoardModelData` file, there is a single entity being saved, `BoardData`, which has a single attribute, `boards`, which is of type `[Board]` (array of `Board`). However, in the Model Data file, it is shown as type `Transformable` (since `[Board]` is not a standard data type supported by Core Data):

![Screenshot 2023-01-28 at 1 36 30 PM](https://user-images.githubusercontent.com/61085398/215248111-8d7798f3-e3cc-4ff7-a5b1-9e2de3539f28.png)

#### <a name='BoardsTransformer'></a>`BoardsTransformer`
Since `[Board]` is not a standard data type, it must be transformed using a custom class transformer. `BoardsTransformer` is used by the Data Model to transform the data to be compatible with Core Data:

![Screenshot 2023-01-28 at 1 41 20 PM](https://user-images.githubusercontent.com/61085398/215248374-1d57d455-0b61-4056-abe1-743dd5c66712.png)

#### <a name='DataManager'></a>`DataManager`
The main component interacting with Core Data is the `DataManager`. It uses a singleton pattern, which is the `sharedInstance` in `DataManager` class. To use the functions in `DataManager` in other classes, the `sharedInstance` is used (e.g. `DataManager.sharedInstance.deleteAllBoards()`).

## <a name='Implementation'></a>Implementation
### <a name='SelectPegButton'></a>Select Peg Button
When user taps on any of the select peg buttons (orange, blue, delete), the `pegButtonTapped()` in `LevelBuilderViewController` is called. The `selectedButton` attribute is then changed to the tapped button through `selectButton()`.

When the `selectedButton` changes, the `didSet` observers run the necessary logic to keep the view updated (reducing opacity of non-selected buttons and setting the selected button opaque).

### <a name='AddPeg'></a>Add Peg

![image](https://user-images.githubusercontent.com/61085398/215251215-899c6bcb-6b7a-4d5d-84d9-012054bb5c13.png)

The user taps on the screen.

Board View propagates the action by calling `didTapView()` in `LevelBuilderViewController`.

`LevelBuilderViewController` checks whether `currentSelectedColour` is `nil`. If it is `nil`, nothing happens. If it is not `nil`, the `addPeg()` function is called. The `addPeg()` function calls `board?.addPeg()`.

In `Board`, checks are done to ensure that the newly added peg does not overlap any other exising pegs on the board or out of bounds. If the peg overlaps or is out of bounds, it is not added to the model. If it is a valid position, the peg is added to the model. The model then sends a `.pegAdded` notification to its listeners.

`LevelBuilderViewController` is a listener of `.pegAdded`. It receives the notification and calls `addPegToBoardView()` to add a new `BoardPegView` to the Board View.

The user then sees the new peg on the screen.

### <a name='DeletePeg'></a>Delete Peg
There are 2 methods to delete a peg from the screen, either selecting the delete peg button and tapping the board peg view or long pressing on the board peg view.

#### <a name='TappingBoardPegView'></a>Tapping `BoardPegView`

![image](https://user-images.githubusercontent.com/61085398/215251711-67e0389e-5d08-4533-9a29-76e4d8b376f1.png)

User taps on the `BoardPegView`.

`BoardPegView` calls `delegate?.userDidTap()` (`LevelBuilderViewController` is its delegate).

`LevelBuilderViewController` checks whether `selectedButton` is `deletePegButton` by calling `isDeletePegButton(selectedButton)`. If the current selected button is not the delete button, nothing happens. Else, the `deletePeg()` function is called. The `deletePeg()` function calls `board?.removePeg()`.

In `Board`, checks are done to ensure that the deleted peg exists. If the peg doesn't exist, nothing happens.. If it does exist, the peg is deleted from the model. The model then sends a `.pegDeleted` notification to its listeners.

`LevelBuilderViewController` is a listener of `.pegDeleted`. It receives the notification and calls `deletePegFromBoardView()` to remove the `BoardPegView` to the Board View.

The user then sees the peg removed from the board.

#### <a name='LongpressingBoardPegView'></a>Long pressing `BoardPegView`
The process for deletion is similar to tapping.

![image](https://user-images.githubusercontent.com/61085398/215252630-0a973ea6-3a86-478b-a433-4bfe5cddc9d8.png)

`BoardPegView` calls `delegate?.userDidLongPress()` (`LevelBuilderViewController` is its delegate).

Here, `LevelBuilderViewController` does no checks and calls `deletePeg()`. 

After this, the process is the same as outlined in the previous section (tapping `BoardPegView`).

### <a name='MovePeg'></a>Move Peg
The process for moving is quite similar to deleting a peg.

![image](https://user-images.githubusercontent.com/61085398/215252934-1857e95c-bbda-4127-87ab-9cda91a1f368.png)

`BoardPegView` calls `delegate?.userDidPan()` (`LevelBuilderViewController` is its delegate).

`LevelBuilderViewController` calls `movePeg()`. The `movePeg()` function calls `board?.movePeg()`.

In `Board`, checks are done to ensure that the new position of the peg does not cause it to overlap with another peg or make it go out of bounds. If the new position causes the peg to overlap another or be out of bounds, the peg is not moved. Else, model sends a `.pegMoved` notification to its listeners.

`LevelBuilderViewController` is a listener of `.pegMoved`. It receives the notification and calls `movePegOnBoardView()` which sets the new position to the `BoardPegView` that was panned.

The user then sees the peg move on the board.

### <a name='ResetBoard'></a>Reset Board

![image](https://user-images.githubusercontent.com/61085398/215254437-c42e9a9e-ab16-4ac3-9fd2-06bd25599af6.png)

The user taps the reset button.

Board View propagates the action by calling `resetButtonTapped()` in `LevelBuilderViewController`.

`LevelBuilderViewController` calls `resetBoard()`. The `resetBoard()` function calls `board?.removeAllPegs()`

In `Board`, the `pegs` attribute is set to a new `Set()`. `Board` sends its listeners the `.boardCleared` notification.

`LevelBuilderViewController` is a listener of `.boardCleared`. It receives the notification and calls `clearBoardView()` to remove all the existing `BoardPegView` views on the Board View.

The user then sees that the board has been cleared.

### <a name='SaveBoard'></a>Save Board

![image](https://user-images.githubusercontent.com/61085398/215256762-141cce50-e359-438d-bcac-7bf2c723234a.png)

User taps the save button.

Board View propagates the action by calling `saveButtonTapped()` in `LevelBuilderViewController`.

`LevelBuilderViewController` checks that the text field is not empty. 

If it is empty, `LevelBuilderViewController` presents an alert to the user that the level name must not be empty.

Else, `LevelBuilderViewController` calls `DataManager.sharedInstance.saveBoard()`. 

`DataManager` tries to save the board. If there is already a level saved with the same name, `DataManager`overwrites the level. In either case (success or error), `DataManeger` sends a `.dataSaved` or `dataSaveError` Notification to the `LevelBuilderViewController`.

`LevelBuilderViewController` is a listener of `.dataSaved` and `dataSaveError`. Upon receiving the Notification, `LevelBuilderViewController` either calls `notifyUserSaved()` or `notifyUserSaveError()`, which presents an alert to the user informing of the success or error.

### <a name='Viewsavedlevels'></a>View saved levels

![image](https://user-images.githubusercontent.com/61085398/215257277-e8d7a75c-4052-4125-bbc7-65782f00853e.png)

First, the user taps the load button. `loadButtonTapped()` method of `LevelBuilderViewController` is called. `LevelBuilderViewController` creates a new instance of `LevelSelectViewController` and `present()` the newly created view.

The user sees the saved levels.

### <a name='Loadsavedlevel'></a>Load saved level
![image](https://user-images.githubusercontent.com/61085398/215257655-e792033e-e611-4fcf-80dc-dd9314e0de59.png)

User taps on one of saved levels in the table. This calls `tableView()` in `LevelSelectViewController` which runs when user taps on a cell in the table view.

`LevelSelectViewController` calls `delegate?.loadBoard()`. In the application, `LevelBuilderViewController` is the delegate for `LevelSelectViewController`. `LevelBuilderViewController` then loads the selected board into its `board` variable. The `didSet` obsever runs, calling `removeAllBoardPegsFromBoardView()`, `loadPegsFromModelOnBoard()` and `setTextFieldText()`.

`LevelSelectViewController` then dismisses the level select view.

User sees the loaded board with the `BoardPegView` views on the board view and the name of the saved level in the text field.



