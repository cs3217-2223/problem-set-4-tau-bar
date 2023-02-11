# MySpriteKit
MySpriteKit (MSK) is a lightweight framework for simulating physics worlds and rendering. It consists of two main components, the Physics Engine, and the Scene Renderers.

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

