//
//  WorkOrderOfflineInteractor.swift
//  Test
//
//  Created by muffa-pt2531 on 04/03/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import SQLite

class WorkOrderOfflineInteractor
{
    //Work Orders Table
    private let workOrdersIdColumn = Expression<Int64>("Id")
    private let workOrdersTransactionNameColumn = Expression<String>("Transaction_Name")
    private let workOrdersOwnerNameColumn = Expression<String>("Owner_Name")
    private let workOrders = Table("Work_Orders")
    
    //Delegate
    var delegate:WorkOrderOfflineInteractorDelegate!
    
    var db:Connection?
    
    init()
    {
        DB.run
        db = DB.db
    }
    
    //Work Orders Data -----------------------------------------------------
    func getWorkOrder(_ workOrderId:Int64)
    {
        var workOrderData:WorkOrders?
        do
        {
            //            try db?.run(appointments.delete())
            for workOrder in try (db?.prepare(workOrders.filter(workOrdersIdColumn == workOrderId)))!
            {
                let id = try workOrder.get(workOrdersIdColumn)
                let transactionName = try workOrder.get(workOrdersTransactionNameColumn)
                let ownerName = try workOrder.get(workOrdersOwnerNameColumn)
                workOrderData = WorkOrders(id, transactionName, ownerName)
            }
            
            delegate.offlineRecordFetched(workOrderData!)
        }
        catch
        {
            print(error)
        }
    }
}
