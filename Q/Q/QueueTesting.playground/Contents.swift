//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let dateInString = "2015-11-21 05:10:15 AM"
let dateFmt = NSDateFormatter()
dateFmt.timeZone = NSTimeZone.defaultTimeZone()
dateFmt.dateFormat = "yyyy-MM-dd h:mm:ss a"
let returnDate = dateFmt.dateFromString(dateInString)