//
//  EmailVeiwController.swift
//  DdayApp
//
//  Created by 유은영 on 2020/01/07.
//  Copyright © 2020 EMMA. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class EmailVeiwController: UIViewController, MFMailComposeViewControllerDelegate{
    override func viewDidLoad(){
        super.viewDidLoad()
        if !MFMailComposeViewController.canSendMail(){
        print("Mail avaliable")
        return}
    }
}
