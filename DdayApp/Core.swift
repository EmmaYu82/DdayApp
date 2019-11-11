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
    var calendar = CalendarClass()
    var DBCtrl = DBClass()
    //var configParam = ConfigDataParam()
    
    func CreateDB(){
        DBCtrl.CreateDB()
    }
    
    func GetGetConfigParam(info : ConfigDataParam){
        DBCtrl.SetParameters(info: info)
    }
    
    func GetTodayInfo(dayinfo : ConfigDataParam){
        calendar.GetTodayInfo(dayinfo: dayinfo)
    }
    
    func GetCalendarText(info : ConfigDataParam)->String{
        return calendar.GetCurTimeText(year: info.CurYear, month: info.CurMonth)
    }
    
    func GetDateString(info : ConfigDataParam)->String{
        return calendar.GetDateString(info: info)
    }
    // Set Next Month
    func SetNextMonth(info : ConfigDataParam){
        calendar.SetNextMonth(info: info)
    }
    
    // Set Before Month
    func SetBeforeMonth(info : ConfigDataParam){
       calendar.SetBeforeMonth(info: info)
    }
    
    func GetFirstDay(info : ConfigDataParam)->Int{
       return calendar.findToFirst(year: info.CurYear, month: info.CurMonth)
    }
    
    func GetNumDays(info : ConfigDataParam)->Int{
        return calendar.GetNumDays(strYear: info.CurYear, strMonth: info.CurMonth)
    }
    
    func UpDateConfigParam(info : ConfigDataParam){
        DBCtrl.UpDateConfigDBData(info: info)
    }
    
    func SetStartDay(info : ConfigDataParam){
        var startDay = calendar.GetDateString(info: info)
        let endDay = calendar.GetNewDay(info: info)
        DBCtrl.SetStartDay(startDay: startDay, endDay: endDay, term: info.Term, cycle: info.Cycle)
        print(startDay)
        print(endDay)
    }
    
    func SetEndDay(info : ConfigDataParam){
        
    }
    
    func GetTheDayDB()->Array<TheDayInfo>{
        
        return DBCtrl.GetTheDayDB()
    }
    
    func GetLoveDayDB()->Array<TheLoveDayInfo>{
        return DBCtrl.GetLoveDayDB()
    }
    
    func SetLoveDay(info : ConfigDataParam){
        DBCtrl.SetLoveDay(info: info)
    }
}
