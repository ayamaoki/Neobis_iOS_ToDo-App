//
//  ToDoViewController.swift
//  Neobis_iOS_ToDo-App
//
//  Created by Yo on 22/11/23.
//

import UIKit

class Task {
    var title: String
    var description: String
    var isCompleted: Bool
    
    init(title: String, description: String, isCompleted: Bool = false) {
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
    }
}

class ToDoViewController: UIViewController {
    
    var tasks: [Task] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var addTaskButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        return button
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(toggleEditing)) // toggle editing - переключить редактирование
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationItem.rightBarButtonItems = [addTaskButton, editButton]
    }
    
    @objc func addTask() {
        
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Task Title"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Task Description"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let title = alertController.textFields?.first?.text,
                  let description = alertController.textFields?.last?.text else {
                return
            }
            let newTask = Task(title: title, description: description)
            self.tasks.append(newTask)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func toggleEditing() {
        tableView.isEditing = !tableView.isEditing
    }
}
    
extension ToDoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let task = tasks[indexPath.row]
        
        // добавила круглешокт для галочки
        let checkButton = UIButton(type: .system)
        checkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        checkButton.setImage(UIImage(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle"), for: .normal)
        checkButton.tintColor = .systemBlue
        checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
        
        cell.accessoryView = checkButton
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.description
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        editTask(at: indexPath.row)
    }
    
    @objc func checkButtonTapped(_ sender: UIButton) {
        
        if let cell = sender.superview as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let task = tasks[indexPath.row]
            task.isCompleted = !task.isCompleted
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func
    tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        editTask(at: indexPath.row)
    }
    
    func editTask(at index: Int) {
        let alertController = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Task Title"
            textField.text = self.tasks[index].title
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Task Description"
            textField.text = self.tasks[index].description
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let title = alertController.textFields?.first?.text,
                  let description = alertController.textFields?.last?.text else {
                return
            }
            
            self.tasks[index].title = title
            self.tasks[index].description = description
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


