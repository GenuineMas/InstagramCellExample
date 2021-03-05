//
//  ViewController.swift
//  InstagramCellExample
//
//  Created by Genuine on 04.03.2021.
//

import UIKit





class InstaCellViewController: UIViewController {
    
    
    let theLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .black
        label.textAlignment = .center
        return label
    }()
    
    func setupLabelLayouts(){
        NSLayoutConstraint.activate([
            theLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            theLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            theLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
        ])
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(theLabel)
        setupLabelLayouts()
        
        if let localData = readLocalFile(forName: "InstagramTestData") {
            parse(jsonData: localData)
            
        }
    }
}

class InstaPageViewController: UIPageViewController {
    
    private var pageControl = UIPageControl(frame: .zero)
    
    private func setupPageControl() {
        
        pageControl.numberOfPages = pages.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        
    }
    
    let colors: [UIColor] = [
        .white,
        .white,
        .white,
        .white,
        .white,
        .white
    ]
    
    var pages: [UIViewController] = [UIViewController]()
    var currentIndex: Int?
    var pendingIndex: Int?
    
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        
        for viewIndex in 0..<colors.count {
            let viewController = InstaCellViewController()
            viewController.theLabel.text = "Photo: \(viewIndex)"
            viewController.theLabel.textColor = .white
            viewController.view.backgroundColor = colors[viewIndex]
            pages.append(viewController)
        }
        setViewControllers([pages[0]], direction: .reverse, animated: false, completion: nil)
        
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
        let leading = NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        setupPageControl()
        view.bringSubviewToFront(pageControl)
        view.addConstraints([leading, trailing, bottom])
        
    }
    
}

extension InstaPageViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex! - 1 + pages.count) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)
        if currentIndex == pages.count-1 {
            return nil
        }
        let nextIndex = abs((currentIndex! + 1) % pages.count)
        return pages[nextIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.firstIndex(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
}

