//
//  GoalkeeperStateMachine.swift
//  Spritz
//
//  Created by Viacheslav on 14/12/22.
//

import Foundation
import GameplayKit

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
    lazy var action = { SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: true)) } ()
    
    override func didEnter(from previousState: GKState?) {
        self.goalkeeperNode?.removeAction(forKey: goalkeeperAnimationKey)
        self.goalkeeperNode?.run(action, withKey: goalkeeperAnimationKey)
    }
}

class GoalkeeperJumpCenter: GoalkeeperState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return true
    }

    let textures: Array<SKTexture> = (0..<2).map({ return "gk-center-\($0)"}).map(SKTexture.init)
    lazy var action = { SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: true)) } ()
    
    override func didEnter(from previousState: GKState?) {
        self.goalkeeperNode?.removeAction(forKey: goalkeeperAnimationKey)
        self.goalkeeperNode?.run(action, withKey: goalkeeperAnimationKey)
    }
}
