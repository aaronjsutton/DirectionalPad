//
//  PlayerNode.swift
//  DirectionalPadTestApp
//
//  Created by Aaron Sutton on 5/23/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import UIKit
import SpriteKit
import DirectionalPad

class PlayerNode: SKSpriteNode {

	static var defaulRate: CGFloat = 4.5

	var rate = PlayerNode.defaulRate
	var time = 0.15

	func rotate(to radian: CGFloat) {
		let action = SKAction.rotate(toAngle: radian, duration: 0.1, shortestUnitArc: true)
		run(action)
	}

	func move(in direction: DirectionalPad.Direction) {
		let vector: CGVector!
		switch direction {
		case .North:
			vector = CGVector(dx: 0, dy: rate)
		case .South:
			vector = CGVector(dx: 0, dy: -rate)
		case .East:
			vector = CGVector(dx: -rate, dy: 0)
		case .West:
			vector = CGVector(dx: rate, dy: 0)
		}

		let action = SKAction.move(by: vector, duration: time)
		action.timingMode = .easeInEaseOut
		run(action)

	}

}
