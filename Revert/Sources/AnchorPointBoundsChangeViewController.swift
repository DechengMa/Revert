//
//  Copyright © 2015 Itty Bitty Apps. All rights reserved.

import UIKit

final class AnchorPointBoundsChangeViewController: RevertViewController {
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    self.animateIfNecessary()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    // Update the scrollview' subview's height to match the screen height with a minimum value
    let totalAvailableHeight = self.view.bounds.height - self.topLayoutGuide.length - self.bottomLayoutGuide.length
    let scrollViewItemHeight = floor(totalAvailableHeight / CGFloat(self.dynamicType.numberOfItems))
    self.scrollViewItemHeight.constant = max(scrollViewItemHeight, self.dynamicType.minimumItemHeight)
    
    let offset: CGFloat = -self.boundsChangeView.frame.height / 4
    self.boundsChangeLabel.text = self.boundsChangeLabel.text?.stringByReplacingOccurrencesOfString("?", withString:"\(offset)")
  }

  // MARK: Private

  private static let minimumItemHeight: CGFloat = 150
  private static let numberOfItems = 2

  private var wasAnimated = false

  @IBOutlet private weak var boundsChangeView: HairlineBorderView!
  @IBOutlet private weak var anchorPointView: HairlineBorderView!
  @IBOutlet private weak var boundsChangeLabel: UILabel!
  @IBOutlet private weak var scrollViewItemHeight: NSLayoutConstraint!

  private func animateIfNecessary() {
    if self.wasAnimated {
      return
    }

    self.wasAnimated = true

    // Bounds Change testing
    let offset: CGFloat = -self.boundsChangeView.frame.height / 4
    UIView.animateWithDuration(1, delay: 0, options: .CurveEaseInOut, animations: {
      self.boundsChangeView.bounds = CGRectOffset(self.boundsChangeView.bounds, offset, offset)
      }, completion: nil)

    // Anchor Point Testing

    let toValue = CGPoint(x: 0.25, y: 0.25)
    let basicAnimation = self.dynamicType.basicAnimationWithFromValue(self.anchorPointView.layer.anchorPoint, toValue: toValue)
    self.anchorPointView.layer.addAnimation(basicAnimation, forKey: "anchorPoint")
    self.anchorPointView.layer.anchorPoint = toValue
  }
}

private extension AnchorPointBoundsChangeViewController {
  static func basicAnimationWithFromValue(fromValue: CGPoint, toValue: CGPoint) -> CABasicAnimation {
    let basicAnimation = CABasicAnimation(keyPath: "anchorPoint")
    basicAnimation.duration = 1
    basicAnimation.fromValue = NSValue(CGPoint: fromValue)
    basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    basicAnimation.toValue = NSValue(CGPoint: toValue)
    return basicAnimation
  }
}
