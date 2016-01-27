//
//  GradientView.swift
//  Quote.ly
//
//  Created by Timothy Miko on 1/26/16.
//  Copyright © 2016 Datonic Group. All rights reserved.
//

import UIKit

@IBDesignable public class GradientView: UIView {
    @IBInspectable public var topColor: UIColor? {
        didSet {
            configureView()
        }
    }
    @IBInspectable public var bottomColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    override public class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    public init() {
        super.init(frame: CGRectZero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        configureView()
    }
    
    func configureView() {
        let layer = self.layer as! CAGradientLayer
        let locations = [ 0.0, 1.0 ]
        layer.locations = locations
        let color1 = topColor ?? self.tintColor as UIColor
        let color2 = bottomColor ?? UIColor.blackColor() as UIColor
        let colors: Array <AnyObject> = [ color1.CGColor, color2.CGColor ]
        layer.colors = colors
    }
}