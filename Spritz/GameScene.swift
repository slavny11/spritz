//
//  GameScene.swift
//  Spritz
//
//  Created by Viacheslav on 07/12/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ball = SKSpriteNode(imageNamed: "ball")
    
    let stadioBackground = SKSpriteNode(imageNamed: "bg")
    
    //set a texture for GK anoimation
    private let goalkeeper: SKSpriteNode
    private let goalkeeperStateMachine: GKStateMachine
    
    private let gates: SKSpriteNode
    private let missedLeft: SKSpriteNode
    private let missedRight: SKSpriteNode
    
    let arrow = SKSpriteNode(imageNamed: "arrow")
    
    // scorelabel for a player and a comp
    var scoreLabel: SKLabelNode!
    var scorePlayer: Int = 0 {
        didSet {
            scoreLabel.text = "You \(scorePlayer) : \(scoreGoalkeeper) GK"
        }
    }
    var scoreGoalkeeper: Int = 0 {
        didSet {
            scoreLabel.text = "You \(scorePlayer) : \(scoreGoalkeeper) GK"
        }
    }
    
    //initializations of GK states and Nodes
    override init(size: CGSize) {
        goalkeeper = SKSpriteNode(imageNamed: "gk")
        goalkeeper.name = "goalkeeper"
        goalkeeperStateMachine = GKStateMachine(states: [
            GoalkeeperReady(goalkeeperNode: goalkeeper),
            GoalkeeperJumpCenter(goalkeeperNode: goalkeeper),
            GoalkeeperJumpLeft(goalkeeperNode: goalkeeper),
            GoalkeeperJumpRight(goalkeeperNode: goalkeeper)
        ])
        
//        let halfGaitWidth = size.width * 0.5
//        let gatesSize = CGSize(width: halfGaitWidth, height: 1)
        gates = SKSpriteNode(color: .red, size: CGSize(width: size.width * 0.5, height: 1))
        missedLeft = SKSpriteNode(color: .black, size: CGSize(width: size.width * 0.2, height: 1))
        missedRight = SKSpriteNode(color: .blue, size: CGSize(width: size.width * 0.2, height: 1))
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum roundStages {
        case shot
        case goal
        case missed
    }
    
    var gameStatus: roundStages = .shot
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .green
        
        gates.name = "Gates"
        gates.position = CGPoint(x: size.width * 0.5, y: 510)
        gates.physicsBody = SKPhysicsBody(rectangleOf: gates.size)
        gates.physicsBody?.isDynamic = false
        gates.physicsBody!.contactTestBitMask = gates.physicsBody!.collisionBitMask
        gates.physicsBody?.usesPreciseCollisionDetection = true
        
        missedLeft.name = "MissedLeft"
        missedLeft.position = CGPoint(x: 0, y: 550)
        missedLeft.anchorPoint = CGPoint(x: 0, y: 0)
        missedLeft.physicsBody = SKPhysicsBody(rectangleOf: missedLeft.size)
        missedLeft.physicsBody?.isDynamic = false
        missedLeft.physicsBody!.contactTestBitMask = missedLeft.physicsBody!.collisionBitMask
        missedLeft.physicsBody?.usesPreciseCollisionDetection = true
        
        missedRight.name = "MissedRight"
        missedRight.position = CGPoint(x: size.width - missedRight.size.width, y: 550)
        missedRight.anchorPoint = CGPoint(x: 0, y: 0)
        missedRight.physicsBody = SKPhysicsBody(rectangleOf: missedRight.size)
        missedRight.physicsBody?.isDynamic = false
        missedRight.physicsBody!.contactTestBitMask = missedRight.physicsBody!.collisionBitMask
        missedRight.physicsBody?.usesPreciseCollisionDetection = true
        
        //settings for background pic placement -- put it in the center (notice that ancor of Stadion is in a screen center, but Ancor for Sprite in bottom left angle)
        stadioBackground.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        stadioBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        stadioBackground.zPosition = -1
        
        //settings for ball pic placement -- on the penalty point -- relationship to Stadio
        ball.position = CGPoint(x: 0, y:  frame.size.height * -0.2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.isDynamic = true
        ball.name = "ball"
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        scoreLabel = SKLabelNode(fontNamed: "PixeloidSans")
        scoreLabel.text = "You 0 : 0 GK"
        scoreLabel.fontSize = 30
        scoreLabel.zPosition = 1
        scoreLabel.fontColor = .black
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position.y = frame.size.height * 0.35
        
        //settings for arrow pic placement -- on a line -- relationship to Stadio
        arrow.anchorPoint = CGPoint(x: 0.5, y: 1)
        arrow.position = CGPoint(x: -0.5 * frame.size.width + arrow.size.width, y: frame.size.height * -0.04)
        
        //creating objects on a screen
        addChild(stadioBackground)
        stadioBackground.addChild(ball)
        stadioBackground.addChild(arrow)
        stadioBackground.addChild(scoreLabel)
        addChild(gates)
        addChild(missedLeft)
        addChild(missedRight)
        addChild(goalkeeper)
        
        //adding GK first state
        goalkeeperStateMachine.enter(GoalkeeperReady.self) // start animation for GK ready
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
    }
    
    //what should happen in case of GK catch the ball
    func CollisionBetweenSave(ball: SKNode, goalkeeper: SKNode) {
        ball.removeFromParent()
        goalkeeper.removeFromParent()
        print("Save")
        scoreGoalkeeper += 1
        gameStatus = .missed
    }
    
    func CollisionBetweenGoal(ball: SKNode, gates: SKNode) {
        ball.removeFromParent()
        missedLeft.removeFromParent()
        missedRight.removeFromParent()
        print("Goal")
        scorePlayer += 1
        gameStatus = .goal
    }
    
    func CollisionBetweenMissed(ball: SKNode, miss: SKNode) {
        missedLeft.removeFromParent()
        missedRight.removeFromParent()
        print("Missed")
        scoreGoalkeeper += 1
        gameStatus = .missed
    }
    
//    //func to understand whether is goal or not NEED TO DO
//    func Missed() {
//        if ((ball.position.x < -100 && ball.position.y == frame.size.height * 0.2) || (ball.position.x > frame.size.width * 0.2 && ball.position.y == frame.size.height * 0.2)) {
//            scoreGoalkeeper += 1
//            gameStatus = .missed
//        }
//    }
    
    //collision detection
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" && nodeB.name == "goalkeeper"{
            CollisionBetweenSave(ball: contact.bodyA.node!, goalkeeper: contact.bodyB.node!)
        } else if nodeA.name == "goalkeeper" && nodeB.name == "ball"{
            CollisionBetweenSave(ball: contact.bodyB.node!, goalkeeper: contact.bodyA.node!)
        } else if nodeA.name == "Gates" && nodeB.name == "ball"{
            CollisionBetweenGoal(ball: contact.bodyA.node!, gates: contact.bodyB.node!)
        } else if nodeA.name == "ball" && nodeB.name == "Gates"{
            CollisionBetweenGoal(ball: contact.bodyB.node!, gates: contact.bodyA.node!)
        } else if (nodeA.name == "MissedLeft" || nodeA.name == "MissedRight") && nodeB.name == "ball"{
            CollisionBetweenMissed(ball: contact.bodyB.node!, miss: contact.bodyA.node!)
        } else if (nodeB.name == "MissedLeft" || nodeB.name == "MissedRight") && nodeA.name == "ball"{
            CollisionBetweenMissed(ball: contact.bodyA.node!, miss: contact.bodyB.node!)
        }
    }

    
    //function for touching
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch gameStatus {
        case .shot:
            moveArrow() // func for an arrow moving
            print("start")
        case .goal:
            print("goal")
            gameStatus = .shot
        case .missed:
            print("missed")
            gameStatus = .shot
        }
        
    }
    
    // after touching ended following a shot
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let randomSide = Int.random(in: 0...2)
        let location = CGPoint(x: arrow.position.x, y: frame.size.height * 0.2)
        
        if randomSide == 0 {
            goalkeeperStateMachine.enter(GoalkeeperJumpCenter.self) // start animation for GK center
        } else if randomSide == 1 {
            goalkeeperStateMachine.enter(GoalkeeperJumpRight.self) // start animation for GK center
        } else if randomSide == 2 {
            goalkeeperStateMachine.enter(GoalkeeperJumpLeft.self) // start animation for GK center
        }

        self.moveBall(location: location)
        stopArrowAndGk()
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
    }
    
    //to reset screen after shot completed (DIDN'T USE NOW)
    func reset() {
        arrow.position = CGPoint(x: -0.5 * frame.size.width + arrow.size.width, y: frame.size.height * -0.04)
        ball.position = CGPoint(x: 0, y:  frame.size.height * -0.2)
    }
    
}
