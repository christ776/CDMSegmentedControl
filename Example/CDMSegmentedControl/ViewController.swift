//
//  ViewController.swift
//  CDMSegmentedControl
//
//  Created by Christian De Martino on 05/15/2016.
//  Copyright (c) 2016 Christian De Martino. All rights reserved.
//

import UIKit
import CDMSegmentedControl

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let unselected = Look(state: .UnSelected)
        let selected = Look(state:.Selected)
        let contactsSegment = Segment(text: "CONTACTS", selectedLook: selected, unselectedLook: unselected)
        contactsSegment.setImage(UIImage(named:"connect")!, forState: .Selected)
        
        let facebookSegment = Segment(text: "FACEBOOK", selectedLook: selected, unselectedLook: unselected)
        facebookSegment.setForegroundColor(UIColor(rgba:"#3B5998"), state: .Selected)
        facebookSegment.setImage(UIImage(named:"facebook_blue")!, forState: .Selected)
        
        segmentedControl.addSegment(contactsSegment)
        segmentedControl.addSegment(facebookSegment)
        
        segmentedControl.selectedIndex = 1
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged), forControlEvents: .ValueChanged)
    }
    
    @objc private func segmentValueChanged() {
        
        switch segmentedControl.selectedIndex {
        case 0:
            print("Contacts selected")
            
        case 1:
            print("Facebook selected")
            
        default:
            break
        }
    }

}

