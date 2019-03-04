//
//  AppointmentsTableViewController.swift
//  Test
//
//  Created by muffa-pt2531 on 28/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import UIKit

class AppointmentsTableViewController: UITableViewController
{
    @IBOutlet var listView: UITableView!
    private let viewModel = AppointmentsViewModel()
    private let date = Date.init()
    private var dateString:String!
    private var workOrderId:Int64?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.listView.dataSource = self
        
        dateString = date.iso8601
        
        refreshControl?.addTarget(self, action: #selector(self.reloadScreen(_:)), for: .valueChanged)
        

        viewModel.appointments.bind
        {   [unowned self](value) in
            DispatchQueue.main.async
            {
                self.listView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
        
        refreshControl?.beginRefreshing()
        
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.viewModel.getRecords(self.dateString)
        }
    }
    
    
    @objc func reloadScreen(_ sender:Any?)
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.viewModel.getRefreshedRecords()
        }
    }
    
    
    func reloadData(_ date:String)
    {
        self.dateString = date
        self.refreshControl?.beginRefreshing()
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.viewModel.getSortedRecords(self.dateString)
        }
    }

    
    //Table View Methods ---------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.viewModel.appointments.value.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        workOrderId = self.viewModel.appointments.value[indexPath.section].workOrderId
        performSegue(withIdentifier: "workOrder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let workOrderViewController = (segue.destination as? WorkOrderViewController)!
        workOrderViewController.workOrderId = self.workOrderId
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Appointments", for: indexPath) as! AppointmentsTableViewCell
        cell.setTextForAppointments(self.viewModel.appointments.value[indexPath.section])
        return cell
    }
}
