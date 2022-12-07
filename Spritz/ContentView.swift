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
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        
        SpriteView(scene: self.scene)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        
//        storyboardView().edgesIgnoringSafeArea(.all)
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
