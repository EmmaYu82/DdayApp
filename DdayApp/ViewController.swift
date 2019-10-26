//
//  ViewController.swift
//  DdayApp
//
//  Created by EMMA on 09/09/2019.
//  Copyright © 2019 EMMA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let core = Core()
    @IBOutlet weak var NextMonthBtn: UIImageView!
    @IBOutlet weak var BeforMonthBtn: UIImageView!
    @IBOutlet weak var TimeInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // button event
        NextMonthBtn.isUserInteractionEnabled = true
        NextMonthBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("GotoNextMonth"))))
        BeforMonthBtn.isUserInteractionEnabled = true
        BeforMonthBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action:Selector(("GotoBeforeMonth"))))
        
        
        /*Core*/
        core.OnInit()
    }
    
    // next month
    @objc func GotoNextMonth()
    {
        core.SetNextMonth()
        DisplayTimeInfo()
    }
    
    // before month
    @objc func GotoBeforeMonth()
    {
        core.SetBeforeMonth()
        DisplayTimeInfo()
    }
    
    func DisplayTimeInfo()
    {
        let timeText = core.GetCurTimeText()
        TimeInfo.text = timeText
        core.UpdateCalinder()
        //print(timeText)
    }
}

