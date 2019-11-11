//
//  SelectTheDay.swift
//  DdayApp
//
//  Created by hyunwoo jung on 09/11/2019.
//  Copyright © 2019 EMMA. All rights reserved.
//

import UIKit

class SelectTheDay: UIViewController {
    @IBOutlet weak var SelectedDay: UILabel!
    
    var param = ConfigDataParam()
    var core = Core()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        core.CreateDB()
        core.GetGetConfigParam(info: param)
        SelectedDay.text = core.GetDateString(info: param)
    }
    
    @IBAction func SetStartDay(_ sender: Any) {
        core.SetStartDay(info: param)
    }
    
    @IBAction func SetEndDay(_ sender: Any) {
        core.SetEndDay(info: param)
    }
    
    @IBAction func SetLoveDay(_ sender: Any) {
        core.SetLoveDay(info: param)
    }
    
    @IBAction func Test(_ sender: Any) {
        //var result : [TheDayInfo] = []
        //result = core.GetTheDayDB()
        
        //for i in result{
        //    print(i.startDay + " " + i.endDay )
        //}
    }
}
