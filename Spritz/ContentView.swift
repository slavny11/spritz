//
//  ContentView.swift
//  Spritz
//
//  Created by Viacheslav on 06/12/22.
//

import SwiftUI
//import UIKit
import SpriteKit

struct ContentView: View {
    
//    initialize a new var with the Scene
    var scene: SKScene {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .fill // make it fullscreen
        return scene
    }
    
    var body: some View {
        
//        my App View
        SpriteView(scene: self.scene)
            .frame(maxWidth: .infinity, maxHeight: .infinity) //to make it full screen, not the best way, because my pictures optimised only for IPhone 13
            .ignoresSafeArea()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
