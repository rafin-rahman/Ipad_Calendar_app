//
//  NavigationProtocol.swift
//  Calendars
//
//  Created by Rafin Rahman on 25/04/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

protocol NavigationProtocol: UIView {
    var dynamicView: CalendarProtocol! { get set }
    func onLoad()
}
