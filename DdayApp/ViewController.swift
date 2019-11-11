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
    @IBOutlet weak var SelectTheDayBtn: UIButton!
    
    // 날자 버튼 배열
    var DayBtns : [UIButton] = []
    
    // 주 처리 클래스
    let core = Core()
    
    // 파라미터
    var Param = ConfigDataParam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // 이미지에 버튼 이벤트 효과 주기
        CreateImg2Btn()
        
        // 날짜 버튼을 배열로 적용
        SetDayBtns()
        
        // 데이터 베이스 연결
        core.CreateDB()
        
       // 현재 시간 정보를 가져옴
       core.GetTodayInfo(dayinfo: Param)
        
       // 달력 보여주기
       CalendarDisplay()
    }
    
    // 이미지에 버튼 효과를 주기
    func CreateImg2Btn()
    {
        // button event
        NextMonthBtn.isUserInteractionEnabled = true
        NextMonthBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("GotoNextMonth"))))
        BeforMonthBtn.isUserInteractionEnabled = true
        BeforMonthBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action:Selector(("GotoBeforeMonth"))))
    }
    
    // 날짜 버튼에 대한 배열로 적용
    func SetDayBtns()
    {
        // 버튼의 아이디를 기준으로 사용할 버튼만 선별한다.
        for v : AnyObject in self.view.subviews{
            if v is UIButton{
                let s : String = (v.restorationIdentifier) ?? ""
                if( s != ""){
                    let index = Int(s) ?? -1
                    if index >= 0 && index <= 41{
                        DayBtns.append(v as! UIButton)
                    }
                }
            }
        }
        
        // 아이디에 맞추어 재정렬
        let Temp = DayBtns
        for i in Temp{
            let s : String = (i.restorationIdentifier) ?? ""
            let Index = Int(s) ?? -1
            DayBtns[Index] = i
        }
    }
    
    // 다음 달력을 선택했을 경우 시간 정보를 변경하고 달력을 다시 보여준다.
    @objc func GotoNextMonth()
    {
        // 다음달로 변경했을 경우 처리..
        // 12월 달의 경우 다음 달 선택했을 경우 년도를 바꿈.
        core.SetNextMonth(info : Param)
        CalendarDisplay()
    }
    
    // 이전 달력을 선택했을 경우 시간 정보를 변경하고 달력을 다시 보여준다.
    @objc func GotoBeforeMonth()
    {
        // 이전달로 변경했을 경우 처리..
        // 1월에서 변경될 경우 년도를 수정해준다.
        core.SetBeforeMonth(info : Param)
        CalendarDisplay()
    }
    
    // 사랑일 디스플레이
    func OnDisplayLoveDay()
    {
        // 디비를 통해 사랑일에 대한 정보를 배열로 가져온다.
        var result : [TheLoveDayInfo] = []
        result = core.GetLoveDayDB()
        
        // 현재 달의 시작 위치
        let firstIndex = core.GetFirstDay(info: Param)
        
        for i in result{
            if i.year == Param.CurYear && i.month == Param.CurMonth{
                let Day : Int = Int(i.day)!
                DayBtns[Day+firstIndex - 2].backgroundColor = UIColor.blue
            }
            else{
                
            }
        }
        
    }
    
    // 생리일 디스플레이
    func OnDisplayTheDay()
    {
        // 디비를 통해 생리일에 대한 정보를 배열로 가져온다.
        var result : [TheDayInfo] = []
        result = core.GetTheDayDB()
        
        // 현재 선택된 달의 시작일 위치를 가져옴.
        let firstIndex = core.GetFirstDay(info: Param)
        
        // 가져온 디비 내용에서 현재 년도와 달에 디스플레이할 날짜가 있을 경우
        // 버튼의 배경색을 노란색으로 변경해준다.
        for i in result{
            print(i.startDay + " " + i.endDay )
            let subString = i.startDay.components(separatedBy: "-")
            if subString[0] == Param.CurYear{
                if subString[1] == Param.CurMonth{
                    let Day : Int = Int(subString[2])!
                    DayBtns[Day+firstIndex - 2].backgroundColor = UIColor.yellow
                }
            }
        }
    }
    
    // 달력 디스플레이
    func CalendarDisplay()
    {
        // 타이틀 스트링 가져오기.
        TimeInfo.text = core.GetCalendarText(info : Param)
        
        // 선택된 달의 시작일과 날의 수를 계산한다.
        let firstIndex : Int = core.GetFirstDay(info: Param)
        let NumDays = core.GetNumDays(info: Param)
        
        // 버튼 아이디에 맞춰 글자, 배경을 설정한다.
        for v : UIButton in DayBtns{
            let pos = (v.restorationIdentifier) ?? ""
            var Index : Int = Int(pos)!
            Index += 1
            if(Index >= firstIndex && Index < firstIndex + NumDays){
                let DayString = String(Index - firstIndex + 1)
                v.setTitleColor(UIColor.black, for: UIControl.State.normal)
                v.setTitle(DayString, for: UIControl.State.normal)
                v.backgroundColor = nil
            }
            else{
                let DayString = ""
                v.setTitleColor(UIColor.black, for: UIControl.State.normal)
                v.setTitle(DayString, for: UIControl.State.normal)
                v.backgroundColor = nil
            }
        }
        
        // 현재 선택된 날에 대한 디스플레이
        MarkCurDay()
        
        // 생리일 디스플레이.
        OnDisplayTheDay()
        
        // 사랑일 디스플레이
        OnDisplayLoveDay()
    }
    
    // 현재 설정된 날에 대한 디스플레이
    func MarkCurDay()
    {
        let firstIndex : Int = core.GetFirstDay(info: Param)
        let ToDay : Int = Int(Param.CurDay)!
        let nDayIndex = firstIndex + ToDay - 1
        let dayNums = core.GetNumDays(info: Param)
        
        // 현재 달력에서 선택된 날이 유효할 경우에만 수정, 추가 버튼이 활성화 되도록한다.
        // 디스플레이하기 전에는 보이지 않게 하도록 설정
        SelectTheDayBtn.isHidden = true
        
        
        for v : UIButton in DayBtns{
            let pos = (v.restorationIdentifier) ?? ""
            var Index : Int = Int(pos)!
            Index += 1
            if(Index == nDayIndex && Index < firstIndex + dayNums){
                v.backgroundColor = UIColor.red
                
                // 선택될 날이 현재 달 유효한 날짜이면 수정, 추가 버튼이 보여지도록 한다.
                SelectTheDayBtn.isHidden = false
                
                // 파라미터 정보를 디비를 저장하도록 한다.
                core.UpDateConfigParam(info: Param)
            }
        }
    }
    
    // 날짜 버튼을 눌렀을 때...
    // 현재 달에 유효한 날짜가 아니면 예외처리...
    @IBAction func OnClickDayBtns(_ sender: UIButton) {
        let SelIndex = (sender.restorationIdentifier) ?? ""
        var index = Int(SelIndex)!
        index += 1
        let firstIndex : Int = core.GetFirstDay(info: Param)
        let dayNums = core.GetNumDays(info: Param)
        
        if( index >= firstIndex && index < firstIndex + dayNums){
            Param.CurDay = String(index - firstIndex + 1)
            CalendarDisplay()
        }
    }
}

