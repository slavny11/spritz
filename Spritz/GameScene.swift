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
        
        stadioBackground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        goalkeeper.position = CGPoint(x: 0, y:  size.height * 0.15)
        ball.position = CGPoint(x: 0, y:  size.height * -0.2)
        arrow.anchorPoint = CGPoint(x: 0.5, y: 1)
        arrow.position = CGPoint(x: 0, y: size.height * -0.04)
        
        
        addChild(stadioBackground)
        stadioBackground.addChild(ball)
        stadioBackground.addChild(goalkeeper)
        stadioBackground.addChild(arrow)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        
        moveBall(location: location)
        rotateBall()
        moveArrow()
        
    }
    
    func moveBall(location: CGPoint) {
        
        let ballSpeed = frame.size.height / 3
        
        let moveDifference = CGPoint(x: location.x - ball.position.x, y: location.y - ball.position.y)
        let moveDistance = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        
        let moveDuration = moveDistance / ballSpeed
        
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))
        ball.run(moveAction)
        
    }
    
    func rotateBall() {
        
        let rotateAction = SKAction.rotate(byAngle: 360, duration: 1)
        let rotateForever = SKAction.repeatForever(rotateAction)
        ball.run(rotateForever)
    }
    
    func moveArrow() {
        
        var multiplierForDirection: CGFloat
        let arrowSpeed = frame.size.width / 3
        
        if arrow.position.x > -1 {
            multiplierForDirection = 1
        } else {
            multiplierForDirection = -1
        }
        
        let moveDistance = frame.size.width - arrow.position.x
        let moveDuration = moveDistance / arrowSpeed
        
        let moveAction = SKAction.moveTo(x: multiplierForDirection * frame.size.width, duration: moveDuration)
        let moveArrowForever = SKAction.repeatForever(moveAction)
        arrow.run(moveArrowForever)
    }

}
