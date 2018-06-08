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
	/// - Parameter direction: The `Direction` that is currently
	///												 being tracked.
	func track(_ direction: DirectionalPad.Direction)

	/// Called when the user ends the current touch event.
	/// (i.e, the user lifts their finger from the screen)
	func trackingEnded()

	/// Called when the touch is cancelled explictly by the system.
	/// (i.e, an incoming call)
	func trackingCancelled()
}

// MARK: - Default Delegate Implementations
public extension DirectionalPadDelegate {
	func trackingBegan() { return }
	func trackingCancelled() { return }
}

// MARK: - UIView Subclass
/// A view that implements a 4-way "D-Pad" axis control
open class DirectionalPad: UIView {

	/// The default sensitivity value.
	open class var sensitivityDefault: CGFloat {
		return 0.10
	}

	/// The delegate reference. Typically an object that
	/// is tied to the render loop of a game, such as an SKScene.
	public weak var delegate: DirectionalPadDelegate?

	/// The UIKit gesture recognizer in the view.
	var recognizer: UIPanGestureRecognizer!

	/// The sensitivity metric determines how far a gesture must
	/// travel, in unit coordinates, from the initial tap point before control
	/// tracking begins.
	///
	/// The lower this value, the quicker the control surface will
	/// begin tracking a pan gesture.
	///
	/// - Note: Sensitivty is given in the unit points, therefore, a value greater
	/// 				than one is capped.
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

	/// Axes used by the direction system.
	///
	/// - X: The horizontal axis.
	/// - Y: The vertical axis.
	private enum Axis {
		case X
		case Y
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
		// Cap sensitivity value
		if sensitivity > 1 { sensitivity = 1 }
	}

	/// [init(frame:)]:
	/// https://developer.apple.com/documentation/uikit/uiview/1622488-init
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
		recognizer = UIPanGestureRecognizer(target: self,
																				action: #selector(self.actionHandler))
		addGestureRecognizer(recognizer)
		return recognizer
	}

	// MARK: - Target-Action Handling

	/// Called by the gesture recognizer to respond to
	/// touch events.
	@objc func actionHandler() {
		switch recognizer.state {
		case .began:		  delegate?.trackingBegan()
		case .ended: 			delegate?.trackingEnded()
		case .cancelled:  delegate?.trackingCancelled()
		case .changed:
			var translation = recognizer.translation(in: self)
			if !aboveThreshhold(translation) { break }
			unit(convert: &translation)
			orient(point: &translation)
			delegate?.track(direction(of: translation))
		default: break
		}
	}

	/// Determines if a point is above the sensitivity threshold.
	///
	/// - Parameter point: The point.
	/// - Returns: True/False if the point should be tracked.
	private func aboveThreshhold(_ point: CGPoint) -> Bool {
		return abs(point.x) > sensitivity || abs(point.y) > sensitivity
	}

	/// Determine the movement direction of the current translation point.
	///
	/// - Precondition: The point is above the sensitivity threshold.
	///
	/// Axis priority determines which axis is used during diagonal swipes,
	/// and allows the user to change direction without ending
	/// the current gesture.
	///
	/// - Parameter point: The translation point.
	/// - Returns: The direction of the translation.
	func direction(of point: CGPoint) -> Direction {

		// Which axis has priority.
		var prioritized: Axis? = nil

		// Determine which axis has priority.
		switch (abs(point.x), abs(point.y)) {
		case let (x, y) where x >= y: prioritized = .X
		case let (x, y) where x < y: prioritized = .Y
		default: fatalError()
		}

		// Calculate the direction based on priority.
		switch (point.x, point.y) {
		case let (x, _) where prioritized == .X:
			switch x {
			case -1..<0: return .West 	// Negative X value
			case 0...: return .East		  // Positive X value
			default: break
			}
		case let (_, y) where prioritized == .Y:
			switch y {
			case -1..<0: return .South	// Negative Y value
			case 0...1: return .North 	// Positive X value
			default: break
			}
		default: break
		}
		return .North // Default value return, this should never happen.
	}

	// MARK: - Mathematical Helpers

	/// Convert an absolute coordinate to a unit point.
	///
	/// - Parameter point: The absolute point within the view's frame.
	func unit(convert point: inout CGPoint) {
		point.x /= bounds.maxX
		point.y /= bounds.maxY
		if point.x > 1 { point.x = 1 }
		if point.y > 1 { point.y = 1 }
	}

	/// Map a translation point's coordinates to the axis
	/// used to determine direction.
	///
	/// - Parameter point: The point to map
	func orient(point: inout CGPoint) {
		point.x.negate()
		point.y.negate()
	}

	/// Returns the radian value of a direction.
	/// Useful when animating the rotation of an
	/// SKNode.
	///
	/// - Parameter direction: The direction.
	/// - Returns: The rotation value expressed in radians.
	public class func radians(for direction: Direction) -> CGFloat {
		return direction.rawValue * (CGFloat.pi / 180)
	}
}
