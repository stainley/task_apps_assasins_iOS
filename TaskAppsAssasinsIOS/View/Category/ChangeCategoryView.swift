//
//  ChangeCategoryView.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-27.
//

import UIKit

class ChangeCategoryView: UIViewController {
    
    var taskViewControllerDelegate: TaskViewController!
    var noteViewControllerDelegate: NoteViewController!
    
    var categories: [CategoryEntity] = []
    var noteToChange: NoteEntity!
    
    //  lazy views
   lazy var titleLabel: UILabel = {
       let label = UILabel()
       label.text = "Change Category"
       label.font = .boldSystemFont(ofSize: 20)
       return label
   }()
    
    lazy var optionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Category", for: .normal)
        button.backgroundColor = UIColor.tintColor
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bounds = CGRect(x: 8, y: 8, width: 300, height: 20)
        button.showsMenuAsPrimaryAction = true
        button.menu = menu
        return button
    }()
    
    //private lazy var elements: [UIAction] = [first, second]
    private lazy var elements: [UIAction] = categoryOptions()
    private lazy var menu = UIMenu(title: "Category", children: elements)
    
    
    func categoryOptions(handler: AnyObject? = nil) -> [UIAction] {
        var actions: [UIAction] = []
        
        for category in categories {
            // remove actual category from menu
            if category.name == noteViewControllerDelegate.selectedCategory!.name {
                continue
            }
            
            let action = UIAction(title: category.name ?? "", image: UIImage(systemName: "pencil.circle"), handler: { (action) in

                self.optionLabel.text = "Note changed to \(category.name!)"
                
                self.noteViewControllerDelegate.changeNoteCategory(noteEntity: self.noteToChange, for: category)

                self.noteViewControllerDelegate.noteTableView.reloadData()
                
            })
            actions.append(action)
        }
        
        return actions
    }
    
    lazy var changeCategoryButton: UIButton = {
       let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.backgroundColor = UIColor.tintColor
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bounds = CGRect(x: 8, y: 8, width: 300, height: 20)
        return button
    }()
       
   lazy var contentStackView: UIStackView = {
       let spacer = UIView()
       let stackView = UIStackView(arrangedSubviews: [titleLabel, categoryButton, optionLabel  ,spacer, changeCategoryButton])
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
       
       categoryButton.menu = menu
       navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

       navigationItem.rightBarButtonItem?.menu = menu

       // tap gesture on dimmed view to dismiss
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
       dimmedView.addGestureRecognizer(tapGesture)
       
       changeCategoryButton.addTarget(self, action: #selector(changeCategory), for: .touchDown)
   }
    
    @objc func categoryButtonTapped(_ sender: Any) {
        
        handleCloseAction()
    }
    
    @objc func changeCategory() {
        noteViewControllerDelegate.noteTableView.reloadData()

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
       
    private func delayMenuImageLoading(with interval: TimeInterval, useDeferredMenu: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.navigationItem.rightBarButtonItem?.menu = self.menu
            self.categoryButton.menu = self.menu
        }
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
