//
//  ViewController.swift
//  DdayApp
//
//  Created by EMMA on 09/09/2019.
//  Copyright © 2019 EMMA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var NextMonthBtn: UIImageView!
    @IBOutlet weak var BeforMonthBtn: UIImageView!
    @IBOutlet weak var TimeInfo: UILabel!
    @IBOutlet weak var D1: UILabel!
    @IBOutlet weak var D2: UILabel!
    @IBOutlet weak var D3: UILabel!
    @IBOutlet weak var D4: UILabel!
    @IBOutlet weak var D5: UILabel!
    @IBOutlet weak var D6: UILabel!
    @IBOutlet weak var D7: UILabel!
    @IBOutlet weak var D8: UILabel!
    @IBOutlet weak var D9: UILabel!
    @IBOutlet weak var D10: UILabel!
    @IBOutlet weak var D11: UILabel!
    @IBOutlet weak var D12: UILabel!
    @IBOutlet weak var D13: UILabel!
    @IBOutlet weak var D14: UILabel!
    @IBOutlet weak var D15: UILabel!
    @IBOutlet weak var D16: UILabel!
    @IBOutlet weak var D17: UILabel!
    @IBOutlet weak var D18: UILabel!
    @IBOutlet weak var D19: UILabel!
    @IBOutlet weak var D20: UILabel!
    @IBOutlet weak var D21: UILabel!
    @IBOutlet weak var D22: UILabel!
    @IBOutlet weak var D23: UILabel!
    @IBOutlet weak var D24: UILabel!
    @IBOutlet weak var D25: UILabel!
    @IBOutlet weak var D26: UILabel!
    @IBOutlet weak var D27: UILabel!
    @IBOutlet weak var D28: UILabel!
    @IBOutlet weak var D29: UILabel!
    @IBOutlet weak var D30: UILabel!
    @IBOutlet weak var D31: UILabel!
    @IBOutlet weak var D32: UILabel!
    @IBOutlet weak var D33: UILabel!
    @IBOutlet weak var D34: UILabel!
    @IBOutlet weak var D35: UILabel!
    
    
     let core = Core()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // button event
        NextMonthBtn.isUserInteractionEnabled = true
        NextMonthBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("GotoNextMonth"))))
        BeforMonthBtn.isUserInteractionEnabled = true
        BeforMonthBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action:Selector(("GotoBeforeMonth"))))
        
        //
        //DisplayCalendar.isUserInteractionEnabled = false
        
        /*Core*/
        core.OnInit()
        CalendarDisplay()
        
        //self.rest
    }
    
    // next month
    @objc func GotoNextMonth()
    {
        core.SetNextMonth()
        CalendarDisplay()
    }
    
    // before month
    @objc func GotoBeforeMonth()
    {
        core.SetBeforeMonth()
        CalendarDisplay()
    }
    
    func CalendarDisplay()
    {
        TimeInfo.text = core.GetCurTimeText()
        var days = core.GetDayTable()
      //  var days = Array(dayTable.strin)
        D1.text = days[0]
        D2.text = days[1]
        D3.text = days[2]
        D4.text = days[3]
        D5.text = days[4]
        D6.text = days[5]
        D7.text = days[6]
        D8.text = days[7]
        D9.text = days[8]
        D10.text = days[9]
        D11.text = days[10]
        D12.text = days[11]
        D13.text = days[12]
        D14.text = days[13]
        D15.text = days[14]
        D16.text = days[15]
        D17.text = days[16]
        D18.text = days[17]
        D19.text = days[18]
        D20.text = days[19]
        D21.text = days[20]
        D22.text = days[21]
        D23.text = days[22]
        D24.text = days[23]
        D25.text = days[24]
        D26.text = days[25]
        D27.text = days[26]
        D28.text = days[27]
        D29.text = days[28]
        D30.text = days[29]
        D31.text = days[30]
        D32.text = days[31]
        D33.text = days[32]
        D34.text = days[33]
        D35.text = days[34]
    }
}

