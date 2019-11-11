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
    var CurYear : String = "2019"
    var CurMonth : String = "11"
    var CurDay : String = "9"
    var Term : String = "4"
    var Cycle : String = "28"
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
    
    // Create DB
    func CreateDB(){
        let filemgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as String
        
        TheDayDBPath = docsDir.appending("/TheDayDB001.db")
        LoveDayDBPath = docsDir.appending("/LoveDayDB001.db")
        ConfigDBPath = docsDir.appending("/ConfigDB005.db")
        
        // The Day DB
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
        
        // Love Day DB
        if !filemgr.fileExists(atPath: LoveDayDBPath) {
            let contactDB = FMDatabase(path: LoveDayDBPath)
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, curyear TEXT, curmonth TEXT, curday TEXT)"
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                print("Error \(contactDB.lastErrorMessage())")
            }
        }
        
        // Config DB
        if !filemgr.fileExists(atPath: ConfigDBPath) {
            let contactDB = FMDatabase(path: ConfigDBPath)
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, CONFIG TEXT, TERM TEXT, CYCLE TEXT, CURYEAR TEXT, CURMONTH TEXT, CURDAY TEXT)"
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
    
    
    // set start day
    func SetStartDay(startDay : String, endDay : String, term : String, cycle : String){
        let contactDB = FMDatabase(path: TheDayDBPath)
        if contactDB.open(){
            let insertSQL = "INSERT INTO CONTACTS (start, end, term, cycle) VALUES ('\(startDay)', '\(endDay)', '\(term)', '\(cycle)')"
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [0])
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
            
           // print("seccuss")
        }
        else{
            print("fail")
        }
    }
    
    
    // set love day
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
    
    // Save Config DB
    func SaveConFigDBData(info : ConfigDataParam){
        let contactDB = FMDatabase(path: ConfigDBPath)
        
        let config : String = "config"
        let term : String = info.Term
        let cycle :String = info.Cycle
        let curYear : String = info.CurYear
        let CurMonth : String = info.CurMonth
        let CurDay : String = info.CurDay
        
        if contactDB.open() {
            let insertSQL = "INSERT INTO CONTACTS (config, term, cycle, curyear, curmonth, curday) VALUES ('\(config)', '\(term)', '\(cycle)', '\(curYear)','\(CurMonth)','\(CurDay)')"
            
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
    
    // UpDate Config DB
    func UpDateConfigDBData(info : ConfigDataParam){
        let contactDB = FMDatabase(path: ConfigDBPath)
        
        let config : String = "config"
        let term : String = info.Term
        let cycle :String = info.Cycle
        let curYear : String = info.CurYear
        let CurMonth : String = info.CurMonth
        let CurDay : String = info.CurDay
        
        if contactDB.open() {
            let insertSQL = "UPDATE CONTACTS SET config = '\(config)', term = '\(term)', cycle ='\(cycle)', curyear = '\(curYear)', curmonth = '\(CurMonth)', curday = '\(CurDay)' WHERE ?"
            
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
    
    func GetLoveDayDB()->Array<TheLoveDayInfo>{
        var resultData : [TheLoveDayInfo] = []
        let contactDB = FMDatabase(path: LoveDayDBPath)
        if contactDB.open() {
            let querySQL = "SELECT curyear, curmonth, curday FROM CONTACTS ORDER BY curyear"
            let result: FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            
            if let rs = result{
                
                while rs.next(){
                    var select = TheLoveDayInfo()
                    select.year = rs.string(forColumn: "curyear")!
                    select.month = rs.string(forColumn: "curmonth")!
                    select.day = rs.string(forColumn: "curday")!
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
    
    
    func GetTheDayDB()->Array<TheDayInfo>{
        var resultData : [TheDayInfo] = []
        let contactDB = FMDatabase(path: TheDayDBPath)
        if contactDB.open() {
            let querySQL = "SELECT start, end, term, cycle FROM CONTACTS ORDER BY start"
            let result: FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if let rs = result{
                
                while rs.next(){
                    var select = TheDayInfo()
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
    
    // Get Config Param
    func SetParameters(info : ConfigDataParam){
        let contactDB = FMDatabase(path: ConfigDBPath)
        
        if contactDB.open() {
            let querySQL = "SELECT term, cycle, curyear, curmonth, curday  FROM CONTACTS WHERE config = config"
            let result: FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if result?.next() == true {
                info.Term = (result?.string(forColumn: "term"))!
                info.Cycle = (result?.string(forColumn: "cycle"))!
                info.CurYear = (result?.string(forColumn: "curyear"))!
                info.CurMonth = (result?.string(forColumn: "curmonth"))!
                info.CurDay = (result?.string(forColumn: "curday"))!
            } else {
                print("fail")
            }
            contactDB.close()
        } else {
            print("Error \(contactDB.lastErrorMessage())")
        }
    }
}
