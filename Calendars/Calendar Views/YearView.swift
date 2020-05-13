//
//  YearView.swift
//  Calendars
//
//  Created by Rafin Rahman on 16/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class YearView: UIView, CalendarProtocol {
    
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var rowOne: UIStackView!
    @IBOutlet weak var rowTwo: UIStackView!
    @IBOutlet weak var rowThree: UIStackView!
    @IBOutlet weak var rowFour: UIStackView!
    
    func loadData() {
        yearLabel.text = Calendar.current.date(byAdding: .year, value: 0, to: Date())?.toString(dateFormat: "yyyy")
        getDataForYear(activeDate: Date())
    }
    
    func getDataForYear(activeDate:Date){
        clearAllStack()
        for i in 1...12{
            let yearDisplay = UINib(nibName: "YearDisplayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? YearDisplayView
            yearDisplay?.onLoad(monthNumber: i, year: yearLabel.text!)
            
            yearDisplay?.heightAnchor.constraint(equalToConstant: 232).isActive = true
            
            if rowOne.subviews.count < 3{
                rowOne.addArrangedSubview(yearDisplay!)
            }
            else if rowTwo.subviews.count < 3{
                rowTwo.addArrangedSubview(yearDisplay!)
            }
            else if rowThree.subviews.count < 3{
                rowThree.addArrangedSubview(yearDisplay!)
            }
            else {
                rowFour.addArrangedSubview(yearDisplay!)
            }
        }
    }
    

    @IBAction func previousButton(_ sender: UIButton) {
        let currentYear = yearLabel.text!.toDate(dateFormat: "yyyy")!
        yearLabel.text = Calendar.current.date(byAdding: .year, value: -1, to: currentYear)?.toString(dateFormat: "yyyy")
        getDataForYear(activeDate: Calendar.current.date(byAdding: .year, value: 1, to: currentYear)!)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        let currentYear = yearLabel.text!.toDate(dateFormat: "yyyy")!
        yearLabel.text = Calendar.current.date(byAdding: .year, value: 1, to: currentYear)?.toString(dateFormat: "yyyy")
        getDataForYear(activeDate: Calendar.current.date(byAdding: .year, value: 1, to: currentYear)!)
    }
    
    func clearAllStack(){
        rowOne.removeAllArrangedSubviews()
        rowTwo.removeAllArrangedSubviews()
        rowThree.removeAllArrangedSubviews()
        rowFour.removeAllArrangedSubviews()
    }
}
