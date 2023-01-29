//
//  TaskSearchViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/17/23.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var sortNameButton: UIButton!
    @IBOutlet weak var sortDateButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    var tasks: [TaskEntity] = []
    var filteredTasks: [TaskEntity] = []
    var subTasks: [SubTaskEntity] = []
    var taskReferenceCell: TaskNibTableViewCell!
    var passingData: String?
    
    var picturesEntity = [PictureEntity]()
    var audiosEntity = [AudioEntity]()
    
    var selectedCategory: CategoryEntity? {
        didSet {
            tasks = loadTasksByCategory()
        }
    }
    
    var isNameAsc: Bool = true
    var isCreateDate: Bool = true
    var iconName: String = ""
    
    @IBAction func sortNameButton(_ sender: UIButton){
        isNameAsc.toggle()
        if isNameAsc {
            sortByNameAsc()
            iconName = "arrow.down"
        }else {
            sortByNameDesc()
            iconName = "arrow.up"
        }
        if let sortImage = UIImage(systemName:iconName) {
            sortNameButton.setImage(sortImage, for: .normal)
        }
    }
    @IBAction func sortDateButton(_ sender: UIButton){
        isCreateDate.toggle()
        if isCreateDate {
            sortByCreateDateAsc()
            iconName = "arrow.down"
        }else {
            sortByCreateDateDesc()
            iconName = "arrow.up"
        }
        if let sortImage = UIImage(systemName:iconName) {
            sortDateButton.setImage(sortImage, for: .normal)
        }
    }
    //Sorting Name and Date functions
    func sortByNameAsc(){
        let assortNameAsc = filteredTasks.sorted{ $0.title! < $1.title! }
        filteredTasks = []
        filteredTasks = assortNameAsc
        taskTableView.reloadData()
    }
    func sortByNameDesc(){
        let assortNameAsc = filteredTasks.sorted{ $0.title! > $1.title! }
        filteredTasks = []
        filteredTasks = assortNameAsc
        taskTableView.reloadData()
    }
    func sortByCreateDateAsc(){
        let assortDateAsc = filteredTasks.sorted{ $0.creationDate! < $1.creationDate! }
        filteredTasks = []
        filteredTasks = assortDateAsc
        taskTableView.reloadData()
    }
    func sortByCreateDateDesc(){
        let assortDateDesc = filteredTasks.sorted{ $0.creationDate! > $1.creationDate! }
        filteredTasks = []
        filteredTasks = assortDateDesc
        taskTableView.reloadData()
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
        picturesEntity = loadImagesByTask()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        taskTableView.reloadData()
        
        sortNameButton.layer.cornerRadius = 4
        sortDateButton.layer.cornerRadius = 4
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

