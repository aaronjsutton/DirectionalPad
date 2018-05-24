//
//  ViewController.swift
//  DirectionalPadTestApp
//
//  Created by Aaron Sutton on 5/22/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import DirectionalPad
import UIKit
import SpriteKit

class ViewController: UIViewController {

	@IBOutlet weak var sceneView: SKView!
	@IBOutlet weak var control: DirectionalPad!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let scene = MainScene(fileNamed: "Main")
		guard scene != nil else { fatalError() }
		control.delegate = scene
		sceneView.presentScene(scene)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}
