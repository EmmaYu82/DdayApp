//
//  SetTheDay.swift
//  DdayApp
//
//  Created by hyunwoo jung on 09/11/2019.
//  Copyright © 2019 EMMA. All rights reserved.
//

import UIKit

class SetTheDay: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var SetTerm: UIPickerView!
    @IBOutlet weak var SetCycle: UIPickerView!
    @IBOutlet weak var SetTermValue: UILabel!
    @IBOutlet weak var SetCycleValue: UILabel!
    @IBOutlet weak var AutoSet: UISwitch!
    var TermArray = ["1","2","3","4","5","6","7"]
    var CycleArray = ["35","34","33","32","31","30","29","28","27","26","25"]
    
    var core = Core()
    var Param = ConfigDataParam()
    var TempParam = ConfigDataParam()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetTerm.delegate = self
        SetTerm.dataSource = self
        SetCycle.delegate = self
        SetCycle.dataSource = self
        
        core.CreateDB()
        core.GetGetConfigParam(info: Param)
        
        if Param.AutoCal == "0"{
            AutoSet.setOn(false, animated: true)
            SetTerm.isHidden = false
            SetCycle.isHidden = false
            SetTermValue.text = Param.Term + "일"
            SetCycleValue.text = Param.Cycle + "일"
        }
        else{
            AutoSet.setOn(true, animated: true)
            SetTerm.isHidden = true
            SetCycle.isHidden = true
            SetTermValue.text = core.GetAvrTerm(info: Param) + "일"
            SetCycleValue.text = core.GetAvrCycle(info: Param) + "일"
            if(SetTermValue.text == "0" || SetCycleValue.text == "0"){
                SetTermValue.text = Param.Term
                SetCycleValue.text = Param.Cycle
            }
            
        }
    }
    
    @IBAction func OnAutoSet(_ sender: Any) {
        if AutoSet.isOn{
            SetTermValue.text = core.GetAvrTerm(info: Param) + "일"
            SetCycleValue.text = core.GetAvrCycle(info: Param) + "일"
            Param.AutoCal = "1"
            SetTerm.isHidden = true
            SetCycle.isHidden = true
        }
        else{
            Param.AutoCal = "0"
            SetTerm.isHidden = false
            SetCycle.isHidden = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let cell = (pickerView.restorationIdentifier)!
        if(cell == "term"){
            return TermArray.count
        }
        else if(cell == "cycle"){
            return CycleArray.count
        }
        else{
            return TermArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let cell = (pickerView.restorationIdentifier)!
        if(cell == "term"){
            return TermArray[row]
        }
        else if(cell == "cycle"){
            return CycleArray[row]
        }
        else{
            return TermArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = (pickerView.restorationIdentifier)!
        if(cell == "term"){
            Param.Term = TermArray[row]
            SetTermValue.text = TermArray[row] + "일"
        }
        else if(cell == "cycle"){
            Param.Cycle = CycleArray[row]
            SetCycleValue.text = CycleArray[row] + "일"
        }
        else{
        }
    }
    
    @IBAction func SaveSet(_ sender: Any) {
        core.UpDateConfigParam(info: Param)
    }
    
}
