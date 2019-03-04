//
//  ListViewModel.swift
//  Test
//
//  Created by muffa-pt2531 on 27/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation

class ContactListViewModel
{
    private let onlineInteractor = ContactOnlineInteractor()
    private let offlineInteractor = ContactOfflineInteractor()
    
    var contacts:Box<[Contacts]> = Box([Contacts]())
    
    init()
    {
        onlineInteractor.delegate = self
//        Database.contactDelegate = self
        offlineInteractor.delegate = self
    }
    
    func getRecords()
    {
//        Database.getContactRecords()
        offlineInteractor.getContactRecords()
    }
    
    func getRefreshedRecords()
    {
        onlineInteractor.getRecords()
    }
}



extension ContactListViewModel:ContactOnlineInteractorDelegate
{
    func onlineRecordsFetched(_ contacts:[Contacts])
    {
        self.contacts.value = contacts
//        Database.setContactRecords(contacts)
        offlineInteractor.setContactRecords(contacts)
    }
}



extension ContactListViewModel:ContactOfflineInteractorDelegate
{
    func offlineRecordsFetched(_ contacts:[Contacts])
    {
        self.contacts.value = contacts
    }
    
    func tableEmpty()
    {
        onlineInteractor.getRecords()
    }
}
