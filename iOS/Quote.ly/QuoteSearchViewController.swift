//
//  SearchViewController.swift
//  Quote.ly
//
//  Created by Timothy Miko on 1/26/16.
//  Copyright © 2016 Datonic Group. All rights reserved.
//

import UIKit

class QuoteSearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var minLengthTextField: UITextField!
    @IBOutlet weak var maxLengthTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addKeyboardReturnButton(self.minLengthTextField, title: "Done", tag: 1)
        self.addKeyboardReturnButton(self.maxLengthTextField, title: "Done", tag: 2)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "QuoteResultSegue") {
            let controller = segue.destinationViewController as! QuoteResultViewController
            
            if let cat = self.categoryTextField.text {
                if cat.characters.count > 0 {
                    controller.category = cat
                }
            }
            
            if let minLengthText = self.minLengthTextField.text {
                if let minLength = Int(minLengthText) {
                    controller.minLength = minLength
                }
            }
            
            if let maxLengthText = self.maxLengthTextField.text {
                if let maxLength = Int(maxLengthText) {
                    controller.maxLength = maxLength
                }
            }
        }
    }
    
    @IBAction func unwindFromResult(segue: UIStoryboardSegue) {
        
        self.categoryTextField.text = nil
        self.minLengthTextField.text = nil
        self.maxLengthTextField.text = nil
        
    }
    
    func addKeyboardReturnButton(textField: UITextField, title: String, tag: Int) {
        let doneToolbar: UIToolbar = UIToolbar()
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Done, target: self, action: Selector("keyboardReturnButtonTapped:"))
        done.tintColor = UIColor.whiteColor()
        done.tag = tag
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField.inputAccessoryView = doneToolbar
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func keyboardReturnButtonTapped(button: UIBarButtonItem) {
        if (button.tag == 1) {
            self.minLengthTextField.resignFirstResponder()
        } else if (button.tag == 2) {
            self.maxLengthTextField.resignFirstResponder()
        }
    }
}
