//
//  SpritzViewController.swift
//  Spritz
//
//  Created by Viacheslav on 06/12/22.
//

import SpriteKit

class SpritzViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait } // UI var to work only in portrait mode
    
    override func viewDidLoad() {
        super.viewDidLoad() // her znaet zachem. tak bylo
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size) // fullscreen size
            scene.scaleMode = .resizeFill
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true //huinya
            view.showsNodeCount = true // hyinya
        }
    }
    
    // not possible to totate
    override var shouldAutorotate: Bool {
        return false
    }
    
    //hide Status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
