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
        
        // 환경 정보 가져오기
        core.GetGetConfigParam(info: Param)
        
       // 현재 시간 또는 지정된 시간 정보를 가져옴
        print(Param.bSetCurTime)
        if(Param.bSetCurTime == "0"){
            core.GetTodayInfo(dayinfo: Param)
            
        }
        else{
            Param.bSetCurTime = "0"
            core.UpDateConfigParam(info: Param)
        }
        
        // 기간 주기 설정이 자동 일경우 평균값을 계산하여 갱신한다.
        // 입력된 데이터가 2개보다 작을 경우에는 디비에 설정된 값을 그대로 가져다 쓴다.
        if(Param.AutoCal == "1"){
            Param.Term = core.GetAvrTerm()
            Param.Cycle = core.GetAvrCycle()
            core.UpDateConfigParam(info: Param)
        }
        
       // 달력 디스플레이
       CalendarDisplay()
    
    }
    
    // 이미지에 버튼 효과를 주기
    func CreateImg2Btn()
    {
        NextMonthBtn.isUserInteractionEnabled = true
        NextMonthBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("GotoNextMonth"))))
        BeforMonthBtn.isUserInteractionEnabled = true
        BeforMonthBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action:Selector(("GotoBeforeMonth"))))
    }
    
    // 날짜 버튼을 배열로 만들어 정렬하기
    func SetDayBtns()
    {
        // 버튼 아이디를 기준으로 날짜 버튼 저장
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
        
        // 아이디 기준으로 버튼 정렬
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
        
        // 사랑일 배경색을 파란색으로 변경
        for i in result{
            let subString = i.loveDay.components(separatedBy: "-")
            if subString[0] == Param.CurYear && subString[1] == Param.CurMonth{
                let Day : Int = Int(subString[2])!
                let img : UIImage = UIImage(named : "heartStk@1")!
                DayBtns[Day+firstIndex - 2].setBackgroundImage(img, for: UIControl.State.normal)
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
        
        // 선택된 달을 기준으로 시작일과 마지막일을 기준으로 생리 정보를 디스플레이 한다.
        for i in result {
            let startDay = i.startDay.components(separatedBy: "-")
            let endDay = i.endDay.components(separatedBy: "-")
            // 시작일이 선택된 달에 포함이 되는 경우
            print(i.startDay + " ~ " + i.endDay)
            if(startDay[0] == Param.CurYear && startDay[1] == Param.CurMonth){
                // 시작일과 마지막일 간의 사이 간격을 구하가.
                let days = core.GetIntervalDays(startDay: i.startDay, endDay: i.endDay)
                let start = Int(startDay[2])! + firstIndex - 2
                let end = start + days
                for k in start...end{
                    if(k >= 0 && k < DayBtns.count){
                        //DayBtns[k].backgroundColor = UIColor.yellow
                        DayBtns[k].setTitleColor(.red, for:.normal)
                    }
                }
            }
            // 마지막일이 선택된 달에 포함이 되는 경우
            if(endDay[0] == Param.CurYear && endDay[1] == Param.CurMonth){
                // 시작일과 마지막일 간의 사이 간격을 구하가.
                let days = core.GetIntervalDays(startDay: i.startDay, endDay: i.endDay)
                let start = Int(endDay[2])! + firstIndex - 2 - days
                let end = Int(endDay[2])! + firstIndex - 2
                for k in start...end{
                    if(k >= 0 && k < DayBtns.count){
                        //DayBtns[k].backgroundColor = UIColor.yellow
                        DayBtns[k].setTitleColor(.red, for:.normal)
                    }
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
            // 초기화
            let img : UIImage? = nil
            v.backgroundColor = nil
            v.setBackgroundImage(img, for: UIControl.State.normal)
            v.setTitleColor(UIColor.black, for: UIControl.State.normal)
            
            // 텍스트 생성
            let pos = (v.restorationIdentifier) ?? ""
            var Index : Int = Int(pos)!
            Index += 1
            if(Index >= firstIndex && Index < firstIndex + NumDays){
                let DayString = String(Index - firstIndex + 1)
                v.setTitle(DayString, for: UIControl.State.normal)
            }
            else{
                let DayString = ""
                v.setTitle(DayString, for: UIControl.State.normal)
            }
        }
        
       
        // 사랑일 디스플레이
        OnDisplayLoveDay()
        
        // 생리일 디스플레이.
        OnDisplayTheDay()
        
        // 예정일 디스플레이
        PreTheDayDisplay()
        
        // 현재 선택된 날에 대한 디스플레이
        MarkCurDay()
        
        
    }
    
    func PreTheDayDisplay()
    {
        var preTheDay : [String] = []
        preTheDay = core.GetPreTheDay(info: Param)
        if preTheDay.count == 2{
            let firstIndex = core.GetFirstDay(info: Param)
            let NumDays = core.GetNumDays(info: Param)
            
            let PreStart = preTheDay[0].components(separatedBy: "-")
            let PreEnd = preTheDay[1].components(separatedBy: "-")
            
            var start : Int = 0
            var end : Int = 0
            
            var dist = core.GetIntervalDays(startDay: preTheDay[0], endDay: preTheDay[1])
            if PreStart[0] == Param.CurYear && PreStart[1] == Param.CurMonth{
                start = Int(PreStart[2])! + firstIndex - 2
                end = start + dist
                for k in start...end{
                    if k >= firstIndex && k <= firstIndex + NumDays{
                         DayBtns[k].setTitleColor(.orange, for:.normal)
                    }
                }
            }
            
            if PreEnd[0] == Param.CurYear && PreEnd[1] == Param.CurMonth{
                end = Int(PreEnd[2])! + firstIndex - 2
                start = end - dist
                for k in start...end{
                    if k >= firstIndex - 1 && k <= firstIndex + NumDays{
                        DayBtns[k].setTitleColor(.orange, for:.normal)
                    }
                }
            }
        }
        
        // 가임기...
        var PregDay : [String] = []
        PregDay = core.GetPregDay(info: Param)
        if PregDay.count == 2{
            let firstIndex = core.GetFirstDay(info: Param)
            let NumDays = core.GetNumDays(info: Param)
            
            let PregStart = PregDay[0].components(separatedBy: "-")
            let PregEnd = PregDay[1].components(separatedBy: "-")
            
            var start : Int = 0
            var end : Int = 0
            var dist = core.GetIntervalDays(startDay: PregDay[0], endDay: PregDay[1])
            if PregStart[0] == Param.CurYear && PregStart[1] == Param.CurMonth{
                start = Int(PregStart[2])! + firstIndex - 2
                end = start + dist
                for k in start...end{
                    if k >= firstIndex && k <= firstIndex + NumDays{
                        DayBtns[k].setTitleColor(.purple, for:.normal)
                    }
                }
            }
            
            if PregEnd[0] == Param.CurYear && PregEnd[1] == Param.CurMonth{
                end = Int(PregEnd[2])! + firstIndex - 2
                start = end - dist
                for k in start...end{
                    if k >= firstIndex - 1 && k <= firstIndex + NumDays{
                        DayBtns[k].setTitleColor(.purple, for:.normal)
                    }
                }
            }
        }
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
                //v.backgroundColor = UIColor.red
                v.setTitleColor(.blue, for: .normal)
                
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
    
    @IBAction func GoToHome(_ sender: Any) {
        core.GetTodayInfo(dayinfo: Param)
        CalendarDisplay()
    }
}

