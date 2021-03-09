//
//  ListViewController.swift
//  InstagramCellExample
//
//  Created by Genuine on 05.03.2021.
//

import Foundation
import UIKit
import SnapKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pageViewControllers = [InstaPageViewController]()
    let cellViewController = InstaCellViewController()
    var photosURL = String()
    
    lazy var table: UITableView = {
        let v = UITableView()
        v.rowHeight = 500
        v.separatorStyle = .none
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        
    }

    func setupUI() {
        
        table.delegate = self
        table.dataSource = self
        table.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellId)
        self.view.addSubview(table)
        
        table.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        for _ in 0 ..< 2 {
            let pageViewController = InstaPageViewController()
            pageViewControllers.append(pageViewController)
      
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellId, for: indexPath) as! CustomCell
        let pageViewController = pageViewControllers[indexPath.row]
        addChild(pageViewController)
        pageViewController.view.frame = (cell.contentView.bounds)
        pageViewController.didMove(toParent: self)
        cell.contentView.addSubview(pageViewController.view)
        
        if let localData = readLocalFile(forName: "InstagramTestData") {
            photosURL = (parse(jsonData: localData)?.posts[indexPath.row].postPhoto)!
            cellViewController.theLabel.load(url: URL(string: photosURL)! )
            print("THIS IS POST OBJECTS \(photosURL)")
        }
        
        return cell
    }
}

class CustomCell: UITableViewCell {
    static var cellId = "cell"

    let lblTitle: UILabel = {
        let v = UILabel()
        v.backgroundColor = .systemGreen
        v.textColor = .white
        v.textAlignment = .center
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.right.bottom.equalTo(-20)
        }
    }
}

