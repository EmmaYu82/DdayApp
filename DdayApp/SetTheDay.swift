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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetTerm.delegate = self
        SetTerm.dataSource = self
        SetCycle.delegate = self
        SetCycle.dataSource = self
        AutoSet.setOn(false, animated: true)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func OnAutoSet(_ sender: Any) {
        if AutoSet.isOn{
            print("AutoSet is On")
        }
        else{
            print("AutoSet is Off")
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
            SetTermValue.text = TermArray[row] + "일"
        }
        else if(cell == "cycle"){
            SetCycleValue.text = CycleArray[row] + "일"
        }
        else{
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
