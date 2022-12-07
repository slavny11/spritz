//
//  SpritzViewController.swift
//  Spritz
//
//  Created by Viacheslav on 06/12/22.
//

import Foundation
import UIKit
import SwiftUI
import SpriteKit

class SpritzViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
                    scene.scaleMode = .resizeFill
                    
                    view.presentScene(scene)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
    }
    
    override var shouldAutorotate: Bool {
            return false
        }
    
    override var prefersStatusBarHidden: Bool {
            return true
        }
    
    @IBAction func printBTN(_ sender: Any) {
        print("Wow, this is storyboard")
    }
}
