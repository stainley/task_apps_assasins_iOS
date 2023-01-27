//
//  TaskSearchViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/17/23.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    var tasks: [TaskEntity] = []
    var filteredTasks: [TaskEntity] = []
    var taskReferenceCell: TaskNibTableViewCell!
    var passingData: String?
    
    var picturesEntity = [PictureEntity]()
    var audiosEntity = [AudioEntity]()
    
    var selectedCategory: CategoryEntity? {
        didSet {
            tasks = loadTasksByCategory()
            print(tasks.count)
        }
    }
    
    @IBAction func taskFilterButton(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategory?.title
        
        let cellNib = UINib(nibName: "TaskNibTableViewCell", bundle: nil)
        taskTableView.register(cellNib, forCellReuseIdentifier: "taskViewCell")
        
        filteredTasks = tasks
        self.navigationController?.navigationBar.prefersLargeTitles = false
        taskTableView.reloadData()
    }
    
  
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? TaskDetailViewController {
            destination.delegate = self
            loadImagesByTask()
            loadAudiosByTask()
        }
    }

}

