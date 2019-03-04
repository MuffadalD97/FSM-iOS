//
//  AppointmentOnlineInteractor.swift
//  Test
//
//  Created by muffa-pt2531 on 28/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import ZCRMiOS

protocol AppointmentOnlineInteractorDelegate:class
{
    func onlineRecordsFetched(_ appointments:[Appointments], _ workOrders:[WorkOrders])
}

class AppointmentOnlineInteractor
{
    private var records: [ZCRMRecord] = [ZCRMRecord]()
    private var workOrderRecords: [ZCRMRecord] = [ZCRMRecord]()
    private var appointments:[Appointments] = [Appointments]()
    private var workOrders:[WorkOrders] = [WorkOrders]()
    private var sortedAppointments:[Appointments] = [Appointments]()
    private var ids:[Int64] = [Int64]()
    weak var delegate:AppointmentOnlineInteractorDelegate!
    
    private let fromDateFormat:DateFormatter = DateFormatter()
    private let toDateFormat:DateFormatter = DateFormatter()
    private let toAppointmentDateFormat:DateFormatter = DateFormatter()
    
    private let moduleData: ZCRMModule = ZCRMModule(moduleAPIName: "Appointments")
    private let module: ZCRMModule = ZCRMModule(moduleAPIName: "Sales_Orders")
    
    init()
    {
        fromDateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        toDateFormat.dateFormat = "MMM d, h:mm a"
        toAppointmentDateFormat.dateFormat = "MM/dd/yyyy"
    }
    
    func getRecords()
    {
        appointments.removeAll()
        workOrders.removeAll()
        ids.removeAll()
        do
        {
            self.records = try moduleData.getRecords().getData() as! [ZCRMRecord]
            self.workOrderRecords = try module.getRecords().getData() as! [ZCRMRecord]
            
            for record in records
            {
                var name = try record.getValue(ofField: "Name") as? String
                var status = try record.getValue(ofField: "Event_Status") as? String
                var from = try record.getValue(ofField: "Start_Date_Time") as? String
                var to = try record.getValue(ofField: "End_Date_Time") as? String
                var desc = try record.getValue(ofField: "Description") as? String
                var contact = try record.getValue(ofField: "Contact") as? String
                let entity = try record.getValue(ofField: "Work_Order") as? ZCRMRecord
                let workOrderId = entity?.getId()
                if let id = workOrderId
                {
                    let contains = ids.contains
                    {   (thisId) -> Bool in
                        if(id == thisId)
                        {
                            return true
                        }
                        else
                        {
                            return false
                        }
                    }
                    
                    if(!contains)
                    {
                        ids.append(id)
                    }
                }
                
                if(name == nil)
                {
                    name = "-"
                }
                
                if(status == nil)
                {
                    status = "-"
                }
                
                if(desc == nil)
                {
                    desc = "-"
                }
                
                if(contact == nil)
                {
                    contact = "-"
                }
                
                if(from == nil)
                {
                    from = "-"
                }
                
                if(to == nil)
                {
                    to = "-"
                }
                
                appointments.append(Appointments(name!, status!, from!, to!, desc!, contact!, workOrderId))
            }
            
            for record in workOrderRecords
            {
                if(ids.contains(record.getId()))
                {
                    let transactionName = try record.getValue(ofField: "Transaction_Id") as! String
                    let ownerName = record.getOwner()?.getFullName()
                    workOrders.append(WorkOrders(record.getId(), transactionName, ownerName!))
                }
            }
            
            delegate.onlineRecordsFetched(appointments,workOrders)
        }
        catch
        {
            print(error)
        }
    }
}

