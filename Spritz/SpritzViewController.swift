//
//  SpritzViewController.swift
//  Spritz
//
//  Created by Viacheslav on 06/12/22.
//

import Foundation
import UIKit
import SwiftUI

class SpritzViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func printBTN(_ sender: Any) {
        print("Wow, this is storyboard")
    }
}
