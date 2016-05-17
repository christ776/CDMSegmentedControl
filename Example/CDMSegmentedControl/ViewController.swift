//
//  ViewController.swift
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

import UIKit
import CDMSegmentedControl

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    enum Gender {
        case Male, Female
        
        func profilePicture() -> UIImage {
            switch self {
            case .Male:
                return UIImage(named: "userprofile picture male")!
                
            case .Female:
                return UIImage(named: "userprofile picture female")!
                
            }
        }
    }
    
    struct Contact {
        let name:String
        let gender:Gender
    }
    
    enum DataSource {
        case FBContacts, AddressBookContacts
        
        func contacts() -> [Contact] {
            switch self {
            case .FBContacts:
                
                return [Contact(name: "John Smith", gender: .Male),Contact(name: "Alex", gender: .Male), Contact(name: "Patty", gender: .Female)]
    
            case .AddressBookContacts:
                
                return [Contact(name: "John", gender: .Male),Contact(name: "Betsy", gender: .Female), Contact(name: "Ed", gender: .Male)]
            }
        }
    }
    
    private var datasource : DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let unselected = Look(state: .UnSelected)
        let selected = Look(state:.Selected)
        let contactsSegment = Segment(text: "CONTACTS", selectedLook: selected, unselectedLook: unselected)
        contactsSegment.setImage(UIImage(named:"contacts")!, forState: .Selected)
        contactsSegment.setImage(UIImage(named:"contacts")!, forState: .UnSelected)
        
        let facebookSegment = Segment(text: "FACEBOOK", selectedLook: selected, unselectedLook: unselected)
        facebookSegment.setForegroundColor(UIColor(rgba:"#3B5998"), state: .Selected)
        facebookSegment.setImage(UIImage(named:"square-facebook")!, forState: .Selected)
        facebookSegment.setImage(UIImage(named:"square-facebook")!, forState: .UnSelected)
        
        segmentedControl.addSegment(contactsSegment)
        segmentedControl.addSegment(facebookSegment)
        
        segmentedControl.selectedIndex = 1
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged), forControlEvents: .ValueChanged)
        
        datasource = .FBContacts
    }
    
    @objc private func segmentValueChanged() {
        
        switch segmentedControl.selectedIndex {
        case 0:
            print("Contacts selected")
            datasource = .AddressBookContacts
            
        case 1:
            print("Facebook selected")
            datasource = .FBContacts
            
        default:
            break
        }
        
        defer {
            tableView.reloadData()
        }
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.contacts().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCellIdentifier", forIndexPath: indexPath) as! ContactViewCell
        
        let contact = datasource.contacts()[indexPath.row]
        
        cell.contactLabel.text = contact.name
        cell.profileImage.image = contact.gender.profilePicture()
        
        return cell
    }
}

