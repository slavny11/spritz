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

    override func didMove(to view: SKView) {
        
        backgroundColor = .green
        
        goalkeeper.position = CGPoint(x: 0, y:  size.height * 0.15)
        ball.position = CGPoint(x: 0, y:  size.height * -0.2)
        stadioBackground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
//        stadioBackground.anchorPoint = CGPoint(x: 0, y: 0)
        
        
        addChild(stadioBackground)
        stadioBackground.addChild(ball)
        stadioBackground.addChild(goalkeeper)
        
    }

}
