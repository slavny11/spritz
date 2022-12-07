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
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.green
        
        ball.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        
        addChild(ball)
        
    }
    
}
