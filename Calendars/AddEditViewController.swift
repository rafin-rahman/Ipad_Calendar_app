//
//  AddEditViewController.swift
//  Calendars
//
//  Created by Rafin Rahman on 20/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
