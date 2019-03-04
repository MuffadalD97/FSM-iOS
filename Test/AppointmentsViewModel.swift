//
//  AppointmentsViewModel.swift
//  Test
//
//  Created by muffa-pt2531 on 28/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation

class AppointmentsViewModel
{
    private let onlineInteractor = AppointmentOnlineInteractor()
    private let offlineInteractor = AppointmentOfflineInteractor()
    
    var appointments:Box<[Appointments]> = Box([Appointments]())
    private var allAppointments:[Appointments] = [Appointments]()
    private var sortedAppointments:[Appointments] = [Appointments]()
    private var date:String!
    
    private let fromDateFormat:DateFormatter = DateFormatter()
    private let toDateFormat:DateFormatter = DateFormatter()
    private let toAppointmentDateFormat:DateFormatter = DateFormatter()
    
    init()
    {
        onlineInteractor.delegate = self
//        Database.appointmentDelegate = self
        offlineInteractor.delegate = self
        
        fromDateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        toDateFormat.dateFormat = "MMM d, h:mm a"
        toAppointmentDateFormat.dateFormat = "MM/dd/yyyy"
    }
    
    func getRecords(_ date:String)
    {
        self.date = date
//        Database.getAppointmentRecords()
        offlineInteractor.getAppointmentRecords()
    }
    
    func getRefreshedRecords()
    {
        onlineInteractor.getRecords()
    }
    
    func getWorkOrderId()
    {
        
    }
    
    
    func getSortedRecords(_ date:String)
    {
        sortedAppointments.removeAll()
        self.date = date
        print("Count=\(allAppointments.count)")
        
        for appointment in allAppointments
        {
            var from = appointment.from
            var to = appointment.to
            
            let fromTime = fromDateFormat.date(from: from!)!
            let dateTime = fromDateFormat.date(from: date)!
            
            if toAppointmentDateFormat.string(from: fromTime) == toAppointmentDateFormat.string(from: dateTime)
            {
                if let fromTime = fromDateFormat.date(from: from!)
                {
                    from = toDateFormat.string(from: fromTime)
                }
                else
                {
                    from = "-"
                }
                
                if let toTime = fromDateFormat.date(from: to!)
                {
                    to = toDateFormat.string(from: toTime)
                }
                else
                {
                    to = "-"
                }
                sortedAppointments.append(Appointments(appointment.name!, appointment.status!, from!, to!, appointment.desc!, appointment.contact!, appointment.workOrderId))
            }
        }
        print("Count=\(sortedAppointments.count)")
        self.appointments.value = sortedAppointments
    }
}



extension AppointmentsViewModel:AppointmentOnlineInteractorDelegate
{
    func onlineRecordsFetched(_ allAppointments:[Appointments], _ workOrders:[WorkOrders])
    {
        self.allAppointments = allAppointments
        getSortedRecords(date)
//        Database.setAppointmentRecords(allAppointments)
        offlineInteractor.setAppointmentRecords(allAppointments)
        for workOrder in workOrders
        {
            print(workOrder.id)
        }
//        Database.setWorkOrderRecords(workOrders)
        offlineInteractor.setWorkOrderRecords(workOrders)
    }
}



extension AppointmentsViewModel:AppointmentOfflineInteractorDelegate
{
    func offlineRecordsFetched(_ allAppointments: [Appointments])
    {
        self.allAppointments = allAppointments
        getSortedRecords(date)
    }
    
    func tableEmpty()
    {
        onlineInteractor.getRecords()
    }
}
