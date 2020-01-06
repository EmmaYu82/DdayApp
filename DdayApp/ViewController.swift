//
//  ViewController.swift
//  DdayApp
//
//  Created by EMMA on 09/09/2019.
//  Copyright © 2019 EMMA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var NextMonthBtn: UIImageView!     // 다음 달 선택
    @IBOutlet weak var BeforMonthBtn: UIImageView!    // 이전 달 선택
    @IBOutlet weak var TimeInfo: UILabel!             // 달력 제목
    @IBOutlet weak var SelectTheDayBtn: UIButton!     // 달력 정보 업데이트
    
    @IBOutlet weak var sideBarbutton: UIBarButtonItem!
    
    var DayBtns : [UIButton] = []  // 날짜 버튼 배열
    let core = Core()              // 주처리 클래스
    var Param = ConfigDataParam()  // 환경 설정 파라미터
    
    //////////////////////////////
    /// 시작\
    //////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
      
        CreateImg2Btn()                         // 이미지에 버튼 이벤트 효과 주기
        SetDayBtns()                            // 날짜 버튼을 배열로 저장
        core.CreateDB()                         // 데이터 베이스 연결
        core.GetGetConfigParam(info: Param)     // 환경 정보 가져오기
        CalendarDisplay()                       // 달력 디스플레이
        
        if let revealVC = self.revealViewController(){
        self.sideBarButton.target = revealVC
        self.sideBarButton.action = #selector(revealVC.revealToggle(_:))}    }
    
    /////////////////////////////////
    // 이미지에 버튼 이벤트 만들기
    /////////////////////////////////
    func CreateImg2Btn()
    {
        // 다음 달 선택
        NextMonthBtn.isUserInteractionEnabled = true
        NextMonthBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("GotoNextMonth"))))
        
        // 이전 달 선택
        BeforMonthBtn.isUserInteractionEnabled = true
        BeforMonthBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action:Selector(("GotoBeforeMonth"))))
    }
    
    /////////////////////////////////////////////////////////////
    // 날짜 버튼을 배열로 저장하여 사용하기
    // 생성되는 버튼의 아이디를 참조하고, 날짜에 해당하는 버튼만 배열에 추가한다.
    // 배열로 담긴 배열을 아이디를 기준으로 재정렬한다.
    /////////////////////////////////////////////////////////////
    func SetDayBtns()
    {
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
        
        let Temp = DayBtns
        for i in Temp{
            let s : String = (i.restorationIdentifier) ?? ""
            let Index = Int(s) ?? -1
            DayBtns[Index] = i
        }
    }
    
    ///////////////////////////////////////////////
    // 다음 달을 선택하였을 경우 환경 정보 및 달력 업데이트.
    ///////////////////////////////////////////////
    @objc func GotoNextMonth()
    {
        core.SetNextMonth(info : Param)
        CalendarDisplay()
    }
    
    ////////////////////////////////////////////
    // 이전 달을 선택하였을 경우 환경 정보 및 달력 업데이트
    ////////////////////////////////////////////
    @objc func GotoBeforeMonth()
    {
        core.SetBeforeMonth(info : Param)
        CalendarDisplay()
    }
    
    //////////////////////////////////////////////////////////
    // 사랑일 디스플레이
    // 사랑일 정보를 로드하여 현재 디스플레이되는 달력에 해당하는 날이 있을 경우
    // 해당 버튼을 업데이트.
    //////////////////////////////////////////////////////////
    func OnDisplayLoveDay()
    {
        var result : [TheLoveDayInfo] = []
        result = core.GetLoveDayDB()
        
        let firstIndex = core.GetFirstDay(info: Param)
        
        for i in result{
            let subString = i.loveDay.components(separatedBy: "-")
            if subString[0] == Param.CurYear && subString[1] == Param.CurMonth{
                let Day : Int = Int(subString[2])!
                let img : UIImage = UIImage(named : "heartStk@1")!
                DayBtns[Day+firstIndex - 2].setBackgroundImage(img, for: UIControl.State.normal)
            }
        }
    }
    
    /////////////////////////////////////////////////////
    // 생리일 디스플레이
    // 데이터 베이스에서 얻어온 생리일 정보를 기준으로 현재 디스플레이되는
    // 달력에 포함이 되는 날짜의 버튼을 업데이트.
    // 시작일과 마지막일에 포함되는 날 모두 디스플레이
    /////////////////////////////////////////////////////
    func OnDisplayTheDay()
    {
        var result : [TheDayInfo] = []
        result = core.GetTheDayDB()
        let firstIndex = core.GetFirstDay(info: Param)
        for i in result {
            let startDay = i.startDay.components(separatedBy: "-")
            let endDay = i.endDay.components(separatedBy: "-")
           
            // 시작일을 기준으로 마지막일까지 버튼의 글자의 색을 변경
            if(startDay[0] == Param.CurYear && startDay[1] == Param.CurMonth){
                let days = core.GetIntervalDays(startDay: i.startDay, endDay: i.endDay)
                let start = Int(startDay[2])! + firstIndex - 2
                let end = start + days
                for k in start...end{
                    if(k >= 0 && k < DayBtns.count){
                        DayBtns[k].backgroundColor = UIColor.yellow
                        DayBtns[k].setTitleColor(.red, for:.normal)
                    }
                }
            }
            
            // 마지막일을 기준으로 시작일까지 버튼의 글자의 색을 변경
            if(endDay[0] == Param.CurYear && endDay[1] == Param.CurMonth){
                let days = core.GetIntervalDays(startDay: i.startDay, endDay: i.endDay)
                let start = Int(endDay[2])! + firstIndex - 2 - days
                let end = Int(endDay[2])! + firstIndex - 2
                for k in start...end{
                    if(k >= 0 && k < DayBtns.count){
                        DayBtns[k].backgroundColor = UIColor.yellow
                        DayBtns[k].setTitleColor(.red, for:.normal)
                    }
                }
            }
        }
    }
    
    /////////////////////////////////////////////////////////
    // 달력 디스플레이
    // 선택된 달에 대한 달력을 업데이트하고, 각 버튼의 속성을 초기화한다.
    // 업데이트 이후, 사랑일, 생리일, 사랑일, 예정일 등의 정보를 업데이트한다.
    /////////////////////////////////////////////////////////
    func CalendarDisplay()
    {
        // 달력의 제목 타이틀을 변경
        TimeInfo.text = core.GetCalendarText(info : Param)
        
        
        let firstIndex : Int = core.GetFirstDay(info: Param)
        let NumDays = core.GetNumDays(info: Param)
        
        // 버튼의 모든 속성을 변경하고,
        // 현재 디스플레이되는 달의 날에 해당하는 버튼의 글자를 변경하여
        // 디스플레이함.
        for v : UIButton in DayBtns{
            let img : UIImage? = nil
            v.backgroundColor = nil
            v.setBackgroundImage(img, for: UIControl.State.normal)
            v.setTitleColor(UIColor.black, for: UIControl.State.normal)
        
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
        
       
        OnDisplayLoveDay()    // 사랑일 업데이트
        OnDisplayTheDay()     // 생리일 업데이트
        PreTheDayDisplay()    // 예정일 업데이트
        MarkCurDay()          // 현재 선택된 날에 대한 디스플레이
    }
    
    /////////////////////////////////////
    // 예정일에 대한 정보 업데이트
    /////////////////////////////////////
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
            
            let dist = core.GetIntervalDays(startDay: preTheDay[0], endDay: preTheDay[1])
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
            let dist = core.GetIntervalDays(startDay: PregDay[0], endDay: PregDay[1])
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
    
    ///////////////////////////////
    // 현재 선택된 날짜에 대한 업데이트
    // 선택된 날이 현재 디스플레이되는 달력의 범위내에서 수정 및 추가
    // 버튼이 활성화 되도록 한다.
    ///////////////////////////////
    func MarkCurDay()
    {
        let firstIndex : Int = core.GetFirstDay(info: Param)
        let ToDay : Int = Int(Param.CurDay)!
        let nDayIndex = firstIndex + ToDay - 1
        let dayNums = core.GetNumDays(info: Param)
        
        SelectTheDayBtn.isHidden = true
        
        for v : UIButton in DayBtns{
            let pos = (v.restorationIdentifier) ?? ""
            var Index : Int = Int(pos)!
            Index += 1
            if(Index == nDayIndex && Index < firstIndex + dayNums){
                //v.backgroundColor = UIColor.red
                v.setTitleColor(.blue, for: .normal)
                
                SelectTheDayBtn.isHidden = false
                
                core.UpDateConfigParam(info: Param)
            }
        }
    }
    
    /////////////////////////////////////////////
    // 날짜 버튼을 눌렀을 때...
    // 현재 디스플레이 되는 날의 범위가 아니면 예외처리.
    /////////////////////////////////////////////
    @IBAction func OnClickDayBtns(_ sender: UIButton) {
        let SelIndex = (sender.restorationIdentifier) ?? ""
        var index = Int(SelIndex)!
        index += 1
        let firstIndex : Int = core.GetFirstDay(info: Param)
        let dayNums = core.GetNumDays(info: Param)
        
        if( index >= firstIndex && index < firstIndex + dayNums){
            Param.CurDay = String(format : "%02d", index - firstIndex + 1)
            CalendarDisplay()
        }
    }
    
    //////////////////////////////////////////
    // 현재 시간을 기준으로 달력을 업데이트.
    //////////////////////////////////////////
    @IBAction func GoToHome(_ sender: Any) {
        core.GetTodayInfo(dayinfo: Param)
        CalendarDisplay()
    }
    @IBAction func OnClickAddData(_ sender: Any) {
        Param.bSetCurTime = "0"
        core.UpDateConfigParam(info: Param)
    }
}
