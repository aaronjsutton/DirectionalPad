//
//  MainScene.swift
//  DirectionalPadTestApp
//
//  Created by Aaron Sutton on 5/23/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import UIKit
import DirectionalPad
import SpriteKit

class MainScene: SKScene, DirectionalPadDelegate {

	var player: PlayerNode!

	var direction: DirectionalPad.Direction? = nil

	override func didMove(to view: SKView) {
		player = childNode(withName: "Player") as! PlayerNode
	}

	override func update(_ currentTime: TimeInterval) {
		if direction != nil {
			player.rotate(to: DirectionalPad.radians(for: direction!))
			player.move(in: direction!)
		}
	}

	func track(_ direction: DirectionalPad.Direction) {
		self.direction = direction
	}

	func trackingEnded() {
		direction = nil
	}


}
