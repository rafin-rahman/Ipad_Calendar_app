//
//  MonthVIew.swift
//  Calendars
//
//  Created by Rafin Rahman on 12/04/2020.
//  Copyright © 2020 Rafin R
//

import UIKit


class MonthView: UIView, CalendarProtocol, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var janButton: UIButton!
    @IBOutlet weak var febButton: UIButton!
    @IBOutlet weak var marButton: UIButton!
    @IBOutlet weak var aprButton: UIButton!
    @IBOutlet weak var mayButton: UIButton!
    @IBOutlet weak var junButton: UIButton!
    @IBOutlet weak var julButton: UIButton!
    @IBOutlet weak var augButton: UIButton!
    @IBOutlet weak var sepButton: UIButton!
    @IBOutlet weak var octButton: UIButton!
    @IBOutlet weak var novButton: UIButton!
    @IBOutlet weak var decButton: UIButton!
    
    @IBOutlet weak var monthView: UIView!
        
    var activeDate = Date()
    var numberOfDays : Int = 0
    
    var counter : Int = 0
    
    func loadData() {
        getDataForMonth(activeDate: Date())
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func getDataForMonth(activeDate:Date){
        self.activeDate = activeDate
        
        if let monthDisplay = UINib(nibName: "MonthDisplayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as?
            MonthDisplayView{
            self.setMonthView(newView: monthDisplay)
            monthDisplay.onLoad(activeMonth: self.activeDate)
        }
    }
   
    
    @IBAction func nextButtonClick(_ sender: UIButton) {
        let currentYear = yearLabel.text!.toDate(dateFormat: "yyyy")!
        yearLabel.text = Calendar.current.date(byAdding: .year, value: 1, to: currentYear)?.toString(dateFormat: "yyyy")
    }
    
    @IBAction func previousButtonClick(_ sender: UIButton) {
        let currentYear = yearLabel.text!.toDate(dateFormat: "yyyy")!
        yearLabel.text = Calendar.current.date(byAdding: .year, value: -1, to: currentYear)?.toString(dateFormat: "yyyy")
    }
    
    @IBAction func monthButtonClick(_ sender: UIButton) {
        let month = sender.tag
        
        janButton.backgroundColor = UIColor.white
        febButton.backgroundColor = UIColor.white
        marButton.backgroundColor = UIColor.white
        aprButton.backgroundColor = UIColor.white
        mayButton.backgroundColor = UIColor.white
        junButton.backgroundColor = UIColor.white
        julButton.backgroundColor = UIColor.white
        augButton.backgroundColor = UIColor.white
        sepButton.backgroundColor = UIColor.white
        octButton.backgroundColor = UIColor.white
        novButton.backgroundColor = UIColor.white
        decButton.backgroundColor = UIColor.white
        
        janButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        febButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        marButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        aprButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        mayButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        junButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        julButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        augButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        sepButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        octButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        novButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        decButton.titleLabel?.font = UIFont.init(name: "System", size: 20)
        
        sender.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.00)
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        let selectedDate = "01-" + String(month) + "-" + yearLabel.text!
        getDataForMonth(activeDate: selectedDate.toDate(dateFormat: "dd-MM-yyyy"))
    }
    
    func setMonthView(newView: UIView){
        if monthView != nil {
            monthView.removeFromSuperview()
        }
        monthView = newView
        monthView.translatesAutoresizingMaskIntoConstraints = false
        monthView.frame = CGRect(x: 0, y: 0, width: monthView.frame.width, height: monthView.frame.height)
        self.addSubview(monthView)
        
                monthView.topAnchor.constraint(equalTo: janButton.bottomAnchor, constant: 0).isActive = true
        monthView.leadingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        monthView.trailingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        monthView.bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
}
