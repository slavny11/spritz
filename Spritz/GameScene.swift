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
        
        let touch = touches.first!
        let location = CGPoint(x: arrow.position.x, y: size.height * 0.12) // direction in wich ball shot
        
        moveBall(location: location) // fuction for a ball moving
        rotateBall() // func for a ball rotation
        moveArrow() // func for an arrom moving
        
    }
    
    func moveBall(location: CGPoint) {
        
        let ballSpeed = frame.size.height // here should be an argument to make it faster than stronger kick
        let moveDistance = frame.size.height // here should be Y coordinate after which ball will stop
        
        let moveDuration = moveDistance / ballSpeed // time of a ball movement for the next argument
        
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration))) // ball moving behaviour, rotation infinite, i need to stop after ball reach the last point
        ball.run(moveAction) // I need to place ball back on a penalty point after all
        
    }
    
    func rotateBall() {
        
        let rotateAction = SKAction.repeatForever(
            SKAction.rotate(byAngle: 360, duration: 1))
        ball.run(rotateAction) // need to be stopped after reach final point
    }
    
    func moveArrow() {
        
        var multiplierForDirection: CGFloat
        let arrowSpeed = frame.size.width // here should be an argument to make it faster with each new level
        
        
        if arrow.position.x < 0 {
            multiplierForDirection = 1
        } else {
            multiplierForDirection = -1
        }
        
        let moveDistance = frame.size.width - arrow.size.width // distance for duration
        let moveDuration = moveDistance / arrowSpeed //duration
        
        let moveAction = SKAction.repeatForever(
            SKAction.moveTo(x: multiplierForDirection * 0.45 * frame.size.width, duration: moveDuration)) // I need to make it goes back an forth without tapping
        arrow.run(moveAction)
        
    }

}
