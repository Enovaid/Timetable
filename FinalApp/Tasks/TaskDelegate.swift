//
//  TaskDelegate.swift
//  FinalApp
//
//  Created by Alikhan Khassen on 17.12.2020.
//

import Foundation

protocol TaskDelegate {
    
    var currentTask: Task! { get }
    func addTask(task: Task)
    func replaceSelectedTask(with task: Task)
    func deleteSelectedTask()
}
