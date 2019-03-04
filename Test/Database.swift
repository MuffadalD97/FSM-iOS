//
//  Database.swift
//  Test
//
//  Created by muffa-pt2531 on 27/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import SQLite

protocol HomeOfflineInteractorDelegate:class
{
    func offlineUserDataFetched(_ username:String, _ orgName:String, _ profilePicture:Data)
    func tableEmpty()
}

protocol ContactOfflineInteractorDelegate:class
{
    func offlineRecordsFetched(_ contacts:[Contacts])
    func tableEmpty()
}

protocol TaskOfflineInteractorDelegate:class
{
    func offlineRecordsFetched(_ tasks:[Tasks])
    func tableEmpty()
}

protocol AppointmentOfflineInteractorDelegate:class
{
    func offlineRecordsFetched(_ allAppointments:[Appointments])
    func tableEmpty()
}

protocol WorkOrderOfflineInteractorDelegate:class
{
    func offlineRecordFetched(_ workOrder:WorkOrders)
}


class Database
{
    //Database
    static private var db:Connection?
    
    //Contacts Table
    static private let contactsNameColumn = Expression<String?>("Name")
    static private let contacts = Table("Contacts")
    
    //Tasks Table
    static private let tasksNameColumn = Expression<String?>("Name")
    static private let tasks = Table("Tasks")
    
    //Appointments Table
    static private let appointmentsNameColumn = Expression<String>("Name")
    static private let appointmentsStatusColumn = Expression<String>("Event_Status")
    static private let appointmentsFromColumn = Expression<String>("Start_Date_Time")
    static private let appointmentsToColumn = Expression<String>("End_Date_Time")
    static private let appointmentsDescColumn = Expression<String>("Description")
    static private let appointmentsContactColumn = Expression<String>("Contact")
    static private let appointmentsWorkOrderIdColumn = Expression<Int64?>("Work_Order_Id")
    static private let appointments = Table("Appointments")
    
    //Work Orders Table
    static private let workOrdersIdColumn = Expression<Int64>("Id")
    static private let workOrdersTransactionNameColumn = Expression<String>("Transaction_Name")
    static private let workOrdersOwnerNameColumn = Expression<String>("Owner_Name")
    static private let workOrders = Table("Work_Orders")
    
    //Home Table
    static private let userName = Expression<String>("Full_Name")
    static private let userOrgName = Expression<String>("Organization_Name")
    static private let userImage = Expression<Data>("User_Image")
    static private let users = Table("User")
    
    //Delegates
    weak static var contactDelegate:ContactOfflineInteractorDelegate!
    weak static var homeDelegate:HomeOfflineInteractorDelegate!
    weak static var taskDelegate:TaskOfflineInteractorDelegate!
    weak static var appointmentDelegate:AppointmentOfflineInteractorDelegate!
    weak static var workOrderDelegate:WorkOrderOfflineInteractorDelegate!
    
    //Contacts Model
    static private var contactsData:[Contacts] = [Contacts]()
    
    //Tasks Model
    static private var tasksData:[Tasks] = [Tasks]()
    
    //Appointments Model
    static private var appointmentsData:[Appointments] = [Appointments]()
    
    //WorkOrders Model
    static private var workOrdersData:[WorkOrders] = [WorkOrders]()
    
    
    //Initializing Database
    class func initialize()
    {
        DB.run
        db = DB.db
    }
    
    
    //Home Data -----------------------------------------------------
    class func getUserData()
    {
        do
        {
            //try db?.run(users.delete())
            if let user = try db?.pluck(users)
            {
                homeDelegate.offlineUserDataFetched(try user.get(userName), try user.get(userOrgName), try user.get(userImage))
                print("data retrieved")
            }
            else
            {
                homeDelegate.tableEmpty()
            }
        }
        catch
        {
            print(error)
        }
    }
    
    class func setUserData(_ username:String, _ orgName:String, _ profilePicture:Data)
    {
        do
        {
            try db?.run(users.create(ifNotExists: true)
            { t in
                t.column(userName,defaultValue: "")
                t.column(userOrgName,defaultValue: "")
                t.column(userImage,defaultValue: nil)
            })
            
            let count = try db?.scalar(users.count)
            if(count == 0)
            {
                try db?.run(users.insert(userName <- username, userImage <- profilePicture, userOrgName <- orgName))
            }
            else
            {
                try db?.run(users.update(userName <- username, userImage <- profilePicture, userOrgName <- orgName))
            }
            print("data added")
        }
        catch
        {
            print(error)
        }
    }
    
    
    //Contacts Data -----------------------------------------------------
    class func getContactRecords()
    {
        contactsData.removeAll()
        do
        {
//            try db?.run(contacts.delete())
            for contact in try (db?.prepare(contacts))!
            {
                let fullName = try contact.get(contactsNameColumn)
                contactsData.append(Contacts(fullName))
            }
            if(try db?.scalar(contacts.count) == 0)
            {
                contactDelegate.tableEmpty()
            }
            else
            {
                contactDelegate.offlineRecordsFetched(contactsData)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    class func setContactRecords(_ contactsData:[Contacts])
    {
        let isChanged = (!self.contactsData.elementsEqual(contactsData, by:{(contact1, contact2) -> Bool in
            contact1.fullName == contact1.fullName
        }))     //Full Name is not unique!!
        
        if(isChanged)
        {
            do
            {
                self.contactsData = contactsData
                try db?.run(contacts.create(ifNotExists: true)
                { t in
                    t.column(contactsNameColumn,defaultValue: nil)
                })
                
                try db?.run(contacts.delete())
                
                for contact in contactsData
                {
                    let name = contact.fullName
                    try db?.run(contacts.insert(contactsNameColumn <- name))
                    print("row added in Contacts")
                }
            }
            catch
            {
                print(error)
            }
        }
    }
    
    
    //Tasks Data -----------------------------------------------------
    class func getTaskRecords()
    {
        tasksData.removeAll()
        do
        {
            for task in try (db?.prepare(tasks))!
            {
                let subject = try task.get(tasksNameColumn)
                tasksData.append(Tasks(subject))
            }
            if(try db?.scalar(tasks.count) == 0)
            {
                taskDelegate.tableEmpty()
            }
            else
            {
                taskDelegate.offlineRecordsFetched(tasksData)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    class func setTaskRecords(_ tasksData:[Tasks])
    {
        let isChanged = (!self.tasksData.elementsEqual(tasksData, by:{(task1, task2) -> Bool in
            task1.subject == task2.subject
        }))   //Subject is not unique!!!
        
        if(isChanged)
        {
            do
            {
                self.tasksData = tasksData
                try db?.run(tasks.create(ifNotExists: true)
                { t in
                    t.column(tasksNameColumn,defaultValue: nil)
                })
                
                try db?.run(tasks.delete())
                
                for task in tasksData
                {
                    let subject = task.subject
                    try db?.run(tasks.insert(tasksNameColumn <- subject))
                    print("row added in Tasks")
                }
            }
            catch
            {
                print(error)
            }
        }
    }
    
    
    //Appointments Data -----------------------------------------------------
    class func getAppointmentRecords()
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
                appointmentDelegate.tableEmpty()
            }
            else
            {
                appointmentDelegate.offlineRecordsFetched(appointmentsData)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    class func setAppointmentRecords(_ appointmentsData:[Appointments])
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
    
    
    //Work Orders Data -----------------------------------------------------
    class func getWorkOrder(_ workOrderId:Int64)
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
            
            workOrderDelegate.offlineRecordFetched(workOrderData!)
        }
        catch
        {
            print(error)
        }
    }
    
    class func setWorkOrderRecords(_ workOrdersData:[WorkOrders])
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
