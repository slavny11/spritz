//
//  GameScene.swift
//  Spritz
//
//  Created by Viacheslav on 07/12/22.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    let ball = SKSpriteNode(imageNamed: "ball")
    let stadioBackground = SKSpriteNode(imageNamed: "bg")
    let goalkeeper = SKSpriteNode(imageNamed: "gk")
    let arrow = SKSpriteNode(imageNamed: "arrow")
    

    override func didMove(to view: SKView) {
        
        backgroundColor = .green
        
        //settings for background pic placement -- put it in the center (notice that ancor of Stadion is in a screen center, but Ancor for Sprite in bottom left angle)
        stadioBackground.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        stadioBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //settings for GK pic placement -- in the middle of gates -- relationship to Stadio
        goalkeeper.position = CGPoint(x: 0, y:  frame.size.height * 0.15)
        
        //settings for ball pic placement -- on the penalty point -- relationship to Stadio
        ball.position = CGPoint(x: 0, y:  frame.size.height * -0.2)
        
        //settings for arrow pic placement -- on a line -- relationship to Stadio
        arrow.anchorPoint = CGPoint(x: 0.5, y: 1)
        arrow.position = CGPoint(x: -0.5 * frame.size.width + arrow.size.width, y: frame.size.height * -0.04)
        
        //creating objects on a screen
        addChild(stadioBackground)
        stadioBackground.addChild(ball)
        stadioBackground.addChild(goalkeeper)
        stadioBackground.addChild(arrow)
        
    }
    
    
    //function for touching
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveArrow() // func for an arrom moving
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = CGPoint(x: arrow.position.x, y: frame.size.height * 0.2)
        
        moveBall(location: location)
        stopArrow()
    }
    
    
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
    
    func moveArrow() {
        
        let arrowSpeed = frame.size.width // here should be an argument to make it faster with each new level

        let moveDuration = frame.size.width / arrowSpeed //duration
        
        let moveRight = SKAction.moveTo(x: 0.45 * frame.size.width, duration: moveDuration) // move arrow to the rigth
        let moveLeft = SKAction.moveTo(x: -0.45 * frame.size.width, duration: moveDuration) // to the left
        let moveBackAndForth = SKAction.sequence([moveRight, moveLeft]) // making sequence
        
        let moveAction = SKAction.repeatForever(moveBackAndForth) // make it permanent
        arrow.run(moveAction, withKey: "arrow-moving")
        
    }
    
    func stopArrow() {
        arrow.removeAction(forKey: "arrow-moving")

    }
    
    func reset() {
        arrow.position = CGPoint(x: -0.5 * frame.size.width + arrow.size.width, y: frame.size.height * -0.04)
        ball.position = CGPoint(x: 0, y:  frame.size.height * -0.2)
        goalkeeper.position = CGPoint(x: 0, y:  frame.size.height * 0.15)
    }

}
