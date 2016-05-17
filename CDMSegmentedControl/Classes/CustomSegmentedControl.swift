//
//  CustomSegmentedControl.swift
//  CDMSegmentedControl
//
//  Created by Christian De Martino on 05/15/2016.
//  Copyright (c) 2016 Christian De Martino. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

enum SegmentStyle {
    case Default,
    CustomSelected(backgroundColor:UIColor?,labelColor:UIColor?,iconImage:UIImage?),
    CustomNormal(backgroundColor:UIColor?,labelColor:UIColor?,iconImage:UIImage?)
    
    func iconImage() -> UIImage? {
        switch self {
        case .Default:
            return nil
        case .CustomNormal(backgroundColor: _, labelColor: _, let image):
            return image
        case .CustomSelected(backgroundColor: _, labelColor: _, let image):
            return image
        }
    }
}

extension SegmentStyle:Equatable {
    
}

func ==(lhs: SegmentStyle, rhs: SegmentStyle) -> Bool {
    
    switch (lhs,rhs) {
    case (.Default,.Default):
        return true
    default:
        return false
    }
}

import UIKit

public struct Look {
    let labelColor:UIColor
    var backgroundColor:UIColor
    let image:UIImage?
    
    public enum State {
        case Selected, UnSelected
    }
    
    public init(labelColor: UIColor, backgroundColor: UIColor, image: UIImage?) {
        self.labelColor = labelColor
        self.backgroundColor = backgroundColor
        self.image = image
    }
    
    public init (state:State) {
        switch state {
        case .Selected:
            self = Look(labelColor: UIColor.blackColor(), backgroundColor: UIColor.whiteColor(), image: nil)
            
        case .UnSelected:
            self = Look(labelColor: UIColor.darkGrayColor(), backgroundColor: UIColor.lightGrayColor(), image: nil)
            
        }
    }
    
    mutating func setForegroundColor(color:UIColor) {
        self = Look(labelColor: color, backgroundColor: backgroundColor, image: image)
    }
    
    mutating func setBackgroundColor(color:UIColor) {
        self = Look(labelColor: labelColor, backgroundColor: color, image: image)
    }
    
    mutating func setImage(img:UIImage) {
        self = Look(labelColor: labelColor, backgroundColor: backgroundColor, image: img)
    }
}

@IBDesignable public class Segment:UIView {
    
    var style:SegmentStyle = .Default
    private var icon:UIImageView?
    private var containerView:UIView?
    
    public enum State {
        case Selected, UnSelected
    }
    
    private var selected:Look!
    private var unselected:Look!
    private var state:State = .UnSelected
    
    private var label:UILabel!
    private var horizontalCenterConstraint:NSLayoutConstraint!
    
    var font : UIFont! {
        didSet {
            label.font = font
            invalidateIntrinsicContentSize()
        }
    }
    
    override public func intrinsicContentSize() -> CGSize {
        return label.intrinsicContentSize()
    }
    
    public func setForegroundColor(color:UIColor, state:State) {
        
        switch state {
        case .Selected:
            
            selected.setForegroundColor(color)
            break
            
        case .UnSelected:
            unselected.setForegroundColor(color)
            break
        }
    }
    
    public func setBackgroundColor(color:UIColor, state:State) {
        
        switch state {
        case .Selected:
            
            selected.setBackgroundColor(color)
            break
            
        case .UnSelected:
            unselected.setBackgroundColor(color)
            break
        }
    }
    
    public func setImage(image:UIImage, forState state:State) {
        
        if icon == .None {
            self.icon = UIImageView()
            self.icon!.translatesAutoresizingMaskIntoConstraints = false
            containerView!.addSubview(self.icon!)
        }
        
        switch state {
        case .Selected:
            
            selected.setImage(image)
            
        case .UnSelected:
            unselected.setImage(image)
        }
        self.setNeedsUpdateConstraints()
    }
    
    //MARK: Select
    func select(){
        
        state = .Selected
        self.label.textColor = selected.labelColor
        backgroundColor = selected.backgroundColor
        icon?.image = selected.image
    }
    
    //MARK: De Select
    func deselect(){
        
        state = .UnSelected
        self.label.textColor = unselected.labelColor
        backgroundColor = unselected.backgroundColor
        icon?.image = unselected.image
    }
    
    override public class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    convenience init(text:String) {
        self.init()
        label.text = text
        selected = Look(state: .Selected)
        unselected = Look(state:.UnSelected)
    }
    
    public init(text:String = "",selectedLook:Look,unselectedLook:Look) {
        self.init()
        label.text = text
        selected = selectedLook
        unselected = unselectedLook
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.label = UILabel(frame: frame)
        setUp(label)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.label = UILabel(coder:aDecoder)
        setUp(label)
    }
    
    override public func updateConstraints() {
        self.setUpConstraints()
        super.updateConstraints()
    }
    
    private func setUpConstraints() {
        
        if let icon = icon {
            
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView]|", options: NSLayoutFormatOptions(), metrics: nil, views:["containerView":containerView!]))
            
            self.addConstraint(NSLayoutConstraint(item: containerView!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
            
            containerView!.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: containerView!, attribute: .CenterY, multiplier: 1, constant: 0))
            
            containerView!.addConstraint(NSLayoutConstraint(item: icon, attribute: .CenterY, relatedBy: .Equal, toItem: containerView!, attribute: .CenterY, multiplier: 1, constant: 0))
            containerView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[thumbView]-10-[label]|", options: NSLayoutFormatOptions(), metrics: nil, views:["thumbView":icon,"label":label]))
            
            icon.addConstraint(NSLayoutConstraint(item: icon, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
            icon.addConstraint(NSLayoutConstraint(item: icon, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        }
        else {
            self.addConstraint(NSLayoutConstraint(item: label, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
            self.addConstraint( NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
            self.addConstraint( NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
        }
        
    }
    
    private func setUp(label:UILabel) {
        
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        self.userInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView = UIView()
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        containerView!.addSubview(label)
        addSubview(containerView!)
        
        self.setNeedsUpdateConstraints()
    }
    
    override public func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        label = UILabel()
        
        setUp(label)
        
        label.text = "AAAAA"
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        label.textColor = UIColor.blueColor()
        selected = Look(state: .Selected)
        unselected = Look(state:.UnSelected)
    }
}

@IBDesignable public class CustomSegmentedControl: UIControl {
    
    private var segments:[Segment] = []
    private var constraintsSuccessFullyInstalled = false
    
    override public func intrinsicContentSize() -> CGSize {
        
        let totalWidth = segments.reduce(CGFloat(0)) { (width, segment) -> CGFloat in
            return width + segment.intrinsicContentSize().width
        }
        
        return CGSize(width: totalWidth, height: segments.first?.intrinsicContentSize().height ?? CGFloat(0))
    }
    
    public var selectedIndex = 0 {
        
        didSet {
            for item in segments {
                item.deselect()
            }
            
            if segments.indices.endIndex > selectedIndex {
                let selectedSegment = segments[selectedIndex]
                selectedSegment.select()
            }
        }
    }
    
    public func addSegment(segment:Segment) {
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(segment)
        segments.append(segment)
        self.setNeedsUpdateConstraints()
    }
    
    override init(frame: CGRect) {
        self.fontSize = 12.0
        super.init(frame: frame)
        
    }
    
    required public init?(coder: NSCoder) {
        self.fontSize = 12.0
        super.init(coder: coder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        selectedIndex = 0
    }
    
    override public class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override public func updateConstraints() {
        
        if !constraintsSuccessFullyInstalled {
            addIndividualItemConstraints(segments, mainView:self , padding: 0)
        }
        super.updateConstraints()
    }
    
    var font:UIFont = UIFont.systemFontOfSize(12) {
        didSet {
        _ = self.segments.map { $0.font = font}
        }
    }
    
    @IBInspectable var fontSize: CGFloat {
        didSet{
            font = font.fontWithSize(fontSize)
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor = UIColor.clearColor() {
        didSet {
            
            if borderColor != UIColor.clearColor() {
                self.layer.borderColor = borderColor.CGColor
                self.layer.borderWidth = 1
            }
        }
    }
    
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        let location = touch.locationInView(self)
        
        for (index, item) in segments.enumerate() {
            if item.frame.contains(location) {
                selectedIndex = index
                sendActionsForControlEvents(.ValueChanged)
                break
            }
        }
        
        return false
    }
    
    override public func cancelTrackingWithEvent(event: UIEvent?)
    {
        print("Canceled tracking event")
    }
    
    override public func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        
        let unselected = Look(state: .UnSelected)
        let selected = Look(state:.Selected)
        
        let pandaStatus = Segment(text: "First Segment",selectedLook: selected,unselectedLook: unselected)
        let pandaPoints = Segment(text: "Second Segment",selectedLook: selected,unselectedLook: unselected)
        
        addSegment(pandaStatus)
        addSegment(pandaPoints)
        fontSize = 15.0
        selectedIndex = 0
//        pandaStatus
    }
    
    
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        
        for (index, button) in items.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == items.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -padding)
                
            }else{
                
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -padding)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: mainView, attribute: .Leading, multiplier: 1.0, constant: padding)
                
            }else{
                
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevButton, attribute: .Right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: firstItem, attribute: .Width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
        
        constraintsSuccessFullyInstalled = true
    }
    
}
