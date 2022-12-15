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
    
    //all screens
    let stadioBackground = SKSpriteNode(imageNamed: "bg")
    let missedScreen = SKSpriteNode(imageNamed: "missed")
    let goalScreen = SKSpriteNode(imageNamed: "goal")
    let saveScreen = SKSpriteNode(imageNamed: "save")
    let winScreen = SKSpriteNode(imageNamed: "win")
    let loseScreen = SKSpriteNode(imageNamed: "lose")
    
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
        
        gates = SKSpriteNode(color: .clear, size: CGSize(width: size.width * 0.5, height: 1))
        missedLeft = SKSpriteNode(color: .clear, size: CGSize(width: size.width * 0.25, height: 1))
        missedRight = SKSpriteNode(color: .clear, size: CGSize(width: size.width * 0.25, height: 1))
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // game status
    enum roundStages {
        case shot
        case goal
        case save
        case missed
    }
    
    var gameStatus: roundStages = .shot {
        didSet {
            switch gameStatus {
            case .shot:
                print("start")
                if scorePlayer == 5 {
                    addChild(winScreen)
                } else if scoreGoalkeeper == 5 {
                    addChild(loseScreen)
                } else {
                    missedScreen.removeFromParent()
                    goalScreen.removeFromParent()
                    saveScreen.removeFromParent()
                    addBall()
                    addArrow()
                    addChild(goalkeeper)
                }
                
            case .goal:
                print("goal")
                scorePlayer += 1
                addChild(goalScreen)
                
            case .save:
                print("save")
                scoreGoalkeeper += 1
                addChild(saveScreen)
                
            case .missed:
                print("missed")
                scoreGoalkeeper += 1
                addChild(missedScreen)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .green
        
        //all possible fdirections fo ball for collision detection
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
        
        //result screens for shot
        missedScreen.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        missedScreen.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        missedScreen.zPosition = 5
        
        saveScreen.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        saveScreen.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        saveScreen.zPosition = 5
        
        goalScreen.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        goalScreen.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        goalScreen.zPosition = 5
        
        winScreen.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        winScreen.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        winScreen.zPosition = 5
        
        loseScreen.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        loseScreen.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loseScreen.zPosition = 5
        
        // score label
        scoreLabel = SKLabelNode(fontNamed: "PixeloidSans")
        scoreLabel.text = "You 0 : 0 GK"
        scoreLabel.fontSize = 30
        scoreLabel.zPosition = 1
        scoreLabel.fontColor = .black
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position.y = frame.size.height * 0.35
        
        //creating objects on a screen
        addChild(stadioBackground)
        addBall()
        addArrow()
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
        reset()
        print("Save")
//        scoreGoalkeeper += 1
        gameStatus = .save
    }
 
    //what should happen in case of a goal
    func CollisionBetweenGoal(ball: SKNode, gates: SKNode) {
        reset()
        print("Goal")
//        scorePlayer += 1
        gameStatus = .goal
    }
    //what should happen in case of a miss
    func CollisionBetweenMissed(ball: SKNode, miss: SKNode) {
        reset()
        print("Missed")
//        scoreGoalkeeper += 1
        gameStatus = .missed
    }
    
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
    
    // function to add Node of a ball
    private func addBall() {
        //settings for ball pic placement -- on the penalty point -- relationship to Stadio
        ball.position = CGPoint(x: 0, y:  frame.size.height * -0.2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.isDynamic = true
        ball.name = "ball"
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        stadioBackground.addChild(ball)
    }
    
    
    // add arrow for choosing direction
    private func addArrow() {
        //settings for arrow pic placement -- on a line -- relationship to Stadio
        arrow.anchorPoint = CGPoint(x: 0.5, y: 1)
        arrow.position = CGPoint(x: -0.5 * frame.size.width + arrow.size.width, y: frame.size.height * -0.04)
        
        stadioBackground.addChild(arrow)
    }
    
    //function for touching
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStatus == .shot {
            moveArrow() // func for an arrow moving
        }
        
    }
    
    // after touching ended following a shot
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStatus == .shot {
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
            arrow.removeAction(forKey: "arrow-moving")
            print("shot")
        } else {
            gameStatus = .shot
        }
    }
    
    //function to move ball in the direction of an arrow
    func moveBall(location: CGPoint) {
        
        let ballSpeed = frame.size.height // here should be an argument to make it faster than stronger kick
        let moveDistance = frame.size.height // here should be Y coordinate after which ball will stop
        let moveDuration = moveDistance / ballSpeed // time of a ball movement for the next argument
        
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration))) // ball moving behaviour, rotation infinite, i need to stop after ball reach the last point
        
        let rotateActionRight = SKAction.rotate(byAngle: 360, duration:(TimeInterval(moveDuration))) // func which rotate the ball
        let rotateActionLeft = SKAction.rotate(byAngle: -360, duration:(TimeInterval(moveDuration)))
        
//        let scaleBall = SKAction.scale(by: 0.9, duration: (TimeInterval(moveDuration))) // to make it smaller after shot
        
        ball.run(moveAction) // I need to place ball back on a penalty point after all
//        ball.run(scaleBall) // I need later to make it a dot if missed
        
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
    
    
    //to reset screen after shot completed
    func reset() {
        goalkeeper.removeFromParent()
        arrow.removeFromParent()
        ball.removeFromParent()
        ball.removeAllActions()
        goalkeeperStateMachine.enter(GoalkeeperReady.self) // start animation for GK ready
    }
    
}
