//
//  SelectTheDay.swift
//  DdayApp
//
//  Created by hyunwoo jung on 09/11/2019.
//  Copyright © 2019 EMMA. All rights reserved.
//

import UIKit

class SelectTheDay: UIViewController {
    
    // 선택 날짜 디스플레이 라벨
    @IBOutlet weak var SelectedDay: UILabel!
    @IBOutlet weak var LoveDay: UILabel!
    @IBOutlet weak var LoveDayBtn: UIButton!
    @IBOutlet weak var StartDayInfo: UILabel!
    @IBOutlet weak var EndDayInfo: UILabel!
    @IBOutlet weak var StartDayLabel: UILabel!
    @IBOutlet weak var EndDayLabel: UILabel!
    @IBOutlet weak var EndDayBtn: UIButton!
    @IBOutlet weak var DeleteTheDayBtn: UIButton!
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    // 현재 선택된 생리 일정
    var curInfo = TheDayInfo()
    
    // 생리 일정 수정 플래그
    var bTheDayEdit : Bool = false
    
    // 사랑일 추가, 삭제 플래그
    var bLoveDayEdit : Bool = false
    
    // 프로그램 환경 변수
    var param = ConfigDataParam()
    
    // 코어 클래스
    var core = Core()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 디비 로딩
        core.CreateDB()
        // 환경 변수 로딩
        core.GetGetConfigParam(info: param)
        // 선택된 날을 디스플레이
        SelectedDay.text = core.GetDateString(info: param)
        // 디스플레이
        Display()
        
        
        DatePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
    }
    
    @objc func changed(){
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        let date = dateformatter.string(from: DatePicker.date)
        // 월, 일, 년
        print(date)
    }
    func Display(){
        var theDayInfo : [TheDayInfo] = []
        var loveDayInfo : [TheLoveDayInfo] = []
        
        // 각 데이터 베이스 정보를 가져온다.
        theDayInfo = core.GetTheDayDB()
        loveDayInfo = core.GetLoveDayDB()
        
        // 선택된 날이 사랑일이면 제거 버튼 활성화 시킴
        for i in loveDayInfo{
            if core.IsLoveDay(loveDayInfo: i, info: param) == true{
                LoveDay.text = "Love Day Cancle"
                let img : UIImage = UIImage(named : "lovedayCancel@1")!
                LoveDayBtn.setImage(img, for: UIControl.State.normal)
                bLoveDayEdit = true
            }
        }
        
        // 선택된 날이 시작일과 마지막일 기준이면 관련 시작일과 마지막일을 디스플레이하여
        // 사용자가 수정할 수 있도록 하며,
        // 그렇지 않을 경우 시작일만 지정할 수 있도록 한다.
        StartDayInfo.text = ""
        EndDayInfo.text = ""
        bTheDayEdit = false
        for i in theDayInfo{
            if core.IsTheDay(theDayInfo: i, info: param) == true{
                StartDayInfo.text = i.startDay
                EndDayInfo.text = i.endDay
                bTheDayEdit = true
                curInfo = i
            }
        }
        
        // 선택된 날이 시작일과 마지막일 사이에 있다면 수정 버튼으로 전환
        // 그렇지 않을 경우 저장 버튼으로 전환한다.
        if bTheDayEdit == true{
            StartDayLabel.text = "Start Day Edit"
            EndDayLabel.text = "End Day Edit"
            EndDayLabel.isHidden = false
            EndDayBtn.isHidden = false
            DeleteTheDayBtn.isHidden = false
        }
        else{
            StartDayInfo.text = core.GetDateString(info: param)
            StartDayLabel.text = "Start Day Save"
            EndDayLabel.isHidden = true;
            EndDayBtn.isHidden = true;
            DeleteTheDayBtn.isHidden = true;
        }
    }

    // 선택된 날을 시작일로 저장
    @IBAction func SetStartDay(_ sender: Any) {
       if bTheDayEdit == true{
            // 수정
            StartDayInfo.text = core.GetDateString(info: param)
            UpDateTheDay(filt: 1)
      }
      else{
            // 추가
            core.SetStartDay(info: param)
      }
      
      SaveConfigParam()
    }
    
    func SaveConfigParam()
    {
        param.bSetCurTime = "1"
        core.UpDateConfigParam(info: param)
        print(param.bSetCurTime)
    }
    // 선택된 날을 마지막일로 저장
    @IBAction func SetEndDay(_ sender: Any) {
        if bTheDayEdit{
            // 수정
            EndDayInfo.text = core.GetDateString(info: param)
            UpDateTheDay(filt: 0)
            
        }
        else{
            // 작업 없음
        }
        
        SaveConfigParam()
    }
    
    // 데이터 베이스 업데이트하기
    func UpDateTheDay(filt : Int)
    {
        curInfo.startDay = StartDayInfo.text!
        curInfo.endDay = EndDayInfo.text!
        curInfo.term = String(core.GetIntervalDays(startDay: curInfo.startDay, endDay: curInfo.endDay))
        core.UpDateTheDay(info: curInfo, filt: filt)
        SaveConfigParam()
    }
    
    // 선택된 날을 사랑일로 저장
    @IBAction func SetLoveDay(_ sender: Any) {
        if bLoveDayEdit == true {
            // 디비에서 해당 정보 제거
            core.DeleteLoveDay(info: param)
        }
        else{
            // 디비에서 해당 정보 추가
            core.SetLoveDay(info: param)
        }
        SaveConfigParam()
    }
    
    // 데이터 베이스 정보 삭제하기
    @IBAction func DeleteTheDay(_ sender: Any) {
        core.DeleteTheDay(info: curInfo)
        SaveConfigParam()
    }
}
