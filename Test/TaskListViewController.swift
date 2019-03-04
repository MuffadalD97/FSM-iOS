//
//  TaskListViewController.swift
//  Test
//
//  Created by muffa-pt2531 on 27/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import UIKit

class TaskListViewController: UITableViewController
{

    @IBOutlet var listView: UITableView!
    private let viewModel:TaskListViewModel = TaskListViewModel()
    private let refresh = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.listView.dataSource = self
        
        refresh.addTarget(self, action: #selector(self.reloadScreen(_:)), for: .valueChanged)
        
        tableView.addSubview(refresh)
        
        
        viewModel.tasks.bind
        {   [unowned self](value) in
            DispatchQueue.main.async
            {
                self.listView.reloadData()
                self.refresh.endRefreshing()
            }
        }
        
        refresh.beginRefreshing()
        
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.viewModel.getRecords()
        }
        
    }
    
    @objc func reloadScreen(_ sender:Any?)
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.viewModel.getRefreshedRecords()
        }
    }

}


extension TaskListViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.viewModel.tasks.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "tasks")!
        let text = self.viewModel.tasks.value[indexPath.row].subject
        cell.textLabel?.text = text
        return cell
    }
}
