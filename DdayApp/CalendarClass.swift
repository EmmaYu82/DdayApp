//
//  CalenderClass.swift
//  DdayApp
//
//  Created by hyunwoo jung on 09/11/2019.
//  Copyright © 2019 EMMA. All rights reserved.
//

import Foundation

enum Week : Int {
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    func Description()->String{
        switch self {
        case .Sunday:
            return "SunDay"
        case .Monday:
            return "MonDay"
        case .Tuesday:
            return "TuesDay"
        case .Wednesday:
            return "WednesDay"
        case .Thursday:
            return "ThursDay"
        case .Friday:
            return "FriDay"
        case .Saturday:
            return "SaturDay"
        }
    }
}


enum Month : Int{
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    
    func Description()->String{
        switch self {
        case .january:
            return "Jan,"
        case .february:
            return "Feb,"
        case .march:
            return "Mar,"
        case .april:
            return "Apr,"
        case .may:
            return "May,"
        case .june:
            return "Jun,"
        case .july:
            return "Jul,"
        case .august:
            return "Aug,"
        case .september:
            return "Sep,"
        case .october:
            return "Oct,"
        case .november:
            return "Nov,"
        case .december:
            return "Dec,"
        }
    }
}


class CalendarClass{
    
    // 현재 시간 정보
    func GetCurDate(type : String)-> String{
        let formatter = DateFormatter()
        
        switch type {
        case "year":
            formatter.dateFormat = "yyyy"
        case "month":
            formatter.dateFormat = "MM"
        case "day":
            formatter.dateFormat = "dd"
        case "hour":
            formatter.dateFormat = "HH"
        default:
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        
        return formatter.string(from: Date())
    }
    
    func GetTodayInfo(dayinfo : ConfigDataParam){
        dayinfo.CurYear = GetCurDate(type: "year")
        dayinfo.CurMonth = GetCurDate(type: "month")
        dayinfo.CurDay = GetCurDate(type: "day")
    }
    
    func GetDateString(info : ConfigDataParam)->String{
        return info.CurYear + "-" + info.CurMonth + "-" + info.CurDay;
    }
    
    func GetNewDay(info : ConfigDataParam)->String{
        var newDay = info
        let dist = Int(info.Cycle)!
        let toDay = Int(info.CurDay)!
        let NumDay : Int = GetNumDays(strYear: info.CurYear, strMonth: info.CurMonth)
        
        if(toDay + dist > NumDay){
            //newDay.CurMonth
            SetNextMonth(info: newDay)
            let nextMonthDays = GetNumDays(strYear: newDay.CurYear, strMonth: newDay.CurMonth)
            if(toDay + dist - NumDay > nextMonthDays){
                let next2MontDays = SetNextMonth(info: newDay)
                newDay.CurDay = String(toDay + dist - NumDay - nextMonthDays)
            }
            else{
                newDay.CurDay = String(toDay + dist - NumDay)
            }
        }
        else{
            newDay.CurDay = String(toDay + dist)
        }
        
        return newDay.CurYear + "-" + newDay.CurMonth + "-" + newDay.CurDay
    }
    
    // 현재의 요일 구하기
    func GetWeek()->String{
        let cal = Calendar(identifier: .gregorian)
        let now = Date()
        let comps = cal.dateComponents([.weekday], from: now)
        
        let WeekIndex = Week(rawValue: comps.weekday!)
        let WeekText : String = (WeekIndex?.Description())!
        return WeekText
    }
    
    // 선택된 달의 시작일
    func findToFirst(year : String, month : String) -> Int{
        let str = year + "-" + month
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let date = formatter.date(from: str)
        let weekday = Calendar.current.component(.weekday, from: date!)
        return weekday
    }
    
    // 선택된 달의 날의 수 구하기
    func GetNumDays(year : Int, month : Int)->Int{
        let dateComponents = DateComponents(year : year, month : month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)
        let numdays = range?.count
        return numdays!
    }
    
    func GetNumDays(strYear : String, strMonth : String)->Int{
        let Year = Int(strYear)!
        let Month = Int(strMonth)!
        return GetNumDays(year: Year, month: Month)
    }
    
    // 날짜 정보 텍스트 만들기
    func GetCurTimeText(year : String, month : String)->String{
        let nMonth = Int(month)
        let MonthIndex = Month(rawValue: nMonth!)
        let MonthText : String = (MonthIndex?.Description())!
        return MonthText + String(year)
    }
    
    // SetNextMonth
    func SetNextMonth(info : ConfigDataParam){
        var nYear : Int = Int(info.CurYear)!
        var nMonth : Int = Int(info.CurMonth)!
        if nMonth == 12{
            nYear += 1
            nMonth = 1
        }
        else{
            nMonth += 1
        }
        info.CurYear = String(nYear)
        info.CurMonth = String(nMonth)
    }
    
    func SetBeforeMonth(info : ConfigDataParam){
        var nYear : Int = Int(info.CurYear)!
        var nMonth : Int = Int(info.CurMonth)!
        if nMonth == 1{
            nYear -= 1
            nMonth = 12
        }
        else{
            nMonth -= 1
        }
        info.CurYear = String(nYear)
        info.CurMonth = String(nMonth)
    }
}
