//
//  ChangeCategoryView.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-26.
//

import UIKit

class ChangeCategoryView: UIViewController {
    
    var subtaskDelegate: TaskDetailViewController!
    let categories = ["Cat1", "Cat2", "Cat3"]

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
        button.setTitle("Add Sub Task", for: .normal)
        button.backgroundColor = UIColor.tintColor
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bounds = CGRect(x: 8, y: 8, width: 300, height: 20)
        button.showsMenuAsPrimaryAction = true
        button.menu = menu
        return button
    }()
    
    
    private lazy var first = UIAction(title: "first", image: UIImage(systemName: "pencil.circle"), attributes: [], state: .off) { action in
            print("first")
    }
    
    private lazy var second = UIAction(title: "second", image: UIImage(systemName: "pencil.circle"), attributes: [.destructive], state: .on) { action in
          print("second")
    }
    
    private lazy var camera = UIAction(title: "Camera", image: UIImage(systemName: "camera")){ _ in
         print("camera tapped")
    }
    
     private lazy var photo = UIAction(title: "Photo", image: UIImage(systemName: "photo.on.rectangle.angled")){ _ in
         print("photo tapped")
     }
    
    //private lazy var elements: [UIAction] = [first, second]
    private lazy var elements: [UIAction] = categoryOptions()
    private lazy var menu = UIMenu(title: "Category", children: elements)
    
    
    func categoryOptions(handler: AnyObject? = nil) -> [UIAction] {
        var actions: [UIAction] = []
        // fetch from the database categories
        for category in categories {
            let action = UIAction(title: category, image: UIImage(systemName: "pencil.circle"), handler: { (action) in
                print(category)
                self.optionLabel.text = category
            })
            actions.append(action)
        }
        
        return actions
    }
    
    lazy var createSubTaskButton: UIButton = {
       let button = UIButton()
        button.setTitle("Accept", for: .normal)
        button.backgroundColor = UIColor.tintColor
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bounds = CGRect(x: 8, y: 8, width: 300, height: 20)
        return button
    }()
       
   lazy var contentStackView: UIStackView = {
       let spacer = UIView()
       let stackView = UIStackView(arrangedSubviews: [titleLabel, categoryButton, optionLabel  ,spacer, createSubTaskButton])
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
       //menu = menu.replacingChildren([first, second, deferredMenu])

       navigationItem.rightBarButtonItem?.menu = menu

       // tap gesture on dimmed view to dismiss
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
       dimmedView.addGestureRecognizer(tapGesture)
       //setupPanGesture()
       
       //createSubTaskButton.addTarget(self, action: #selector(createSubTask), for: .touchDown)
       //categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchDown)
       
   }

    
    @objc func categoryButtonTapped(_ sender: Any) {
        /*
        categoryDropDown.forEach{ (btn) in
            UIView.animate(withDuration: 0.7, animations: loadViewIfNeeded) {_ in
                btn.layer.borderColor = UIColor.lightGray.cgColor
                btn.layer.borderWidth = 0.25
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
                btn.layoutIfNeeded()
            }
        }*/
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
