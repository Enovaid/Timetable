//
//  TaskTimer.swift
//  FinalApp
//
//  Created by Alikhan Khassen on 17.12.2020.
//

import Foundation

struct TaskTimer {
    
    lazy var currentValue = workingIntervalInSeconds
    
    var workingIntervalInSeconds: Int = 25 * 60
    var restingIntervalInSeconds: Int = 5 * 60
    
    
}
