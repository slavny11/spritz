//
//  GoalkeeperStateMachine.swift
//  Spritz
//
//  Created by Viacheslav on 14/12/22.
//

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
    lazy var action = { SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.3, resize: false, restore: true)) } ()
    
    override func didEnter(from previousState: GKState?) {
        self.goalkeeperNode?.position = CGPoint(x: 200, y:  500)
        self.goalkeeperNode?.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.goalkeeperNode?.size = CGSize(width: 100, height: 120)
        self.goalkeeperNode?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 5))
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

    let textures: Array<SKTexture> = (0...2).map({ return "gk-center-\($0)"}).map(SKTexture.init)
    lazy var action = { SKAction.animate(with: textures, timePerFrame: 0.3, resize: false, restore: true) } ()
    
    override func didEnter(from previousState: GKState?) {
        self.goalkeeperNode?.size = CGSize(width: 100, height: 140)
        self.goalkeeperNode?.removeAction(forKey: goalkeeperAnimationKey)
        self.goalkeeperNode?.run(action, withKey: goalkeeperAnimationKey)
    }
}

class GoalkeeperJumpRight: GoalkeeperState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return true
    }

    let textures: Array<SKTexture> = (1...5).map({ return "gk-right-\($0)"}).map(SKTexture.init)
    lazy var action = { SKAction.animate(with: textures, timePerFrame: 0.3, resize: false, restore: true) } ()
    lazy var moving = { SKAction.sequence([SKAction.wait(forDuration: 0.3), SKAction.moveBy(x: 50, y: 0, duration: 0.6)])}
    
    override func didEnter(from previousState: GKState?) {
        self.goalkeeperNode?.position = CGPoint(x: 225, y:  500)
        self.goalkeeperNode?.size = CGSize(width: 130, height: 140)
        self.goalkeeperNode?.removeAction(forKey: goalkeeperAnimationKey)
        self.goalkeeperNode?.run(action, withKey: goalkeeperAnimationKey)
        self.goalkeeperNode?.run(moving())
    }
}

class GoalkeeperJumpLeft: GoalkeeperState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return true
    }

    let textures: Array<SKTexture> = (0...4).map({ return "gk-left-\($0)"}).map(SKTexture.init)
    lazy var action = { SKAction.animate(with: textures, timePerFrame: 0.3, resize: false, restore: true) } ()
    lazy var moving = { SKAction.sequence([SKAction.wait(forDuration: 0.3), SKAction.moveBy(x: -50, y: 0, duration: 0.6)])}
    
    override func didEnter(from previousState: GKState?) {
        self.goalkeeperNode?.position = CGPoint(x: 175, y:  500)
        self.goalkeeperNode?.size = CGSize(width: 130, height: 140)
        self.goalkeeperNode?.removeAction(forKey: goalkeeperAnimationKey)
        self.goalkeeperNode?.run(action, withKey: goalkeeperAnimationKey)
        self.goalkeeperNode?.run(moving())
    }
}
