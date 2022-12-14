//
//  GoalkeeperStateMachine.swift
//  Spritz
//
//  Created by Viacheslav on 14/12/22.
//

import Foundation
import GameplayKit
import SpriteKit
import SwiftUI

fileprivate let goalkeeperAnimationKey = "Sprite animation"

class GoalkeeperState: GKState {
    unowned var goalkeeperNode: SKSpriteNode?
    
    init(goalkeeperNode: SKSpriteNode) {
        self.goalkeeperNode = goalkeeperNode
        
        super.init()
    }
}

class GoalkeeperReady: GoalkeeperState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return true
    }

    let textures: Array<SKTexture> = (0..<2).map({ return "gk-\($0)"}).map(SKTexture.init)
    lazy var action = { SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.3, resize: false, restore: true)) } ()
    
    override func didEnter(from previousState: GKState?) {
        self.goalkeeperNode?.position = CGPoint(x: 200, y:  500)
        self.goalkeeperNode?.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.goalkeeperNode?.size = CGSize(width: 100, height: 120)
        self.goalkeeperNode?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 5))
        self.goalkeeperNode?.physicsBody?.isDynamic = false
        self.goalkeeperNode?.name = "goalkeeper"
        self.goalkeeperNode?.removeAction(forKey: goalkeeperAnimationKey)
        self.goalkeeperNode?.run(action, withKey: goalkeeperAnimationKey)
    }
}

class GoalkeeperJumpCenter: GoalkeeperState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return true
    }

    let textures: Array<SKTexture> = (0..<2).map({ return "gk-center-\($0)"}).map(SKTexture.init)
    lazy var action = { SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.3, resize: false, restore: true)) } ()
    
    override func didEnter(from previousState: GKState?) {
        self.goalkeeperNode?.removeAction(forKey: goalkeeperAnimationKey)
        self.goalkeeperNode?.run(action, withKey: goalkeeperAnimationKey)
    }
}
