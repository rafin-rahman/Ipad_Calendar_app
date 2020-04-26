//
//  SearchPanelViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 25/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Firebase

class SearchPanelViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBarTrailing: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarTrailing.constant = -450
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
        
            self.searchBarTrailing.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self.backgroundView.addGestureRecognizer(tap)
        
        
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
           dismiss(animated: true, completion: nil)
       }


}
