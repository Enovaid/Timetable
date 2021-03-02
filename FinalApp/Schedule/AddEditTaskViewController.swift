//
//  AddEditTaskViewController.swift
//  FinalApp
//
//  Created by Alikhan Khassen on 17.12.2020.
//

import UIKit

class AddEditTaskViewController: UIViewController {
    
    
    
    var taskDelegate: TaskDelegate!
    var task: Task!
    
    var editingExistingTask = false
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet var isCompleteSwitch: UISwitch!
    
    @IBOutlet var addSaveButton: UIButton!
    
    @IBOutlet var deleteBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        task = taskDelegate.currentTask
        addSaveButton.layer.cornerRadius = 8.0
        descriptionTextView.layer.cornerRadius = 8.0
        
        
        
        if editingExistingTask {
            
            navigationItem.title = "Task"
            
            titleTextField.text = task.title
            dueDatePicker.date = task.dueDate
            descriptionTextView.text = task.description
            isCompleteSwitch.isOn = task.isCompleted
            
            navigationItem.rightBarButtonItem = deleteBarButtonItem
            
            
            addSaveButton.setTitle("Save", for: .normal)
            
        } else {
            navigationItem.title = "Add Task"
            navigationItem.rightBarButtonItem = nil
            addSaveButton.setTitle("Add", for: .normal)
        }
    }
    

    @IBAction func deleteBarButtonItemPressed(_ sender: UIButton) {
        
        taskDelegate.deleteSelectedTask()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addSaveButtonPressed(_ sender: UIButton) {
        
        let title = (titleTextField.text ?? "").trimmingCharacters(in: .whitespaces)
        let dueDate = dueDatePicker.date
        let description = descriptionTextView.text.trimmingCharacters(in: .whitespaces)
        let isComplete = isCompleteSwitch.isOn
        
        let newTask = Task(title: title, description: description, dueDate: dueDate, isCompleted: isComplete)
        if !editingExistingTask {
    
            taskDelegate.addTask(task: newTask)
            navigationController?.popViewController(animated: true)
        }
        else {
            taskDelegate.replaceSelectedTask(with: newTask)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
}
