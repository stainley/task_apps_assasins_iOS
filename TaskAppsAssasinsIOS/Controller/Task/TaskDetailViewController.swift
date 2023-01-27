//
//  TaskDetailViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/17/23.
//

import UIKit
import CoreData
import AVFoundation
import CoreLocation

class TaskDetailViewController: UIViewController, AVAudioPlayerDelegate,  AVAudioRecorderDelegate  {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: TaskViewController?
    var task: TaskEntity?
    var coordinate: CLLocationCoordinate2D?

    var categorySelected: String = ""
    var categories: [CategoryEntity] = [CategoryEntity]()
    
    var subTasksEntity: [SubTaskEntity] = [SubTaskEntity]()

    var pictures: [UIImage] = []
    var newPictures: [UIImage] = []
    
    @IBOutlet weak var taskDueDatePicker: UIDatePicker!
    @IBOutlet weak var completedTaskCounterLabel: UILabel!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    @IBOutlet weak var recordAudioButton: UIBarButtonItem!
    @IBOutlet weak var imageSectionLabel: UILabel!
    @IBOutlet weak var audioTableView: UITableView!
   // @IBOutlet var catagoryCollection: [UIButton] = []
    //@IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var subTaskTableView: UITableView!
    
    @IBOutlet weak var titleTaskTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //categories  = self.fetchAllCategory()
        for category in categories {
            //let categoryItemButton = UIButton(frame: CGRect(x: 0, y: 0, width: categoryButton.frame.width, height: 40))
            //categoryItemButton.setTitle("\(category.name ?? "")", for: .normal)
            //categoryItemButton.setTitleColor(.black, for: .normal)
            //categoryItemButton.addTarget(self, action: #selector(categoryItemButtonTapped), for: .touchUpInside)
           
            if categorySelected == category.name {
                categoryItemButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
            }
            catagoryCollection.append(categoryItemButton)
            if let stackView = categoryButton.superview as? UIStackView{
                stackView.addArrangedSubview(categoryItemButton)
            }
        }
             */
        /*
        catagoryCollection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
        }
        
        categoryButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        categoryButton.layer.cornerRadius = 6
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.setTitle("Category: \(categorySelected)", for: .normal)
        */
        
        pictureCollectionView.delegate = self
        pictureCollectionView.dataSource = self
        
        let nib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
        pictureCollectionView.register(nib, forCellWithReuseIdentifier: "pictureCell")
        
        //imageSectionLabel.isHidden = true
       // pictureCollectionView.superview?.isHidden = true
      
        if pictures.count > 0 {
            pictureCollectionView.reloadData()
            imageSectionLabel.isHidden = false
            imageSectionLabel.isHidden = false
            pictureCollectionView.superview?.isHidden = false
        }
        
        let subTaskTableViewCell = UINib(nibName: "SubTaskTableViewCell", bundle: nil)
        self.subTaskTableView.register(subTaskTableViewCell, forCellReuseIdentifier: "subTaskTableViewCell")
        
        subTaskTableView.dataSource = self
        subTaskTableView.delegate = self

        guard let title = task?.title else {
            return
        }
        titleTaskTxt.text = title
        
    }
    
//    @IBAction func categoryButtonTapped(_ sender: Any) {
//        catagoryCollection.forEach{ (btn) in
//            UIView.animate(withDuration: 0.7, animations: loadViewIfNeeded) {_ in
//                btn.layer.borderColor = UIColor.lightGray.cgColor
//                btn.layer.borderWidth = 0.25
//                btn.isHidden = !btn.isHidden
//                btn.alpha = btn.alpha == 0 ? 1 : 0
//                btn.layoutIfNeeded()
//            }
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        var newTask = Task(title: titleTaskTxt.text ?? "")
        // for new task pass the array of tasks
        newTask.dueDate = taskDueDatePicker.date
        newTask.subTasks = subTasksEntity

        self.delegate?.saveTask(task: newTask, oldTaskEntity: task)
    }
    
    // Add SubTasks
    @IBAction func addSubtaskButtonTapped(_ sender: UIButton) {
     
        let subTaskVC = SubTaskModalViewController()
        
        subTaskVC.modalPresentationStyle = .overCurrentContext
        subTaskVC.subtaskDelegate = self
        self.present(subTaskVC, animated: false)
    }
    
    @IBAction func takePhotoButton(_ sender: UIBarButtonItem) {
        takePhotoOrUpload()
    }
    
    @IBAction func recordAudioButoon(_ sender: UIBarButtonItem) {
        //recordTapped()
    }

    @objc func scrubleAction(_ sender: UISlider) {
       // sender.maximumValue = Float(player!.duration)
    }
    
//    @objc func categoryItemButtonTapped(sender: UIButton!) {
//
//        catagoryCollection.forEach{ (btn) in
//            btn.backgroundColor = .none
//        }
//        sender.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
//        categorySelected = sender.titleLabel?.text ?? ""
//        categoryButton.setTitle("Category: \(categorySelected)", for: .normal)
//        categoryButtonTapped(sender!)
//    }
    
    // MARK: Add a new sub task
    func addSubTask(subTask: SubTask) {
      
        let newSubTask = SubTaskEntity(context: context)
        newSubTask.title = subTask.title
        newSubTask.dueDate = subTask.dueDate
        newSubTask.status = false
        subTasksEntity.append(newSubTask)
        subTaskTableView.reloadData()
    }
}



extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}



