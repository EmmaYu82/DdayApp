//
//  PassWordSet.swift
//  DdayApp
//
//  Created by hyunwoo jung on 2020/01/03.
//  Copyright © 2020 EMMA. All rights reserved.
//


import UIKit

class PassWordSet: UIViewController {
    
    var core = Core()
    var param = ConfigDataParam()
    @IBOutlet weak var OldPass: UITextField!
    @IBOutlet weak var NewPass: UITextField!
    @IBOutlet weak var NewPassCheck: UITextField!
    @IBOutlet weak var Message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 디비 로딩
        core.CreateDB()
        core.GetGetConfigParam(info: param)
    }
    
    @IBAction func OnChangePassWord(_ sender: Any) {
        if OldPass.text != param.Pass {
            Message.text = "기존 번호를 확인바랍니다"
        }
        else if NewPass.text != NewPassCheck.text{
            Message.text = "신규 번호를 확인바랍니다"
        }
        else{
            param.Pass = NewPass.text!
            core.UpDateConfigParam(info: param)
            core.GetGetConfigParam(info: param)
            print(param.Pass)
            Message.text = "비밀번호가 변경되었습니다"
        }
    }
}
