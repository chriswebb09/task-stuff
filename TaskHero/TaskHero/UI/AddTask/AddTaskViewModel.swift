//
//  AddTaskViewModel.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 12/12/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit


struct AddTaskViewModel {
    
    // TODO: - Incomplete needs to accurate data - continue refactoring data out of vc
    
    var pickerMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var years = ["2017", "2018", "2019"]
    let range: [Int] = Array(1...30)
}
