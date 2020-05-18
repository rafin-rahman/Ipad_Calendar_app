//
//  YearMonthView.swift
//  Calendars
//
//  Created by Rafin Rahman on 11/05/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class YearDisplayView: UIView, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var rowOne: UIStackView!
    @IBOutlet weak var rowTwo: UIStackView!
    @IBOutlet weak var rowThree: UIStackView!
    @IBOutlet weak var rowFour: UIStackView!
    @IBOutlet weak var rowFive: UIStackView!
    @IBOutlet weak var rowSix: UIStackView!
    
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    var arrayOfMonth = Array<Int>()
    
    var activeMonth = Date()
    var status = false
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func onLoad(monthNumber:Int, year:String)
    {
        clearAllStack()
        let selectedDate = "01-" + String(monthNumber) + "-" + year
        self.activeMonth = String(selectedDate).toDate(dateFormat: "dd-MM-yyyy")
        
        monthLabel.text = self.activeMonth.toString(dateFormat: "MMMM")
        
        let numberOfDays = Int(activeMonth.endOfMonth.timeIntervalSince(activeMonth.startOfMonth)/86400 + 1)
        loadArray(date: activeMonth, numberOfDays: numberOfDays)
        
        var monthNumberString = String(monthNumber)
        if monthNumberString.count == 1{
            monthNumberString = "0" + monthNumberString
        }
        
        if monthNumberString == Date().toString(dateFormat: "MM") && year == Date().toString(dateFormat: "yyyy"){
            status = true
        }
        
        loadData()
    }
    
    func loadArray(date:Date, numberOfDays:Int){
        var number = numberOfDays
        let startingWeek = date.startOfMonth.dayNumberOfWeek()! - 1
        if startingWeek > 0 {
            for _ in 1...startingWeek{
                arrayOfMonth.append(0)
            }
        }
        
        if number > 31{
            number = 31
        }
        
        for i in 1...number{
            arrayOfMonth.append(i)
        }
        
        let numberInEnd = 7 - date.endOfMonth.dayNumberOfWeek()!
        if numberInEnd > 0{
            for _ in 1...numberInEnd{
                arrayOfMonth.append(0)
            }
        }
        
        if arrayOfMonth.count < 42 {
            for _ in (arrayOfMonth.count - 1)...40{
                arrayOfMonth.append(0)
            }
        }
    }
    
    func loadData(){
        for element in arrayOfMonth{
            
            let numberView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            numberView.backgroundColor = .white
            numberView.translatesAutoresizingMaskIntoConstraints = false
            
            if element > 0{
                let numberLabel = UILabel(frame: CGRect(x: 0, y:0, width: 0, height: 0))
                               
                numberLabel.text = String(element)
                numberLabel.textColor = HexToUIColor.hexStringToUIColor(hex: "747474", alpha: 1)
                numberLabel.font = UIFont.systemFont(ofSize: 10)
                numberLabel.translatesAutoresizingMaskIntoConstraints = false
                
                if String(element) == Date().toString(dateFormat: "dd") && status{
                    numberLabel.textColor = .red
                    numberLabel.font = UIFont.boldSystemFont(ofSize: 12)
                    status = false
                }
                
                
                let singleTap = DayTapGesture(target: self, action: #selector(onTapDay(_:)))
                singleTap.delegate = self
                let date = Calendar.current.date(byAdding: .day, value: element-1, to: activeMonth.startOfMonth)
                singleTap.date = date
                numberView.addGestureRecognizer(singleTap)

                numberView.addSubview(numberLabel)
                
                numberLabel.centerYAnchor.constraint(equalTo: numberView.centerYAnchor).isActive = true
                numberLabel.centerXAnchor.constraint(equalTo: numberView.centerXAnchor).isActive = true
            }
            else{
                self.backgroundColor = HexToUIColor.hexStringToUIColor(hex: "EFF2F5", alpha: 1.0)
            }
                 
            if rowOne.subviews.count < 7{
                rowOne.addArrangedSubview(numberView)
            }
            else if rowTwo.subviews.count < 7{
                rowTwo.addArrangedSubview(numberView)
            }
            else if rowThree.subviews.count < 7{
                rowThree.addArrangedSubview(numberView)
            }
            else if rowFour.subviews.count < 7{
                rowFour.addArrangedSubview(numberView)
            }
            else if rowFive.subviews.count < 7{
                rowFive.addArrangedSubview(numberView)
            }
            else {
                rowSix.addArrangedSubview(numberView)
            }
            //todo
            numberView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
    }
    
    @objc func onTapDay(_ sender: DayTapGesture){
        if let homeView = self.superview?.superview?.superview?.superview?.superview as? HomeView {
            homeView.getDayView(date: sender.date)
        }

    }
        
    func clearAllStack(){
        rowOne.removeAllArrangedSubviews()
        rowTwo.removeAllArrangedSubviews()
        rowThree.removeAllArrangedSubviews()
        rowFour.removeAllArrangedSubviews()
        rowFive.removeAllArrangedSubviews()
        rowSix.removeAllArrangedSubviews()
    }
    
}
