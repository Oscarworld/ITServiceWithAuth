//
//  ContactsViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 26.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSurname: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = result?.authorFirst
        userSurname.text = result?.authorSecond
        userPhone.text = result?.phone
    }
}
