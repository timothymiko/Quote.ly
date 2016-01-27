//
//  QuoteResultViewController.swift
//  Quote.ly
//
//  Created by Timothy Miko on 1/26/16.
//  Copyright © 2016 Datonic Group. All rights reserved.
//

import UIKit

class QuoteResultViewController: UIViewController {
    
    var category: String = "Motivation"
    var minLength: Int = 0
    var maxLength: Int = 100
    
    var quote: String?
    var author: String?

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var copyButton: SelectableUIButton!
    @IBOutlet weak var refreshButton: SelectableUIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var httpSession: NSURLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiKeysDictionary = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("API-Keys", ofType: "plist")!)
        let theySaidSoKey = apiKeysDictionary!["TheySaidSo"]!
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["X-TheySaidSo-Api-Secret": theySaidSoKey]
        self.httpSession = NSURLSession(configuration: config)
        
        self.categoryLabel.text = self.category
        
        self.quoteLabel.alpha = 0
        self.authorLabel.alpha = 0
        self.copyButton.alpha = 0
        self.refreshButton.alpha = 0
        
        self.refresh()
    }
    @IBAction func copyToClipboard() {
        
        if let quote = self.quote {
            var author = "— Unknown"
            if let auth = self.author {
                author = "— " + auth
            }
            
            let str = quote + " " + author
            let pasteboard = UIPasteboard.generalPasteboard()
            pasteboard.string = str
        } else {
            NSLog("Unable to copy to pasteboard because their isn't a quote available!")
        }
    }

    @IBAction func refresh() {
        UIView.animateWithDuration(0.15) { () -> Void in
            self.quoteLabel.alpha = 0
            self.authorLabel.alpha = 0
            self.copyButton.alpha = 0
            self.refreshButton.alpha = 0
        }
        
        self.activityIndicator.startAnimating()
        
        let url = NSURL(string: "http://quotes.rest/quote.json?category=" + category + "&minlength=" + String(minLength) + "&maxlength=" + String(maxLength))!
        
        let dataTask = httpSession!.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            let resp = response as? NSHTTPURLResponse
            
            if (error != nil || data == nil || resp?.statusCode != 200) {
                NSLog("Error retrieving quote -> %@", error!)
                self.performSegueWithIdentifier("UnwindToSearchSegue", sender: self)
            } else {
                
                do {
                    
                    let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    NSLog("Retrieved new quote.")
                    
                    self.quote = json["contents"]!["quote"] as? String
                    self.author = json["contents"]!["author"] as? String
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        if self.quote == nil {
                            let alert = UIAlertController(title: "Error", message: "No quotes were found. Please try different search criteria.", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                                self.performSegueWithIdentifier("UnwindToSearchSegue", sender: self)
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                        }
                        
                        self.quoteLabel.text = self.quote
                        
                        if (self.author != nil) {
                            self.authorLabel.text = "— " + self.author!
                        } else {
                            self.authorLabel.text = "— Unknown"
                        }
                        
                        self.activityIndicator.stopAnimating()
                        
                        UIView.animateWithDuration(0.3) { () -> Void in
                            self.quoteLabel.alpha = 1
                            self.authorLabel.alpha = 1
                            self.copyButton.alpha = 1
                            self.refreshButton.alpha = 1
                        }
                    }
                    
                } catch {
                    NSLog("Error parsing response")
                    self.performSegueWithIdentifier("UnwindToSearchSegue", sender: self)
                }
            }
        }
        dataTask.resume()
    }
    
    @IBAction func unwindFromResult(segue: UIStoryboardSegue) {
        NSURLSession.sharedSession().delegateQueue.cancelAllOperations()
    }
}
