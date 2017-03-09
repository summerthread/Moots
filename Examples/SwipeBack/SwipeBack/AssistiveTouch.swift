//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class AssistiveTouch: UIButton {
    var originPoint = CGPoint.zero
    let screen = UIScreen.main.bounds

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.width / 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.26
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            fatalError("touch can not be nil")
        }
        originPoint = touch.location(in: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            fatalError("touch can not be nil")
        }
        let nowPoint = touch.location(in: self)
        let offsetX = nowPoint.x - originPoint.x
        let offsetY = nowPoint.y - originPoint.y
        center = CGPoint(x: center.x + offsetX, y: center.y + offsetY)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        reactBounds(touches: touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        reactBounds(touches: touches)
    }

    func reactBounds(touches: Set<UITouch>) {
        guard let touch = touches.first else {
            fatalError("touch can not be nil")
        }
        let endPoint = touch.location(in: self)
        let offsetX = endPoint.x - originPoint.x
        let offsetY = endPoint.y - originPoint.y
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        let padding: CGFloat = 25
        let width = screen.width - padding
        let height = screen.height - padding
        if center.x + offsetX >= width / 2 {
            self.center = CGPoint(x: width - bounds.width / 2, y: center.y + offsetY)
        } else {
            self.center = CGPoint(x: bounds.width / 2 + padding, y: center.y + offsetY)
        }
        if center.y + offsetY >= height - bounds.height / 2 {
            self.center = CGPoint(x: center.x, y: height - bounds.height / 2)
        } else if center.y + offsetY < bounds.size.height / 2 {
            self.center = CGPoint(x: center.x, y: bounds.height / 2 + padding)
        }
        UIView.commitAnimations()
    }

    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
}
