//
//  WorkOrderViewController.swift
//  Test
//
//  Created by muffa-pt2531 on 01/03/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import UIKit

class WorkOrderViewController: UIViewController
{
    @IBOutlet weak var transactionName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    
    let refreshControl = UIRefreshControl()
    
    var workOrderId:Int64?
    private let viewModel:WorkOrderViewModel = WorkOrderViewModel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewModel.workOrder.bind
        {   [unowned self](value) in
            DispatchQueue.main.async
            {
                self.transactionName.text = self.viewModel.workOrder.value.transactionName
                self.ownerName.text = self.viewModel.workOrder.value.ownerName
                self.refreshControl.endRefreshing()
            }
        }
        
        refreshControl.beginRefreshing()
        
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.viewModel.getRecord(self.workOrderId)
        }
    }
}
