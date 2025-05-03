//
//  ViewController.swift
//  ReadMore
//
//  Created by Apple on 01/11/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var decLBL: UILabel!
    var text1 = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        text1 = "I've got a project (that has been written by other people) where there's a feed with content and text/Users/spoorsiosuser/Desktop/ExpendLable.zip displayed inside a table view. Each post corresponds to one section in table view, and each section has its own rows corresponding to elements like content, text, like button etc.I've got a project (that has been written by other people) where there's a feed with content and text displayed inside a table view. Each post corresponds to one section in table view, and each section has its own rows corresponding to elements like content, text, like button etc."
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            let maxLines = self.decLBL.calculateMaxLines()
            print("maxLines....\(maxLines)")
            if maxLines > 2 {
                self.decLBL.appendReadmore(after: self.text1, trailingContent: .readmore)
            }else{
                self.decLBL.text = self.text1
            }
        }
        
        decLBL.appendReadmore(after: text1, trailingContent: .readmore)
        //        descLabel.appendReadLess(after: textDescription, trailingContent: .readless)
        decLBL.isUserInteractionEnabled = true
        setupLabelTap()
        
    }
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let text = decLBL.text else { return }
        
        let readmore = (text as NSString).range(of: TrailingContent.readmore.text)
        let readless = (text as NSString).range(of: TrailingContent.readless.text)
        if sender.didTap(label: decLBL, inRange: readmore) {
            decLBL.appendReadLess(after: text1, trailingContent: .readless)
        } else if  sender.didTap(label: decLBL, inRange: readless) {
            decLBL.appendReadmore(after: text1, trailingContent: .readmore)
        } else { return }
    }
    
    func setupLabelTap() {
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.decLBL.isUserInteractionEnabled = true
        self.decLBL.addGestureRecognizer(labelTap)
        
    }

}

extension UITapGestureRecognizer {
    
    func didTap(label: UILabel, inRange targetRange: NSRange) -> Bool {
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
