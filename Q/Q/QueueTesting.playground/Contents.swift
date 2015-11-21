//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let currentDate = NSDate()
let dateInString = "2015-11-21 13:10:15"
let dateFmt = NSDateFormatter()
dateFmt.timeZone = NSTimeZone.defaultTimeZone()
dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
let returnDate = dateFmt.dateFromString(dateInString)