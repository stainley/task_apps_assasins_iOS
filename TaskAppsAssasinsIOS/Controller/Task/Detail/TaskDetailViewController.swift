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

    var pictureEntity: PictureEntity?
    var pictureEntities: [PictureEntity] = [PictureEntity]()
    var pictures: [UIImage] = []
    var newPictures: [UIImage] = []
    var doubleTapGesture: UITapGestureRecognizer!
    
    var audioPath: [String] = []
    var newAudioPath: [String] = []
    var soundURL: String?
    
    @IBOutlet weak var taskDueDatePicker: UIDatePicker!
    @IBOutlet weak var completedTaskCounterLabel: UILabel!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    @IBOutlet weak var recordAudioButton: UIBarButtonItem!
    @IBOutlet weak var imageSectionLabel: UILabel!
    @IBOutlet weak var audioTableView: UITableView!
    @IBOutlet weak var subTaskTableView: UITableView!
    @IBOutlet weak var titleTaskTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureCollectionView.delegate = self
        pictureCollectionView.dataSource = self
        imageSectionLabel.isHidden = true
        pictureCollectionView.superview?.isHidden = true
        setUpDoubleTap()
        
        let nib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
        pictureCollectionView.register(nib, forCellWithReuseIdentifier: "pictureCell")
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        var newTask = Task(title: titleTaskTxt.text ?? "")
        // for new task pass the array of tasks
        newTask.dueDate = taskDueDatePicker.date
        newTask.subTasks = subTasksEntity

        if pictures.count > 0 {
            for imageData in pictures {
                newTask.pictures.append(imageData.pngData()!)
            }
        }
        
        if audioPath.count > 0 {
            for audioData in audioPath {
                newTask.audios.append(audioData)
            }
        }
        
        self.delegate?.saveTask(task: newTask, oldTaskEntity: task, newPictures: newPictures, newAudioPath: newAudioPath)
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



