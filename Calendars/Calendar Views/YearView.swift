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
        
    }
    

    @IBAction func previousButton(_ sender: UIButton) {
    }
    @IBAction func nextButton(_ sender: UIButton) {
    }
}
