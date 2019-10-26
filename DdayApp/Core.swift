//
//  Core.swift
//  DdayApp
//
//  Created by hyunwoo jung on 26/10/2019.
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


class Core
{
    var curYear : Int = 0
    var curMonth : Int = 0
    var CurDay : Int = 0
    
    // current time
    func GetTime(type : String)-> String{
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
    
    func OnInit(){
        let year : String = GetTime(type: "year")
        let month : String = GetTime(type: "month")
        let day : String = GetTime(type: "day")
        
        curYear = Int(year)!
        curMonth = Int(month)!
        CurDay = Int(day)!
    }
    
    func SetBeforeMonth(){
        let range = curMonth - 1
        if(range <= 0){
            curYear = curYear - 1
            curMonth = 12 - range
        }
        else{
            curMonth = range
        }
    }
    
    func SetNextMonth(){
        let range = curMonth + 1
        if(range > 12){
            curYear = curYear + 1
            curMonth = range - 12
        }
        else{
            curMonth = range
        }
    }
    
    func SetYear(time : Int){
        curYear = time
    }
    
    func GetYear()->Int{
     
        return curYear;
    }
    
    func SetMonth(time : Int){
        curMonth = time
    }
    
    func GetMonth()->Int{
        return curMonth
    }
    
    func GetCurTimeText()->String{
        let MonthIndex = Month(rawValue: curMonth)
        let MonthText : String = (MonthIndex?.Description())!
        return MonthText + String(curYear)
    }
    
    func GetWeek()->String{
        let cal = Calendar(identifier: .gregorian)
        let now = Date()
        let comps = cal.dateComponents([.weekday], from: now)
        
        let WeekIndex = Week(rawValue: comps.weekday!)
        let WeekText : String = (WeekIndex?.Description())!
        return WeekText
    }
    
    func findToFirst() -> Int{
        let str = String(curYear) + "-" + String(curMonth)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let date = formatter.date(from: str)
        let weekday = Calendar.current.component(.weekday, from: date!)
        return weekday
    }
    
    func GetNumDays()->Int{
        let dateComponents = DateComponents(year : curYear, month : curMonth)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)
        let numdays = range?.count
        return numdays!
    }
    
    func GetDayTable()->Array<String>{
        let startPos = findToFirst()
        let numDays = GetNumDays()
        var str : [String] = []
        
        for _ in 1..<startPos{
            str.append(" ")
        }
        
        for i in 1...numDays{
            str.append(String(i))
        }
        
        for _ in 0..<40-startPos-numDays{
            str.append(" ")
        }
        
        return str
    }
    
}
