//
//  CustomModalViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-26.
//

import UIKit

class SubTaskModalViewController: UIViewController {
    
    var subtaskDelegate: TaskDetailViewController!
    
    //  lazy views
   lazy var titleLabel: UILabel = {
       let label = UILabel()
       label.text = "Sub Task"
       label.font = .boldSystemFont(ofSize: 20)
       return label
   }()
    
    lazy var subTaskNameText: UITextField = {
        let editText = UITextField()
        editText.placeholder = "Sub Task name"
        editText.borderStyle = .roundedRect
        return editText
    }()
    
    
    lazy var dueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        return datePicker
    }()
    
    lazy var createSubTaskButton: UIButton = {
       let button = UIButton()
        button.setTitle("Add Sub Task", for: .normal)
        button.backgroundColor = UIColor.tintColor
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bounds = CGRect(x: 8, y: 8, width: 300, height: 20)
        return button
    }()
       
   lazy var contentStackView: UIStackView = {
       let spacer = UIView()
       let stackView = UIStackView(arrangedSubviews: [titleLabel, subTaskNameText, dueDatePicker, spacer, createSubTaskButton])
       stackView.axis = .vertical
       stackView.spacing = 12.0
       return stackView
   }()
   
   lazy var containerView: UIView = {
       let view = UIView()
       view.backgroundColor = .white
       view.layer.cornerRadius = 16
       view.clipsToBounds = true
       return view
   }()
   
   let maxDimmedAlpha: CGFloat = 0.6
   lazy var dimmedView: UIView = {
       let view = UIView()
       view.backgroundColor = .black
       view.alpha = maxDimmedAlpha
       return view
   }()
       
   // Constants
   let defaultHeight: CGFloat = 300
   let dismissibleHeight: CGFloat = 200
   let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 34
   // keep current new height, initial is default height
   var currentContainerHeight: CGFloat = 300
   
   // Dynamic container constraint
   var containerViewHeightConstraint: NSLayoutConstraint?
   var containerViewBottomConstraint: NSLayoutConstraint?
   
   override func viewDidLoad() {
       super.viewDidLoad()
       setupView()
       setupConstraints()
       // tap gesture on dimmed view to dismiss
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
       dimmedView.addGestureRecognizer(tapGesture)       
       createSubTaskButton.addTarget(self, action: #selector(createSubTask), for: .touchDown)
   }
    
    //MARK: Add new subtask to the arraylist
    @objc func createSubTask() {
        dueDatePicker.datePickerMode = .time
                
        let subtask = SubTask(title: subTaskNameText.text!, dueDate: dueDatePicker.date)
        subtaskDelegate.addSubTask(subTask: subtask)
        handleCloseAction()
    }
       
       @objc func handleCloseAction() {
           animateDismissView()
       }
       
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           animateShowDimmedView()
           animatePresentContainer()
       }
       
       func setupView() {
           view.backgroundColor = .clear
       }
       
   func setupConstraints() {
       // Add subviews
       view.addSubview(dimmedView)
       view.addSubview(containerView)
       dimmedView.translatesAutoresizingMaskIntoConstraints = false
       containerView.translatesAutoresizingMaskIntoConstraints = false
       
       containerView.addSubview(contentStackView)
       contentStackView.translatesAutoresizingMaskIntoConstraints = false
       
       // Set static constraints
       NSLayoutConstraint.activate([
           // set dimmedView edges to superview
           dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
           dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           // set container static constraint (trailing & leading)
           containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           // content stackView
           contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
           contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
           contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
           contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
       ])
       
       // Set dynamic constraints
       // First, set container to default height
       // after panning, the height can expand
       containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
       
       // By setting the height to default height, the container will be hide below the bottom anchor view
       // Later, will bring it up by set it to 0
       // set the constant to default height to bring it down again
       containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
       // Activate constraints
       containerViewHeightConstraint?.isActive = true
       containerViewBottomConstraint?.isActive = true
   }

   func animateContainerHeight(_ height: CGFloat) {
       UIView.animate(withDuration: 0.4) {
           // Update container height
           self.containerViewHeightConstraint?.constant = height
           // Call this to trigger refresh constraint
           self.view.layoutIfNeeded()
       }
       // Save current height
       currentContainerHeight = height
   }
   
   // MARK: Present and dismiss animation
   func animatePresentContainer() {
       // update bottom constraint in animation block
       UIView.animate(withDuration: 0.3) {
           self.containerViewBottomConstraint?.constant = 0
           // call this to trigger refresh constraint
           self.view.layoutIfNeeded()
       }
   }
   
   func animateShowDimmedView() {
       dimmedView.alpha = 0
       UIView.animate(withDuration: 0.4) {
           self.dimmedView.alpha = self.maxDimmedAlpha
       }
   }
   
   func animateDismissView() {
       // hide blur view
       dimmedView.alpha = maxDimmedAlpha
       UIView.animate(withDuration: 0.4) {
           self.dimmedView.alpha = 0
       } completion: { _ in
           // once done, dismiss without animation
           self.dismiss(animated: false)
       }
       // hide main view by updating bottom constraint in animation block
       UIView.animate(withDuration: 0.3) {
           self.containerViewBottomConstraint?.constant = self.defaultHeight
           // call this to trigger refresh constraint
           self.view.layoutIfNeeded()
       }
   }
}
