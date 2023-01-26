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

    
    var tasks = [TaskEntity]()
    var filteredTasks = [TaskEntity]()
    var taskReferenceCell: TaskNibTableViewCell!
    var passingData: String?
    
    var picturesEntity = [PictureEntity]()
    var audiosEntity = [AudioEntity]()
    
    var selectedCategory: CategoryEntity? {
        didSet {
            tasks = loadTasksByCategory()
        }
    }
    
    @IBAction func addNewTaskButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func taskFilterButton(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        //TO BE REMOVE - DUMMY DATA
        /*
        tasks.append(Task(title: "Do Grocery", description: "Buy fruits, veggies, and meat", creationDate: NSDate(), dueDate: NSDate(), dateCompleted: NSDate(), pictures: [], audios: [], isComplete: false))
        tasks.append(Task(title: "Visit Parents", description: "Spend sunday with parents", creationDate: NSDate(), dueDate: NSDate(), dateCompleted: NSDate(), pictures: [], audios: [], isComplete: true))
        tasks.append(Task(title: "Play with the cats", description: "Play for 1 hour with the cat", creationDate: NSDate(), dueDate: NSDate(), dateCompleted: NSDate(), pictures: [], audios: [], isComplete: false))
        tasks.append(Task(title: "Visit Bank", description: "Get February rent cheque", creationDate: NSDate(), dueDate: NSDate(), dateCompleted: NSDate(), pictures: [], audios: [], isComplete: true))
        */
        
        let cellNib = UINib(nibName: "TaskNibTableViewCell", bundle: Bundle.main)
        taskTableView.register(cellNib, forCellReuseIdentifier: "TaskNibTableViewCell")
        
        filteredTasks = tasks

    }
    
    // TODO: Elvin
    func saveTask(task: Task) {
        let newTask = TaskEntity(context: context)
        newTask.title = task.title
        newTask.taskDescription = task.description
        newTask.creationDate = Date()
        
        // Save image to the Database
        for picture in task.pictures {
            let pictureEntity = PictureEntity(context: context)

            pictureEntity.picture = picture
            pictureEntity.task_parent = newTask
            newTask.addToPictures(pictureEntity)
        }
        
        // Save audio into the Database
        for audio in task.audios {
            let audioEntity = AudioEntity(context: context)
            audioEntity.audioPath = audio
            audioEntity.task_parent = newTask
            newTask.addToAudios(audioEntity)
        }
        
        
        // Save coordinate to the database
        if let latitude = task.latitude, let longitude = task.longitude {
            newTask.longitude = latitude
            newTask.longitude = longitude
        }
        
        newTask.category_parent = selectedCategory
        saveTask()
        tasks = loadTasksByCategory()
        filteredTasks = tasks
        taskTableView.reloadData()
    }

}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskNibTableViewCell", for: indexPath) as? TaskNibTableViewCell

        cell?.titleLabel?.text = tasks[indexPath.row].title
        cell?.descriptionLabel?.text = tasks[indexPath.row].taskDescription
        cell?.creationDateLabel?.text = "\(tasks[indexPath.row].creationDate!)"
        
        print(tasks[indexPath.row].creationDate!)
        if tasks[indexPath.row].isCompleted == true {
            cell?.taskColorIndicatorView?.backgroundColor = .systemGreen
        }
        else {
            cell?.taskColorIndicatorView?.backgroundColor = .systemBlue
            
            //TO BE REPLACE - Due date and current date comparison
            if (indexPath.row == 2) {
                cell?.taskColorIndicatorView?.backgroundColor = .systemRed
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            print("a")
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.filteredTasks[indexPath.row]
        
        if let taskDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailViewController") as? TaskDetailViewController {
            taskDetailViewController.task = task
            self.navigationController?.pushViewController(taskDetailViewController, animated: true)
        }
    }
}
