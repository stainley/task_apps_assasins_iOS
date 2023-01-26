//
//  TaskDetailViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/17/23.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var taskTitle: UITextField!
    
    var task: TaskEntity?
    weak var taskViewControllerDelegate: TaskViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        guard let task = task else {
            return
        }
        taskTitle.text = task.title
    }
    
    @IBAction func addSubTaskButton(_ sender: UIButton) {
        
    }
  

    
}
