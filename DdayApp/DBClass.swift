//
//  DBClass.swift
//  DdayApp
//
//  Created by hyunwoo jung on 09/11/2019.
//  Copyright © 2019 EMMA. All rights reserved.
//

import Foundation

// config Data Param
class ConfigDataParam
{
    var bSetCurTime : String  = "1"
    var CurYear : String = "2019"
    var CurMonth : String = "11"
    var CurDay : String = "9"
    var Term : String = "10"
    var Cycle : String = "28"
    var AutoCal : String = "0"
    var Pass : String = "1234"
}

class TheDayInfo
{
    var startDay : String = ""
    var endDay : String = ""
    var term : String = ""
    var cycle : String = ""
}

class TheLoveDayInfo
{
    var loveDay : String = ""
    var year : String = ""
    var month : String = ""
    var day : String = ""
}

class DBClass
{
    var TheDayDBPath : String = ""
    var LoveDayDBPath : String = ""
    var ConfigDBPath : String = ""
    let configParam = ConfigDataParam()
    
    // 데이터 베이스 생성
    func CreateDB(){
        let filemgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as String
        
        TheDayDBPath = docsDir.appending("/TheDayDB009.db")
        LoveDayDBPath = docsDir.appending("/LoveDayDB002.db")
        ConfigDBPath = docsDir.appending("/ConfigDB044.db")
        
        // 생리
        if !filemgr.fileExists(atPath: TheDayDBPath) {
            let contactDB = FMDatabase(path: TheDayDBPath)
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, START TEXT, END TEXT, TERM TEXT, CYCLE TEXT)"
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                print("Error \(contactDB.lastErrorMessage())")
            }
        }
        
        // 사랑일
        if !filemgr.fileExists(atPath: LoveDayDBPath) {
            let contactDB = FMDatabase(path: LoveDayDBPath)
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, LOVEDAY TEXT)"
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                print("Error \(contactDB.lastErrorMessage())")
            }
        }
        
        // 환경 설정 정보
        if !filemgr.fileExists(atPath: ConfigDBPath) {
            let contactDB = FMDatabase(path: ConfigDBPath)
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, CONFIG TEXT, TERM TEXT, CYCLE TEXT, CURYEAR TEXT, CURMONTH TEXT, CURDAY TEXT, CURTIME TEXT, AUTOCAL TEXT, PASS TEXT)"
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                print("Error \(contactDB.lastErrorMessage())")
            }
            
            SaveConFigDBData(info : configParam)
        }
    }
    
    
    // 생리 정보 저장하기
    func SetStartDay(startDay : String, endDay : String, term : String, cycle : String){
        let contactDB = FMDatabase(path: TheDayDBPath)
        if contactDB.open(){
            let insertSQL = "INSERT INTO CONTACTS (start, end, term, cycle) VALUES ('\(startDay)', '\(endDay)', '\(term)', '\(cycle)')"
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [0])
            if !result {
                print("fail")
            } else {
                print("success")
            }
        }
        else{
            print("fail")
        }
    }
    
    
    // 생리 정보 제거
    func DeleteTheDay(theDay : TheDayInfo){
        let contactDB = FMDatabase(path: TheDayDBPath)
        if contactDB.open() {
            let insertSQL = "DELETE FROM CONTACTS WHERE ( start = '\(theDay.startDay)')"
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result {
                print("fail")
                //status.text = "Failed to add contact"
                //print("Error \(contactDB.lastErrorMessage())")
            } else {
                print("success")
                //status.text = "Contact Added"
                //name.text = ""
                //address.text = ""
                //phone.text = ""
            }
            contactDB.close()
        } else {
            print("Error \(contactDB.lastErrorMessage())")
        }
    }
    
    // 선택된 사랑일 제거하기
    func DeleteLoveDay(loveDay : String){
        let contactDB = FMDatabase(path: LoveDayDBPath)
        if contactDB.open() {
            let insertSQL = "DELETE FROM CONTACTS WHERE ( loveDay = '\(loveDay)')"
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result {
                print("fail")
                //status.text = "Failed to add contact"
                //print("Error \(contactDB.lastErrorMessage())")
            } else {
                print("success")
                //status.text = "Contact Added"
                //name.text = ""
                //address.text = ""
                //phone.text = ""
            }
            contactDB.close()
        } else {
            print("Error \(contactDB.lastErrorMessage())")
        }
    }
    
    // 선택된 사랑일 제거하기
    func DeleteLoveDay(info : ConfigDataParam){
         let contactDB = FMDatabase(path: LoveDayDBPath)
        if contactDB.open() {
            let insertSQL = "DELETE FROM CONTACTS WHERE ( curday = '\(info.CurDay)', curmonth = '\(info.CurMonth)')"
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result {
                print("fail")
                //status.text = "Failed to add contact"
                //print("Error \(contactDB.lastErrorMessage())")
            } else {
                print("success")
                //status.text = "Contact Added"
                //name.text = ""
                //address.text = ""
                //phone.text = ""
            }
            contactDB.close()
        } else {
            print("Error \(contactDB.lastErrorMessage())")
        }
    }
    
    // 사랑일 저장하기
    func SetLoveDay(loveDay : String){
        let contactDB = FMDatabase(path: LoveDayDBPath)
        if contactDB.open() {
            let insertSQL = "INSERT INTO CONTACTS (loveDay) VALUES ('\(loveDay)')"
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result {
                print("fail")
                //status.text = "Failed to add contact"
                //print("Error \(contactDB.lastErrorMessage())")
            } else {
                print("success")
                //status.text = "Contact Added"
                //name.text = ""
                //address.text = ""
                //phone.text = ""
            }
            contactDB.close()
        } else {
            print("Error \(contactDB.lastErrorMessage())")
        }
    }
    
    // 사랑일 저장하기
    func SetLoveDay(info : ConfigDataParam){
        let contactDB = FMDatabase(path: LoveDayDBPath)
        if contactDB.open() {
            let insertSQL = "INSERT INTO CONTACTS (curyear, curmonth, curday) VALUES ('\(info.CurYear)', '\(info.CurMonth)', '\(info.CurDay)')"
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result {
                print("fail")
                //status.text = "Failed to add contact"
                //print("Error \(contactDB.lastErrorMessage())")
            } else {
                print("success")
                //status.text = "Contact Added"
                //name.text = ""
                //address.text = ""
                //phone.text = ""
            }
            contactDB.close()
        } else {
            print("Error \(contactDB.lastErrorMessage())")
        }
    }
    
    // 환경 설정 정보 생성
    func SaveConFigDBData(info : ConfigDataParam){
        let contactDB = FMDatabase(path: ConfigDBPath)
        
        let config : String = "config"
        
        if contactDB.open() {
            let insertSQL = "INSERT INTO CONTACTS (config, term, cycle, curyear, curmonth, curday, curtime, autocal, pass) VALUES ('\(config)', '\(info.Term)', '\(info.Cycle)', '\(info.CurYear)','\(info.CurMonth)','\(info.CurDay)', '\(info.bSetCurTime)', '\(info.AutoCal)', '\(info.Pass)')"
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [])
            
            if !result {
                print("fail")
                //status.text = "Failed to add contact"
                //print("Error \(contactDB.lastErrorMessage())")
            } else {
                print("success")
                //status.text = "Contact Added"
                //name.text = ""
                //address.text = ""
                //phone.text = ""
            }
            
            contactDB.close()
        } else {
            print("Error \(contactDB.lastErrorMessage())")
        }
    }
    
    // 환경 설정 정보 업데이트
    func UpDateConfigDBData(info : ConfigDataParam){
        let contactDB = FMDatabase(path: ConfigDBPath)
        let config : String = "config"

        if contactDB.open() {
            let insertSQL = "UPDATE CONTACTS SET config = '\(config)', term = '\(info.Term)', cycle ='\(info.Cycle)', curyear = '\(info.CurYear)', curmonth = '\(info.CurMonth)', curday = '\(info.CurDay)', curtime = '\(info.bSetCurTime)', autocal = '\(info.AutoCal)', pass = '\(info.Pass)' WHERE ? "
            
            let result = contactDB.executeUpdate(insertSQL,withArgumentsIn: [1])
            
            if (result == false) {
                print("fail")
            } else {
                print("success")
            }
            contactDB.close()
        } else {
            print("Error \(contactDB.lastErrorMessage())")
        }
    }
    
    
    // 생리 일정 정보 업데이트
    func UpDateTheDayDBData(info : TheDayInfo, filt : Int){
        let contactDB = FMDatabase(path: TheDayDBPath)
        
        if contactDB.open() {
            var insertSQL : String = ""
            if filt == 0{
                insertSQL = "UPDATE CONTACTS SET start = '\(info.startDay)', end = '\(info.endDay)', term ='\(info.term)', cycle = '\(info.cycle)' WHERE start = '\(info.startDay)'"
            }
            else{
                insertSQL = "UPDATE CONTACTS SET start = '\(info.startDay)', end = '\(info.endDay)', term ='\(info.term)', cycle = '\(info.cycle)' WHERE end = '\(info.endDay)'"
            }
            
            let result = contactDB.executeUpdate(insertSQL,withArgumentsIn: [1])
            
            if (result == false) {
                print("fail")
            } else {
                print("success")
            }
            contactDB.close()
        } else {
            print("Error \(contactDB.lastErrorMessage())")
        }
    }
    
    
    // 사랑일 정보 가져오기
    func GetLoveDayDB()->Array<TheLoveDayInfo>{
        var resultData : [TheLoveDayInfo] = []
        let contactDB = FMDatabase(path: LoveDayDBPath)
        if contactDB.open() {
            let querySQL = "SELECT LOVEDAY FROM CONTACTS ORDER BY LOVEDAY"
            let result: FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            
            if let rs = result{
                
                while rs.next(){
                    let select = TheLoveDayInfo()
                    select.loveDay = rs.string(forColumn: "loveday")!
                    //select.month = rs.string(forColumn: "curmonth")!
                    //select.day = rs.string(forColumn: "curday")!
                    resultData.append(select)
                }
                
            }
            else{
                print("no data")
            }
        }
        else{
            
        }
        return resultData
    }
    
    // 생리 정보 가져오기
    func GetTheDayDB()->Array<TheDayInfo>{
        var resultData : [TheDayInfo] = []
        let contactDB = FMDatabase(path: TheDayDBPath)
        if contactDB.open() {
            let querySQL = "SELECT start, end, term, cycle FROM CONTACTS ORDER BY start"
            let result: FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if let rs = result{
                
                while rs.next(){
                    let select = TheDayInfo()
                    select.startDay = rs.string(forColumn: "start")!
                    select.endDay = rs.string(forColumn: "end")!
                    select.term = rs.string(forColumn: "term")!
                    select.cycle = rs.string(forColumn: "cycle")!
                    //print(select.startDay)
                    resultData.append(select)
                }
                
            }
            else{
                print("no data")
            }
            contactDB.close()
        }
        else{
            
        }
        
        return resultData
    }
    
    // 환경 설정 정보 저장하기
    func SetParameters(info : ConfigDataParam){
        let contactDB = FMDatabase(path: ConfigDBPath)
        
        if contactDB.open() {
            let querySQL = "SELECT term, cycle, curyear, curmonth, curday, curtime, autocal, pass FROM CONTACTS WHERE config = config"
            let result: FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if result?.next() == true {
                info.Term = (result?.string(forColumn: "term"))!
                info.Cycle = (result?.string(forColumn: "cycle"))!
                info.CurYear = (result?.string(forColumn: "curyear"))!
                info.CurMonth = (result?.string(forColumn: "curmonth"))!
                info.CurDay = (result?.string(forColumn: "curday"))!
                info.bSetCurTime = (result?.string(forColumn: "curtime"))!
                info.AutoCal = (result?.string(forColumn: "autocal"))!
                info.Pass = (result?.string(forColumn: "pass"))!
            } else {
                print("fail")
            }
            contactDB.close()
        } else {
            print("Error \(contactDB.lastErrorMessage())")
        }
    }
}
