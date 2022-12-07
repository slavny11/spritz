//
//  ContentView.swift
//  Spritz
//
//  Created by Viacheslav on 06/12/22.
//

import SwiftUI
import UIKit
import SpriteKit

struct ContentView: View {
    
//    initialize a new var with the Scene
    var scene: SKScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size // make it fullscreen
        scene.scaleMode = .fill // make it fullscreen
        return scene
    }
    
    var body: some View {
        
//        my App View
        SpriteView(scene: self.scene)
            .frame(maxWidth: .infinity, maxHeight: .infinity) //to make it full screen, not the best way, because my pictures optimised only for IPhone 13
            .ignoresSafeArea()
        
//        storyboardView().edgesIgnoringSafeArea(.all) //        previous attempt with storyboards (decided to skip because to old)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct storyboardView: UIViewControllerRepresentable {
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let controller = storyboard.instantiateViewController(identifier: "Home")
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//
//    }
//}
