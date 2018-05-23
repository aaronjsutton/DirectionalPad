//
//  DirectionalPad.swift
//  DirectionalPad
//
//  Created by Aaron Sutton on 5/22/18.
//  Copyright © 2018 Aaron Sutton. All rights reserved.
//

import UIKit

// MARK: - Delegate Protocol
/// Methods that respond to touch events within the control surface.
public protocol DirectionalPadDelegate: class {
	/// Called when the gesture recognizer detects a touch event.
	func trackingBegan()

	/// Called when tracking data was updated.
	/// (i.e, the user's finger moved across the screen)
	///
	/// - Parameter point: The location of the current track point.
	///										 Normalized to the unit coordinate space.
	func track(unit point: CGPoint)

	/// Called when the user ends the current touch event.
	/// (i.e, the user lifts their finger from the screen)
	func trackingEnded()

	/// Called when the touch is cancelled explictly by the system.
	/// (i.e, an incoming call)
	func trackingCancelled()
}

// MARK: - Default Delegate Implementations
public extension DirectionalPadDelegate {
	func trackingBegan() {
		return
	}

	func trackingCancelled() {
		return
	}
}

// MARK: - UIView Subclass
/// A view that implements a 4-way "D-Pad" axis control
open class DirectionalPad: UIView {

	/// The default sensitivity value.
	open class var sensitivityDefault: CGFloat {
		return  0.10
	}

	/// The delegate reference. Typically an object that
	/// is tied to the render loop of a game, such as an SKScene.
	public weak var delegate: DirectionalPadDelegate?

	/// The UIKit gesture recognizer in the view.
	var recognizer: UIPanGestureRecognizer!

	/// The sensitivity metric determines how far a gesture must
	/// travel from the initial tap point before control tracking
	/// begins.
	///
	/// The lower this value, the quicker the control surface will
	/// begin tracking a pan gesture.
	///
	/// - Warning: Setting this value below zero is undefined behavior.
	@IBInspectable
	public var sensitivity: CGFloat = DirectionalPad.sensitivityDefault

	/// Directions that define movement axes of the control surface.
	/// Raw values are rotation angles expressed in degrees.
	///
	/// - North: Towards the top of the screen.
	/// - East: Towards the right of the screen.
	/// - South: Towards the botton of the screen.
	/// - West: Towards the left of the screen.
	public enum Direction: CGFloat {
		case North = 0
		case East = 90
		case South = 180
		case West = 270
	}

	// MARK: - Initializers

	/// Initialize from a `nib` file
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.recognizer = configureRecognizer()
	}

	/// Initialize from a CGRect frame.
	override public init(frame: CGRect) {
		super.init(frame: frame)
		self.recognizer = configureRecognizer()
	}


	/// [init(frame:)]: https://developer.apple.com/documentation/uikit/uiview/1622488-init
	///
	/// Initialize with a specified frame and sensitivity.
	///
	/// - Parameters:
	///   - frame: The frame of the control pad. See [init(frame:)] for more
	///						 information on frames.
	///   - sensitivity: A custom sensitivity value
	public convenience init(frame: CGRect,
													sensitivity: CGFloat) {
		self.init(frame: frame)
		self.sensitivity = sensitivity
	}

	/// Create and add the recognizer to the view.
	///
	/// - Returns: The newly created recognizer.
	private func configureRecognizer() -> UIPanGestureRecognizer {
		let recognizer = UIPanGestureRecognizer(target: self, action: #selector(actionHandler))
		addGestureRecognizer(recognizer)
		return recognizer
	}

	// MARK: - Target-Action Handling

	/// Called by the gesture recognizer to respond to
	/// touch events.
	@objc private func actionHandler() {

	}

	// MARK: - Mathematical Helpers

	/// Convert an absolute coordinate to a unit point.
	///
	/// - Parameter point: The absolute point within the view's frame.
	/// - Returns: The unit point within the view's frame.
	func unit(point: CGPoint) -> CGPoint {
		let unitX = point.x / bounds.maxX
		let unitY = point.y / bounds.maxY
		return CGPoint(x: unitX, y: unitY)
	}
}
