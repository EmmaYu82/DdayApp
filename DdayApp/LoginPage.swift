//
//  LoginPage.swift
//  DdayApp
//
//  Created by hyunwoo jung on 2020/01/03.
//  Copyright © 2020 EMMA. All rights reserved.
//


import UIKit

class LoginPage: UIViewController {
    @IBOutlet weak var Test: UITextField!
    
    var core = Core()
    var param = ConfigDataParam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        core.CreateDB()
        core.GetGetConfigParam(info: param)
        print(param.Pass)
    }
    
    @IBAction func CheckPass(_ sender: Any) {
        if Test.text != param.Pass{
            
        }
        else{
        let StartController = self.storyboard?.instantiateViewController(withIdentifier: "StartPoint")
          StartController?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
          self.present(StartController!, animated: true, completion: nil)
        }
    }
    
}
