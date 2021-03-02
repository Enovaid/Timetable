//
//  TasksViewController.swift
//  FinalApp
//
//  Created by Alikhan Khassen on 17.12.2020.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskDelegate {
    
    var tasks: [[Task]] = [[],[]]
    
    var currentTask: Task!
    
    var selectedIndexPath: IndexPath!
    
    func addTask(task: Task) {
        if task.isCompleted {
            tasks[1].append(task)
        } else {
            tasks[0].append(task)
        }
        updateTasks()
    }
    
    func replaceSelectedTask(with task: Task) {
        tasks[selectedIndexPath.section].remove(at: selectedIndexPath.row)
        addTask(task: task)
    }
    
    func deleteSelectedTask() {
        tasks[selectedIndexPath.section].remove(at: selectedIndexPath.row)
        
        updateTasks()
    }
    
    func updateTasks() {
        tasks[0].sort() {$0.dueDate < $1.dueDate}
        tasks[1].sort() {$0.dueDate < $1.dueDate}
        
        Task.saveTasks(tasks)
        tasksTableView.reloadData()
    }
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let task = tasks[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTableViewCell")! as! TaskTableViewCell
        
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.description
        cell.dueDateLabel.text = dateFormatter.string(from: task.dueDate)
        cell.dueDateLabel.layer.cornerRadius = 4.0
        cell.dueDateLabel.layer.masksToBounds = true
        
        let currentDate = Date()
        
        let distance = currentDate.distance(to: task.dueDate)
        
        
        if !task.isCompleted &&  distance < 24*3600  {
            
            let hoursLeft = Int(distance/3600)
            
            let minutesLeft = Int(distance - Double(hoursLeft * 3600))/60
            
            
            if hoursLeft > 0 {
                cell.dueDateLabel.text = "\(hoursLeft)H left"
                cell.dueDateLabel.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            } else if minutesLeft > 0 {
                cell.dueDateLabel.text = "\(minutesLeft)M left"
                cell.dueDateLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            } else {
                cell.dueDateLabel.text = "Missing"
                cell.dueDateLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            
            
            
        } else if task.isCompleted {
            cell.dueDateLabel.text = "Done"
            cell.dueDateLabel.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
            cell.dueDateLabel.backgroundColor = .clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks[indexPath.section].remove(at: indexPath.row)
            updateTasks()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if !tasks[0].isEmpty { return "Current" } else { return nil }
        case 1:
            if !tasks[1].isEmpty { return "Completed" } else { return nil }
        default:
            return "??"
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        currentTask = tasks[indexPath.section][indexPath.row]
        selectedIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let markAsCompleted = markAsCompletedAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [markAsCompleted])
    }
    
    func markAsCompletedAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "Mark As Completed") { (action, view, completion)  in
            self.toggleIsComplete(at: indexPath)
            
            completion(true)
        }
        
        if tasks[indexPath.section][indexPath.row].isCompleted {
            action.title = "Mark as Incomplete"
            action.backgroundColor = #colorLiteral(red: 0.9971274734, green: 0.246809572, blue: 0.1372969747, alpha: 1)
        } else {
            action.title = "Mark as Completed"
            action.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
        
        return action
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewTaskSegue" {
            let destination = segue.destination as! AddEditTaskViewController
            destination.taskDelegate =  self
            destination.editingExistingTask = false
        }
        else if segue.identifier == "EditExistingTaskSegue" {
            let destination = segue.destination as! AddEditTaskViewController
            destination.taskDelegate = self
            destination.editingExistingTask = true
            destination.task = currentTask
        }
    }
    
    func toggleIsComplete(at indexPath: IndexPath) {
        tasks[indexPath.section][indexPath.row].isCompleted = !tasks[indexPath.section][indexPath.row].isCompleted
        
        if tasks[indexPath.section][indexPath.row].isCompleted {
            let completedTask = tasks[indexPath.section].remove(at: indexPath.row)
            tasks[1].append(completedTask)
        } else {
            let inCompletedTask = tasks[indexPath.section].remove(at: indexPath.row)
            tasks[0].append(inCompletedTask)
        }
        
        
        updateTasks()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let loadedTasks = Task.loadTasks() {
            tasks = loadedTasks
        }
    }
    

    

}
