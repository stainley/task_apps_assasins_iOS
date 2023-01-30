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

class TaskDetailViewController: UIViewController, AVAudioPlayerDelegate,  AVAudioRecorderDelegate, UITextFieldDelegate  {

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
    
    var audioTimeLabel: [UILabel] = []

    var player: AVAudioPlayer?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder?
    var timer = Timer()
    var scrubber: [UISlider] = []
    var audioPlayButton: [UIButton] = []
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
    @IBOutlet weak var taskCheckMarkImage: UIImageView!
    @IBOutlet weak var taskCheckMarkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureCollectionView.delegate = self
        pictureCollectionView.dataSource = self
        imageSectionLabel.isHidden = true
        pictureCollectionView.superview?.isHidden = true
        setUpDoubleTap()
        titleTaskTxt.delegate = self
        
        let nib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
        pictureCollectionView.register(nib, forCellWithReuseIdentifier: "pictureCell")
        
        if pictures.count > 0 {
            pictureCollectionView.reloadData()
            imageSectionLabel.isHidden = false
            imageSectionLabel.isHidden = false
            pictureCollectionView.superview?.isHidden = false
        }
        
        audioTableView.delegate = self
        audioTableView.dataSource = self
        
        let nibAudioTable = UINib(nibName: "AudioCustomTableViewCell", bundle: nil)
        audioTableView.register(nibAudioTable, forCellReuseIdentifier: "audioPlayerCell")
        
        // PREPARE FOR RECORDING AUDIO
        loadRecordingFuntionality()
        
        print("audioPathaa \(audioPath.count)")
        if audioPath.count > 0 {
            audioTableView.reloadData()
        }
        
        let subTaskTableViewCell = UINib(nibName: "SubTaskTableViewCell", bundle: nil)
        self.subTaskTableView.register(subTaskTableViewCell, forCellReuseIdentifier: "subTaskTableViewCell")
        
        subTaskTableView.dataSource = self
        subTaskTableView.delegate = self

        guard let title = task?.title else {
            return
        }
        titleTaskTxt.text = title
        
        if subTasksEntity.count > 0 {
            taskDueDatePicker.isEnabled = false
            taskDueDatePicker.isHidden = true
            taskCheckMarkButton.isEnabled = false
            taskCheckMarkImage.image = UIImage(systemName: "square.fill")
        }
        
        if task?.isCompleted == true {
            taskCheckMarkImage.image = UIImage(systemName: "checkmark.square")
        }
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
        taskDueDatePicker.isEnabled = true
        taskDueDatePicker.isHidden = false
        self.delegate?.saveTask(task: newTask, oldTaskEntity: task, newPictures: newPictures, newAudioPath: newAudioPath)
    }
    
    // Add SubTasks
    @IBAction func addSubtaskButtonTapped(_ sender: UIButton) {
     
        let subTaskVC = SubTaskModalViewController()
        
        self.task?.isCompleted = false
        taskCheckMarkImage.image = UIImage(systemName: "square.fill")
        
        subTaskVC.modalPresentationStyle = .overCurrentContext
        subTaskVC.subtaskDelegate = self
        self.present(subTaskVC, animated: false)
    }
    
    @IBAction func takePhotoButton(_ sender: UIBarButtonItem) {
        takePhotoOrUpload()
    }
    
    @IBAction func recordAudioButoon(_ sender: UIBarButtonItem) {
        recordTapped()
    }

    @IBAction func taskCheckMarkButtonTapped(_ sender: UIButton) {
        task?.isCompleted = !(task?.isCompleted ?? false)
        if task?.isCompleted == true {
            taskCheckMarkImage.image = UIImage(systemName: "checkmark.square")
        }
        else {
            taskCheckMarkImage.image = UIImage(systemName: "square")
        }
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
        
        taskDueDatePicker.isEnabled = false
        taskDueDatePicker.isHidden = true
        
        subTaskTableView.reloadData()
    }
    
    @objc func updateScrubber(sender: Timer) {
        let index = sender.userInfo as! Int
        let audioTime = Float(player!.currentTime)
        scrubber[index].value = audioTime

        audioTimeLabel[index].text =  player!.currentTime.stringFromTimeInterval()
        if scrubber[index].value == scrubber[index].minimumValue {
 
            audioPlayButton[index].setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            print("show button play")
        }
        
        if scrubber[index].value == 0.0 {
            timer.invalidate()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}



