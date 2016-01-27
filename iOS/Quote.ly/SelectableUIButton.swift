//
//  SelectableUIButton.swift
//  Quote.ly
//
//  Created by Timothy Miko on 1/26/16.
//  Copyright © 2016 Datonic Group. All rights reserved.
//

import UIKit

@IBDesignable public class SelectableUIButton: UIButton {
    @IBInspectable public var normalColor: UIColor? {
        didSet {
            configureView()
        }
    }
    @IBInspectable public var highlightedColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    override public var highlighted: Bool {
        didSet {
            configureView()

        }
    }
    
    func configureView() {
        if (highlighted) {
            self.backgroundColor = highlightedColor
        } else {
            self.backgroundColor = normalColor
        }
    }
}
