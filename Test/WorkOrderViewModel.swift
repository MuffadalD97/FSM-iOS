//
//  WorkOrderViewModel.swift
//  Test
//
//  Created by muffa-pt2531 on 01/03/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation

class WorkOrderViewModel
{
    var workOrder:Box<WorkOrders> = Box(WorkOrders())
    
    private let offlineInteractor:WorkOrderOfflineInteractor = WorkOrderOfflineInteractor()
    
    init()
    {
//        Database.workOrderDelegate = self
        offlineInteractor.delegate = self
    }
    
    func getRecord(_ workOrderId:Int64?)
    {
        if let id = workOrderId
        {
//            Database.getWorkOrder(id)
            offlineInteractor.getWorkOrder(id)
        }
        else
        {
            workOrder.value = WorkOrders(-1,"-", "-")
        }
    }
}



extension WorkOrderViewModel:WorkOrderOfflineInteractorDelegate
{
    func offlineRecordFetched(_ workOrder: WorkOrders)
    {
        self.workOrder.value = workOrder
    }
}
