- [Overall Structure](#overall-structure)
  - [User Interactions](#user-interactions)
  - [Game Loop](#game-loop)
- [MySpriteKit](#myspritekit)
  - [MSKPhysicsEngine](#mskphysicsengine)
    - [MSKPhysicsWorld](#mskphysicsworld)
    - [MSKPhysicsBody](#mskphysicsbody)
    - [MSKCirclePhysicsBody \& MSKPolygonPhysicsBody](#mskcirclephysicsbody--mskpolygonphysicsbody)
    - [MSKPhysicsBodyDelegate](#mskphysicsbodydelegate)
  - [MSKSceneRenderers](#mskscenerenderers)
    - [MSKScene](#mskscene)
    - [MSKNode \& MSKSpriteNode](#msknode--mskspritenode)
    - [MSKView](#mskview)
- [Game Engine](#game-engine)
  - [BoardScene](#boardscene)
  - [Nodes](#nodes)
    - [PegNode, BluePegNode, OrangePegNode](#pegnode-bluepegnode-orangepegnode)
    - [BallNode](#ballnode)
    - [CannonNode](#cannonnode)
  - [Physics](#physics)
    - [BallPhysicsBody](#ballphysicsbody)
    - [PegPhysicsBody](#pegphysicsbody)
# Overall Structure
There are two main flows. 

## <a name='UserInteractions'></a>User Interactions
First, the handling of user interactions:

![image](https://user-images.githubusercontent.com/61085398/218270661-724caebf-1bc6-45c8-ae6c-bdac86edb946.png)

The user interacts with the Board View (e.g. tapping the board to shoot the ball).

The event is propagated to the Board Scene. The Board Scene updates its internal state, and synchronises the state with the view so that the user sees the most updated state of the scene visually represented.

## <a name='GameLoop'></a>Game Loop
The second flow would be continuous update of the scene based on the game loop. The flow is illustrated below:

![image](https://user-images.githubusercontent.com/61085398/218270725-5b3e2076-3723-4f5d-b809-e87e096dec32.png)

The game loop (implemented using `CADisplayLink`) is contained within the `GameViewController`. The game loop calls the `step()` function, whch calls the `refresh()` function of the Board View. The BoardView then gets the scene to update, and then once the state of the scene is updated, the state changes are propagated back to the Board View, which will update itself to visually represent the latest state of the scene. The flow is shown below:



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

There are two important functions, `fireCannon()` and `removeHitPegs()`.

`fireCannon(at tapLocation: CGPoint)` shoots the cannon by creating a `BallNode`. The `tapLocation` is used to calculate the angle to fire the ball, as well as to rotate the cannon. If `isCannonFired` is false, nothing happens.

`removeHitPegs()` removes the pegs that were hit by the ball when the ball goes out of the scene (falls out the bottom).

## <a name='Nodes'></a>Nodes
There are a number of different node classes, which represent the pegs, the ball and the cannon.

### <a name='PegNodeBluePegNodeOrangePegNode'></a>PegNode, BluePegNode, OrangePegNode
Represents the pegs in the scene. It contains a `isHit` property to indicate whether the ball has hit the peg. It also stores a reference to a `PegNodeDelegate`.

It conforms to the `PegPhysicsBodyDelegate` protocol, so it has `didCollideWithBall()` function.

```swift
func didCollideWithBall() {
    isHit = true
    delegate?.didCollideWithBall(pegNode: self)
}
```
There are 2 subclasses, `BluePegNode` and `OrangePegNode`. These classes override the `didCollideWithBall()` function to implement custom logic upon colliding with the ball (changing the image to be the glowing variant). For example:

```swift
override func didCollideWithBall() {
        image = UIImage(named: "peg-blue-glow")
        super.didCollideWithBall()
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
### <a name='CannonNode'></a>CannonNode
 It represents the cannon. The notable thing is that its physics body has a `categoryBitMask` of 0 (i.e. 0x00000000) so it does not collide with anything.


## Physics
The physics bodies implemented for this game use `MSKPhysicsEngine`. 

### BallPhysicsBody
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

### PegPhysicsBody
This class subclasses `MSKCirclePhysicsBody`, and stores a reference to a `PegPhysicsBodyDelegate`. This class is implemented so that we can implement custom Peg physics body collision logic with a ball physics body. If the peg did collide with a ball physics body, we can call `pegPhysicsBodyDelegate?.didCollideWithBall()`.

```swift
func collide(with body: BallPhysicsBody) -> Bool {
    if super.collide(with: body) {
        pegPhysicsBodyDelegate?.didCollideWithBall()
        return true
    } else {
        return false
    }
}
```


