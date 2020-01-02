//
//  Core.swift
//  DdayApp
//
//  Created by hyunwoo jung on 26/10/2019.
//  Copyright © 2019 EMMA. All rights reserved.
//

import Foundation

class Core
{
    // 캘린더 클래스
    var calendar = CalendarClass()
    
    // 디비 클래스
    var DBCtrl = DBClass()
    
    // 디비 생성
    func CreateDB(){
        DBCtrl.CreateDB()
    }
    
    // 설정 파라미터 가져오기
    func GetGetConfigParam(info : ConfigDataParam){
        DBCtrl.SetParameters(info: info)
        
        // 현재 시간 또는 지정된 시간 정보를 가져옴
        if(info.bSetCurTime == "1"){
            GetTodayInfo(dayinfo: info)
            
        }
        else{
            info.bSetCurTime = "1"
            UpDateConfigParam(info: info)
        }
        
        // 기간 주기 설정이 자동 일경우 평균값을 계산하여 갱신한다.
        // 입력된 데이터가 2개보다 작을 경우에는 디비에 설정된 값을 그대로 가져다 쓴다.
        if(info.AutoCal == "1"){
            info.Term = GetAvrTerm()
            info.Cycle = GetAvrCycle()
            UpDateConfigParam(info: info)
        }
    }
    
    // 현재의 날짜 정보 가져오기
    func GetTodayInfo(dayinfo : ConfigDataParam){
        calendar.GetTodayInfo(dayinfo: dayinfo)
    }
    
    // 캘린더 텍스트 가져오기
    func GetCalendarText(info : ConfigDataParam)->String{
        return calendar.GetCurTimeText(year: info.CurYear, month: info.CurMonth)
    }
    
    // 캘린더 스트링 가져오기
    func GetDateString(info : ConfigDataParam)->String{
        return calendar.GetDateString(info: info)
    }
    // 다음달 선택 적용
    func SetNextMonth(info : ConfigDataParam){
        calendar.SetNextMonth(info: info)
    }
    
    // 이전달 선택 적용
    func SetBeforeMonth(info : ConfigDataParam){
       calendar.SetBeforeMonth(info: info)
    }
    
    // 입력된 달의 첫 날의 위치 구하기
    func GetFirstDay(info : ConfigDataParam)->Int{
       return calendar.findToFirst(year: info.CurYear, month: info.CurMonth)
    }
    
    // 입력된 달의 총 날의 수 구하기
    func GetNumDays(info : ConfigDataParam)->Int{
        return calendar.GetNumDays(strYear: info.CurYear, strMonth: info.CurMonth)
    }
    
    // 환경 변수 업데이트하기
    func UpDateConfigParam(info : ConfigDataParam){
        DBCtrl.UpDateConfigDBData(info: info)
    }
    
    // 생리 시작일 저장
    func SetStartDay(info : ConfigDataParam){
        let startDay = calendar.GetDateString(info: info)
        let endDay = calendar.GetNewDay(info: info)
        DBCtrl.SetStartDay(startDay: startDay, endDay: endDay, term: info.Term, cycle: info.Cycle)
        print(startDay)
        print(endDay)
    }
    
    // 사랑일인지 체크하기
    func IsLoveDay(loveDayInfo : TheLoveDayInfo, info : ConfigDataParam)->Bool{
        let subString = loveDayInfo.loveDay.components(separatedBy: "-")
        if subString[0] == info.CurYear{
            if subString[1] == info.CurMonth{
                if subString[2] == info.CurDay{
                    return true
                }
            }
        }
        return false
    }
    
    // 생리 일정에 포함되어지는가?
    func IsTheDay(theDayInfo : TheDayInfo, info : ConfigDataParam)->Bool{
        let curDataInfo = calendar.GetDateString(info: info)
        let a = calendar.GetIntervalDays(StartDay: theDayInfo.startDay, EndDay: curDataInfo)
        let b = calendar.GetIntervalDays(StartDay: curDataInfo, EndDay: theDayInfo.endDay)
        
        if( a >= 0 && b >= 0){
            return true
        }
        
        return false
    }
    
    
    // 생리 마지막일 저장
    func SetEndDay(info : ConfigDataParam){
        
    }
    
    // 생리 일정 정보 가져오기 ... 시작일, 마지막일, 기간, 주기
    func GetTheDayDB()->Array<TheDayInfo>{
        var TheDays : [TheDayInfo] = []
        TheDays = DBCtrl.GetTheDayDB()
        
        // sort
        var distindex : [Int] = []
        let refDay = "1980-1-1"
        for i in TheDays{
           let dist =  GetIntervalDays(startDay: refDay, endDay: i.startDay)
            distindex.append(dist)
        }
        
        distindex.sort()
        distindex.reverse()
        var SortTheDays : [TheDayInfo] = []
        for i in distindex{
            for k in TheDays{
                let dist =  GetIntervalDays(startDay: refDay, endDay: k.startDay)
                if dist == i{
                    SortTheDays.append(k)
                }
            }
        }
        
        return SortTheDays
    }
    
    // 사랑일 정보 가져오기
    func GetLoveDayDB()->Array<TheLoveDayInfo>{
        return DBCtrl.GetLoveDayDB()
    }
    
    // 두 날의 간격
    func GetIntervalDays(startDay : String, endDay : String)->Int{
        return calendar.GetIntervalDays(StartDay: startDay, EndDay: endDay)
    }
    
    // 사랑일 저장
    func SetLoveDay(info : ConfigDataParam){
        let loveDay = calendar.GetDateString(info: info)
        DBCtrl.SetLoveDay(loveDay: loveDay)
    }

    // 사랑일 제거
    func DeleteLoveDay(info : ConfigDataParam){
        let loveDay = calendar.GetDateString(info: info)
        DBCtrl.DeleteLoveDay(loveDay: loveDay)
    }
    
    // 생리 정보 업데이트
    func UpDateTheDay(info : TheDayInfo, filt : Int){
        DBCtrl.UpDateTheDayDBData(info: info, filt: filt)
    }
    
    // 생리 정보 삭제
    func DeleteTheDay(info : TheDayInfo){
        DBCtrl.DeleteTheDay(theDay: info)
    }
    
    // 평균 기간 계산
    // 계산할 데이터가 없을 경우 이전 정보값으로 변경한다.
    func GetAvrTerm(info : ConfigDataParam)->String{
        var term = 0
        
        var TheDays : [TheDayInfo] = []
        TheDays = GetTheDayDB()
        
        if TheDays.count > 2 {
            for i in TheDays{
                term = term + Int(i.term)!
            }
            
            term = term/TheDays.count
        }
        else{
            term = Int(info.Term)!
        }
        return String(term)
    }
    
    // 평균 기간 계산
    func GetAvrTerm()->String{
        var term = 0
        
        var TheDays : [TheDayInfo] = []
        TheDays = GetTheDayDB()
    
        if TheDays.count > 2 {
            for i in TheDays{
                term = term + Int(i.term)!
            }
            
            term = term/TheDays.count
        }
        return String(term)
    }
    
    // 평균 주기 계산
    func GetAvrCycle()->String{
        var cycle = 0
        
        var TheDays : [TheDayInfo] = []
        TheDays = GetTheDayDB()
        
        if TheDays.count > 2 {
            for i in 0..<TheDays.count - 1{
                cycle = cycle + GetIntervalDays(startDay: TheDays[i+1].startDay, endDay: TheDays[i].startDay)
                cycle = cycle / TheDays.count
            }
        }

        return String(cycle)
    }
    
    // 평균 주기 계산
    // 데이터가 충분하지 않으면 설정값을 기준으로 한다.
    func GetAvrCycle(info : ConfigDataParam)->String{
        var cycle = 0
        
        var TheDays : [TheDayInfo] = []
        TheDays = GetTheDayDB()
        
        if TheDays.count > 2 {
            for i in 0..<TheDays.count - 1{
                cycle = cycle + GetIntervalDays(startDay: TheDays[i+1].startDay, endDay: TheDays[i].startDay)
                cycle = cycle / TheDays.count
            }
        }
        else{
            cycle = Int(info.Cycle)!
        }
        return String(cycle)
    }
    
    // 예상일 계산하기.
    func GetPreTheDay(info : ConfigDataParam)->Array<String>{
        var PreTheDay : [String] = []
        var thedays : [TheDayInfo] = []
        thedays = GetTheDayDB()
        
        if thedays.count > 0 {
            var PreStart : String = ""
            var PreEnd : String = ""
            if info.AutoCal == "1" {
                let avrCycle = GetAvrCycle()
                let avrTerm = GetAvrTerm()
                if avrCycle == "0" || avrTerm == "0"{
                    PreStart = calendar.GetNextDay(start: thedays[0].startDay, after: info.Cycle)
                    PreEnd = calendar.GetNextDay(start: PreStart, after: info.Term)
                }
                else{
                    PreStart = calendar.GetNextDay(start: thedays[0].startDay, after: avrCycle)
                    PreEnd = calendar.GetNextDay(start: PreStart, after: avrTerm)
                }
            }
            else{
               PreStart = calendar.GetNextDay(start: thedays[0].startDay, after: info.Cycle)
               PreEnd = calendar.GetNextDay(start: PreStart, after: info.Term)
            }
            PreTheDay.append(PreStart)
            PreTheDay.append(PreEnd)
        }
        
        return PreTheDay
    }
    
    func GetPregDay(info : ConfigDataParam)->Array<String>{
        var PreTheDay : [String] = []
        var PregDay : [String] = []
        PreTheDay = GetPreTheDay(info: info)
        
        if PreTheDay.count == 2{
            let PregStart = calendar.GetNextDay(start: PreTheDay[0], after: -17)
            let PregEnd = calendar.GetNextDay(start: PreTheDay[0], after: -11)
            PregDay.append(PregStart)
            PregDay.append(PregEnd)
        }
        
        return PregDay
    }
}
