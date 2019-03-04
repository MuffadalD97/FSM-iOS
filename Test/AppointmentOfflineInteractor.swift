//
//  AppointmentOfflineInteractor.swift
//  Test
//
//  Created by muffa-pt2531 on 04/03/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import SQLite

class AppointmentOfflineInteractor
{
    //Appointments Table
    private let appointmentsNameColumn = Expression<String>("Name")
    private let appointmentsStatusColumn = Expression<String>("Event_Status")
    private let appointmentsFromColumn = Expression<String>("Start_Date_Time")
    private let appointmentsToColumn = Expression<String>("End_Date_Time")
    private let appointmentsDescColumn = Expression<String>("Description")
    private let appointmentsContactColumn = Expression<String>("Contact")
    private let appointmentsWorkOrderIdColumn = Expression<Int64?>("Work_Order_Id")
    private let appointments = Table("Appointments")
    
    //Work Orders Table
    private let workOrdersIdColumn = Expression<Int64>("Id")
    private let workOrdersTransactionNameColumn = Expression<String>("Transaction_Name")
    private let workOrdersOwnerNameColumn = Expression<String>("Owner_Name")
    private let workOrders = Table("Work_Orders")
    
    //Delegate
    var delegate:AppointmentOfflineInteractorDelegate!
    
    private var db:Connection?
    
    //Appointments Model
    private var appointmentsData:[Appointments] = [Appointments]()
    
    //WorkOrders Model
    private var workOrdersData:[WorkOrders] = [WorkOrders]()
    
    init()
    {
        DB.run
        db = DB.db
    }
    
    //Appointments Data -----------------------------------------------------
    func getAppointmentRecords()
    {
        appointmentsData.removeAll()
        do
        {
            //            try db?.run(appointments.delete())
            for appointment in try (db?.prepare(appointments))!
            {
                let name = try appointment.get(appointmentsNameColumn)
                let status = try appointment.get(appointmentsStatusColumn)
                let from = try appointment.get(appointmentsFromColumn)
                let to = try appointment.get(appointmentsToColumn)
                let desc = try appointment.get(appointmentsDescColumn)
                let contact = try appointment.get(appointmentsContactColumn)
                let workOrderId = try appointment.get(appointmentsWorkOrderIdColumn)
                appointmentsData.append(Appointments(name, status, from, to, desc, contact, workOrderId))
            }
            if(try db?.scalar(appointments.count) == 0)
            {
                delegate.tableEmpty()
            }
            else
            {
                delegate.offlineRecordsFetched(appointmentsData)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func setAppointmentRecords(_ appointmentsData:[Appointments])
    {
        let isChanged = (!self.appointmentsData.elementsEqual(appointmentsData, by:{(appointment1, appointment2) -> Bool in
            appointment1.name == appointment2.name
        }))             //Appointment Name is not unique!!
        
        if(isChanged)
        {
            do
            {
                self.appointmentsData = appointmentsData
                try db?.run(appointments.create(ifNotExists: true)
                { t in
                    t.column(appointmentsNameColumn,defaultValue: nil)
                    t.column(appointmentsStatusColumn,defaultValue: nil)
                    t.column(appointmentsFromColumn,defaultValue: nil)
                    t.column(appointmentsToColumn,defaultValue: nil)
                    t.column(appointmentsDescColumn,defaultValue: nil)
                    t.column(appointmentsContactColumn,defaultValue: nil)
                    t.column(appointmentsWorkOrderIdColumn,defaultValue: nil)
                })
                
                try db?.run(appointments.delete())
                
                for appointment in appointmentsData
                {
                    try db?.run(appointments.insert(appointmentsNameColumn <- appointment.name, appointmentsStatusColumn <- appointment.status, appointmentsFromColumn <- appointment.from, appointmentsToColumn <- appointment.to, appointmentsDescColumn <- appointment.desc, appointmentsContactColumn <- appointment.contact, appointmentsWorkOrderIdColumn <- appointment.workOrderId))
                    print("row added in Appointments")
                }
            }
            catch
            {
                print(error)
            }
        }
    }
    
    func setWorkOrderRecords(_ workOrdersData:[WorkOrders])
    {
        let isChanged = (!self.workOrdersData.elementsEqual(workOrdersData, by:{(workOrder1, workOrder2) -> Bool in
            workOrder1.id == workOrder2.id
        }))
        
        if(isChanged)
        {
            do
            {
                self.workOrdersData = workOrdersData
                try db?.run(workOrders.create(ifNotExists: true)
                { t in
                    t.column(workOrdersIdColumn,primaryKey: true, defaultValue: nil)
                    t.column(workOrdersTransactionNameColumn,defaultValue: nil)
                    t.column(workOrdersOwnerNameColumn,defaultValue: nil)
                })
                
                try db?.run(workOrders.delete())
                
                for workOrder in workOrdersData
                {
                    try db?.run(workOrders.insert(workOrdersIdColumn <- workOrder.id, workOrdersTransactionNameColumn <- workOrder.transactionName,workOrdersOwnerNameColumn <- workOrder.ownerName))
                    print("row added in Work Orders")
                }
            }
            catch
            {
                print(error)
            }
        }
    }
}
