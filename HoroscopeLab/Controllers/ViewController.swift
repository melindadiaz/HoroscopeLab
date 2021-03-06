//
//  ViewController.swift
//  HoroscopeLab
//
//  Created by Melinda Diaz on 1/13/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //TODO: look for a method that puts a title on the pickerView  and fix the corner radius
    @IBOutlet weak var userNameOutlet: UITextField!
    @IBOutlet weak var horoscopePicker: UIPickerView!
    
    var monthly = ["Jan","Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]
    var days = ["1" ,"2" ,"3" ,"4" ,"5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17" ,"18" , "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    
    var userData = UserInfo(name: "User", sunSign: .leo)
    var setBool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        horoscopePicker.dataSource = self
        horoscopePicker.delegate = self
        userNameOutlet.delegate = self
        todaysDate()
        userNameOutlet.placeholder = "Name Here"
    }
    func todaysDate() {
        let today = Date()
        let instance = DateFormatter()
        instance.dateFormat = "MMM d"
        let everyDate = instance.string(from: today)
        let newDate = everyDate.components(separatedBy: " ")
        convertMonth(month: newDate.first ?? "Jan" )
        converDay(day: newDate[1])
    }
    
    func convertMonth(month:String) {
        switch month {
        case "Jan":
            horoscopePicker.selectRow(0, inComponent: 0, animated: true)
        case "Feb":
            horoscopePicker.selectRow(1, inComponent: 0, animated: true)
        case "Mar":
            horoscopePicker.selectRow(2, inComponent: 0, animated: true)
        case "Apr":
            horoscopePicker.selectRow(3, inComponent: 0, animated: true)
        case "May":
            horoscopePicker.selectRow(4, inComponent: 0, animated: true)
        case "June":
            horoscopePicker.selectRow(5, inComponent: 0, animated: true)
        case "July":
            horoscopePicker.selectRow(6, inComponent: 0, animated: true)
        case "Aug":
            horoscopePicker.selectRow(7, inComponent: 0, animated: true)
        case "Sept":
            horoscopePicker.selectRow(8, inComponent: 0, animated: true)
        case "Oct":
            horoscopePicker.selectRow(9, inComponent: 0, animated: true)
        case "Nov":
            horoscopePicker.selectRow(10, inComponent: 0, animated: true)
        default:
            horoscopePicker.selectRow(11, inComponent: 0, animated: true)
        }
    }
    
    func converDay(day: String) {
        var dateOfMonth = Int(day) ?? 1
        dateOfMonth -= 1
        horoscopePicker.selectRow(dateOfMonth, inComponent: 1, animated: true)
    }
}

extension ViewController: UIPickerViewDataSource {
    //this is the amount of "columns" or components that the user picks from eg. (month and day)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    //the amount of options
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return monthly.count
        default:
            return days.count
        }
    }
    //this function helps set up the user zodiac
    func userZodiac(month: String, day: Int ) -> SunSign? {
        
        if month == "Mar" && day >= 21 || month == "Apr" && day <= 19 {
            return SunSign.aries
        } else if month == "Apr" && day >= 20 || month == "May" && day <= 20 {
            return SunSign.taurus
        } else if month == "May" && day >= 21 || month == "June" && day <= 20 {
            return SunSign.gemini
        } else if month == "June" && day >= 21 || month == "July" && day <= 22 {
            return SunSign.cancer
        } else if month == "July" && day >= 23 || month == "Aug" && day <= 22 {
            return SunSign.leo
        } else if month == "Aug" && day >= 23 || month == "Sept" && day <= 22 {
            return SunSign.virgo
        } else if month == "Sept" && day >= 23 || month == "Oct" && day <= 22 {
            return SunSign.libra
        } else if month == "Oct" && day >= 23 || month == "Nov" && day <= 21 {
            return SunSign.scorpio
        } else if month == "Nov" && day >= 22 || month == "Dec" && day <= 21 {
            return SunSign.sagittarius
        } else if month == "Dec" && day >= 22 || month == "Jan" && day <= 19 {
            return SunSign.capricorn
        } else if month == "Jan " && day >= 20 || month == "Feb" && day <= 18 {
            return SunSign.aquarius
        } else {
            return SunSign.pisces
        }
        
    }
}


extension ViewController: UIPickerViewDelegate {
   
    //so this is where we put our data
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return monthly[row]
        case 1:
            return days[row]
        default:
            return "nil"
        }
    }
    
    //This method is displaying the appropriate information to put in the pickerView (month and days)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setBool = true
        var monthTemp = ""
        var dayTemp = ""
        switch component {
        case 0:
            monthTemp = monthly[row]
        case 1:
            dayTemp = days[row]
        default:
            break
        }
        userData.sunSign = userZodiac(month: monthTemp, day: Int(dayTemp) ?? 0) ?? .leo
        if userData.name != "User" && setBool {
            Wrapper.shared.saveUserData(ex: userData)
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let userTextField = textField.text else {
            showAlert(title: "Error", message: "Need more info")
            return false
        }
        userData.name = userTextField
        if userData.name != "User" && setBool {
            Wrapper.shared.saveUserData(ex: userData)
        }
        textField.resignFirstResponder()
        return true
    }
}

