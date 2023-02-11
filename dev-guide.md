# Overall Structure
There are two main flows. 

## User Interactions
First, the handling of user interactions:

![image](https://user-images.githubusercontent.com/61085398/218270661-724caebf-1bc6-45c8-ae6c-bdac86edb946.png)

The user interacts with the Board View (e.g. tapping the board to shoot the ball).

The event is propagated to the Board Scene. The Board Scene updates its internal state, and synchronises the state with the view so that the user sees the most updated state of the scene visually represented.

## Game Loop
The second flow would be continuous update of the scene based on the game loop. The flow is illustrated below:

![image](https://user-images.githubusercontent.com/61085398/218270725-5b3e2076-3723-4f5d-b809-e87e096dec32.png)

The game loop calls the `refresh()` function on the Board View. The BoardView then gets the scene to update, and then once the state of the scene is updated, the state changes are propagated back to the Board View, which will update itself to visually represent the latest state of the scene.

# MySpriteKit
MySpriteKit (MSK) is a lightweight framework inspired by Apple's SpriteKit framework for simulating physics worlds and rendering. It consists of two main components, the Physics Engine, and the Scene Renderers.

## MSKPhysicsEngine
The Physics Engine is a standalone capability which is able to simulate physics worlds and handle the interactions between the bodies between the worlds. Below is a class diagram to illustrate the relationship between the classes in MSKPhysicsEngine.

![image](https://user-images.githubusercontent.com/61085398/218266704-a2d57c18-11e6-45b4-904a-45273741290b.png)

The Physics Engine uses [Verlet Integration](https://www.algorithm-archive.org/contents/verlet_integration/verlet_integration.html) for the simulations & calculations.

### MSKPhysicsWorld
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

### MSKPhysicsBody
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

### MSKCirclePhysicsBody & MSKPolygonPhysicsBody
These are classes implementing the `MSKPhysicsBody` protocol.

`MSKCirclePhysicsBody` has a radius.

`MSKPolygonPhysicsBody` stores the vertices relative to the `position` of the physics body, to determine the shape of the body. The vertices should be in order, either clockwise or anticlockwise.

As mentioned above, collisions are handled using double dispatch method.

### MSKPhysicsBodyDelegate
This is a protocol implemented by classes which use `MSKPhysicsBody`. There are two methods, `didUpdatePosition()` and `didUpdateAngle()`, which are called whenever the physics body has updated its position or angle respectively.

Classes implementing `MSKPhysicsBody` has a reference to an `Optional<MSKPhysicsBodyDelegate>`.

## MSKSceneRenderers
The Scene Renderers are used for managing the state of the scene and to render the scene onto a view. The class diagram below illustrates how the components interact:

![image](https://user-images.githubusercontent.com/61085398/218269781-21c0ccbf-4406-4712-8159-17a74b48ee79.png)

### MSKScene
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

### MSKNode & MSKSpriteNode
Represents the nodes within the scene. Each node stores a reference to its physics body, and it is a `MSKPhysicsBodyDelegate`.

Upon changes in the physics body, `didUpdatePosition()` or `didUpdateAngle()` are called by the physics body, which updates the position/rotation of the node.

### MSKView
View which renders `MSKScene`. It stores a reference to the scene that it is presenting, and also serves as `MSKSceneDelegate` for the `MSKScene` object.

The important function is `refresh()`, which refreshes the view, allowing user to visually see the updates in the state of the scene.
```swift
/// Refreshes the state of the scene to the current time.
    func refresh(timeInterval: TimeInterval) {
        scene?.update(timeInterval: timeInterval)
    }
```

The `refresh()` function calls `scene?.update()`. Upon changes in the scene, the delegate functions (`didRemoveNode()`, `didAddNode()`, `didUpdateNode()`, `didRotateNode()`), are called, causing the view to update itself to stay synced with the scene.
