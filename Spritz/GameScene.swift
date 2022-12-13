//
//  GameScene.swift
//  Spritz
//
//  Created by Viacheslav on 07/12/22.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ball = SKSpriteNode(imageNamed: "ball")
    
    let stadioBackground = SKSpriteNode(imageNamed: "bg")
    
    //set a texture for GK anoimation
    var goalkeeper = SKSpriteNode()
    var gkMoves: [SKTexture] = []
    
    let arrow = SKSpriteNode(imageNamed: "arrow")
    
    var scoreLabel: SKLabelNode!
    
    var scorePlayer: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(scorePlayer)"
        }
    }
    
    // create an enum with different GK states depending on case
//    enum GkState: Int, CaseIterable {
//        case ready = 0 // before shot and the next cases random after shot
//        case center = 1
//        case left = 2
//        case right = 3
//    }
    
//    var gkAnimation = GkState(rawValue: 1) // a variable which defines basic GK state
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .green
        
        //settings for background pic placement -- put it in the center (notice that ancor of Stadion is in a screen center, but Ancor for Sprite in bottom left angle)
        stadioBackground.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        stadioBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //settings for ball pic placement -- on the penalty point -- relationship to Stadio
        ball.position = CGPoint(x: 0, y:  frame.size.height * -0.2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.isDynamic = true
        ball.name = "ball"
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        scoreLabel = SKLabelNode(fontNamed: "PixeloidSans")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 30
        scoreLabel.zPosition = 1
        scoreLabel.fontColor = .black
        scoreLabel.horizontalAlignmentMode = .center
//        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position.y = frame.size.height * 0.35
        
        //settings for arrow pic placement -- on a line -- relationship to Stadio
        arrow.anchorPoint = CGPoint(x: 0.5, y: 1)
        arrow.position = CGPoint(x: -0.5 * frame.size.width + arrow.size.width, y: frame.size.height * -0.04)
        
        //creating objects on a screen
        addChild(stadioBackground)
        stadioBackground.addChild(ball)
        stadioBackground.addChild(arrow)
        stadioBackground.addChild(scoreLabel)
        buildGkReady()
        
        //need to understand which case for GK animation use
//        switch GkState(rawValue: gkAnimation?.rawValue ?? 0) {
//
//        case .ready:
//            buildGkReady()
//        case .right:
//            buildGkRight()
//        case .center:
//            buildGkCenter()
//        case .left:
//            buildGkLeft()
//        case .none:
//            buildGkReady()
//        }
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
    }
    
    func CollisionBetween(ball: SKNode, goalkeeper: SKNode) {
        ball.removeFromParent()
        goalkeeper.removeFromParent()
        stadioBackground.addChild(ball)
        print("Collision")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" && nodeB.name == "goalkeeper"{
            CollisionBetween(ball: contact.bodyA.node!, goalkeeper: contact.bodyB.node!)
        } else if nodeA.name == "goalkeeper" && nodeB.name == "ball"{
            CollisionBetween(ball: contact.bodyB.node!, goalkeeper: contact.bodyA.node!)
        }
    }
    
    func animateGk() {
        goalkeeper.run(SKAction.repeatForever(
            SKAction.animate(with: gkMoves,
                             timePerFrame: 0.3,
                             resize: false,
                             restore: true)),
                       withKey: "gkReady")
    }
    // func with help to choose an animation for different GK states
//    func animateGk(status: GkState) {
//
//        switch status {
//
//        case .ready:
//            goalkeeper.run(SKAction.repeatForever(
//                SKAction.animate(with: gkMoves,
//                                 timePerFrame: 0.3,
//                                 resize: false,
//                                 restore: true)),
//                           withKey: "gkReady")
//
//        case .center:
//            goalkeeper.run(SKAction.repeatForever(
//                SKAction.animate(with: gkMoves,
//                                 timePerFrame: 0.3,
//                                 resize: false,
//                                 restore: true)),
//                           withKey: "gkCenter")
//
//        case .left:
//            goalkeeper.run(SKAction.repeatForever(
//                SKAction.animate(with: gkMoves,
//                                 timePerFrame: 0.3,
//                                 resize: false,
//                                 restore: true)),
//                           withKey: "gkLeft")
//
//        case .right:
//            goalkeeper.run(SKAction.repeatForever(
//                SKAction.animate(with: gkMoves,
//                                 timePerFrame: 0.3,
//                                 resize: false,
//                                 restore: true)),
//                           withKey: "gkRight")
//        }
//    }
    
    // for building a GK in different states
    func buildGkReady() {
        let gkAnimatedAtlas = SKTextureAtlas(named: "GkImages")
        var gkFrames: [SKTexture] = []
        
        gkFrames.append(gkAnimatedAtlas.textureNamed("gk-0"))
        gkFrames.append(gkAnimatedAtlas.textureNamed("gk-1"))
        
        gkMoves = gkFrames
        
        goalkeeper = SKSpriteNode(texture: gkFrames[0])
        
        //settings for GK pic placement -- in the middle of gates -- relationship to Stadio
        goalkeeper.position = CGPoint(x: 0, y:  frame.size.height * 0.08)
        goalkeeper.anchorPoint = CGPoint(x: 0.5, y: 0)
        goalkeeper.size = CGSize(width: 100, height: 120)
        goalkeeper.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 5))
        goalkeeper.physicsBody?.isDynamic = false
        goalkeeper.name = "goalkeeper"
        
        stadioBackground.addChild(goalkeeper)
    }
    
    
//    func buildGkRight() {
//        let gkAnimatedAtlas = SKTextureAtlas(named: "GkImagesJumpRight")
//        var gkFrames: [SKTexture] = []
//
//        gkFrames.append(gkAnimatedAtlas.textureNamed("GK_right-1"))
//        gkFrames.append(gkAnimatedAtlas.textureNamed("GK_right-2"))
//        gkFrames.append(gkAnimatedAtlas.textureNamed("GK_right-3"))
//
//        gkMoves = gkFrames
//
//        goalkeeper = SKSpriteNode(texture: gkFrames[0])
//
//        //settings for GK pic placement -- in the middle of gates -- relationship to Stadio
//        goalkeeper.position = CGPoint(x: 0, y:  frame.size.height * 0.15)
//        goalkeeper.size = CGSize(width: 100, height: 150)
//
//        stadioBackground.addChild(goalkeeper)
//    }
//    func buildGkLeft() {
//        let gkAnimatedAtlas = SKTextureAtlas(named: "GkImagesJumpLeft")
//        var gkFrames: [SKTexture] = []
//
//        gkFrames.append(gkAnimatedAtlas.textureNamed("GK_left-1"))
//        gkFrames.append(gkAnimatedAtlas.textureNamed("GK_left-2"))
//        gkFrames.append(gkAnimatedAtlas.textureNamed("GK_left-3"))
//
//        gkMoves = gkFrames
//
//        goalkeeper = SKSpriteNode(texture: gkFrames[0])
//
//        //settings for GK pic placement -- in the middle of gates -- relationship to Stadio
//        goalkeeper.position = CGPoint(x: 0, y:  frame.size.height * 0.15)
//        goalkeeper.size = CGSize(width: 80, height: 100)
//
//        stadioBackground.addChild(goalkeeper)
//    }
//    func buildGkCenter() {
//        let gkAnimatedAtlas = SKTextureAtlas(named: "GkImagesJumpCenter")
//        var gkFrames: [SKTexture] = []
//
//        gkFrames.append(gkAnimatedAtlas.textureNamed("GK_center"))
//        gkFrames.append(gkAnimatedAtlas.textureNamed("GK_center-jump"))
//
//        gkMoves = gkFrames
//
//        goalkeeper = SKSpriteNode(texture: gkFrames[0])
//
//        //settings for GK pic placement -- in the middle of gates -- relationship to Stadio
//        goalkeeper.position = CGPoint(x: 0, y:  frame.size.height * 0.08)
//        goalkeeper.anchorPoint = CGPoint(x: 0.5, y: 0)
//        goalkeeper.size = CGSize(width: 100, height: 150)
//
//        stadioBackground.addChild(goalkeeper)
//    }
    
    func GoalOrNot(location: CGPoint) {
        if ((location.x < frame.size.width * -0.2 && location.y == frame.size.height * 0.2) || (location.x > frame.size.width * 0.2 && location.y == frame.size.height * 0.2)) {
            scorePlayer -= 1
        } else {
            scorePlayer += 1
        }
    }
    
    //function for touching
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveArrow() // func for an arrow moving
        animateGk() // start animation for GK ready
        print("start")
    }
    
    // after touching ended following a shot
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = CGPoint(x: arrow.position.x, y: frame.size.height * 0.2)
        
        //this two lines for defining random direction to jump for GK
//        let randomState = Int.random(in: 1...3)
//        gkAnimation = GkState(rawValue: randomState)!
        
        moveBall(location: location)
        stopArrowAndGk()
        GoalOrNot(location: ball.position)
        print("shot")
    }
    
    //function to move ball in the direction of an arrow
    func moveBall(location: CGPoint) {
        
        let ballSpeed = frame.size.height // here should be an argument to make it faster than stronger kick
        let moveDistance = frame.size.height // here should be Y coordinate after which ball will stop
        let moveDuration = moveDistance / ballSpeed // time of a ball movement for the next argument
        
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration))) // ball moving behaviour, rotation infinite, i need to stop after ball reach the last point
        let rotateActionRight = SKAction.rotate(byAngle: 360, duration:(TimeInterval(moveDuration))) // func which rotate the ball
        let rotateActionLeft = SKAction.rotate(byAngle: -360, duration:(TimeInterval(moveDuration)))
        
        let scaleBall = SKAction.scale(by: 0.9, duration: (TimeInterval(moveDuration))) // to make it smaller after shot
        
        ball.run(moveAction) // I need to place ball back on a penalty point after all
        ball.run(scaleBall) // I need later to make it a dot if missed
        
        // to rotate ball in the direction of the shot
        if location.x < 0 {
            ball.run(rotateActionLeft)
        } else {
            ball.run(rotateActionRight)
        }
        
    }
    
    //function to move arrow back and foroth to choose direction for a shot
    func moveArrow() {
        
        let arrowSpeed = frame.size.width // here should be an argument to make it faster with each new level
        
        let moveDuration = frame.size.width / arrowSpeed //duration
        
        let moveRight = SKAction.moveTo(x: 0.45 * frame.size.width, duration: moveDuration) // move arrow to the rigth
        let moveLeft = SKAction.moveTo(x: -0.45 * frame.size.width, duration: moveDuration) // to the left
        let moveBackAndForth = SKAction.sequence([moveRight, moveLeft]) // making sequence
        
        let moveAction = SKAction.repeatForever(moveBackAndForth) // make it permanent
        arrow.run(moveAction, withKey: "arrow-moving")
    }
    
    //to stop an animation after touching ended
    func stopArrowAndGk() {
        arrow.removeAction(forKey: "arrow-moving")
        goalkeeper.removeAction(forKey: "gkReady")
    }
    
    //to reset screen after shot completed (DIDN'T USE NOW)
    func reset() {
        arrow.position = CGPoint(x: -0.5 * frame.size.width + arrow.size.width, y: frame.size.height * -0.04)
        ball.position = CGPoint(x: 0, y:  frame.size.height * -0.2)
        goalkeeper.position = CGPoint(x: 0, y:  frame.size.height * 0.15)
    }
    
}
