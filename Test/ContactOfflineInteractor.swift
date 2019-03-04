//
//  ContactOfflineInteractor.swift
//  Test
//
//  Created by muffa-pt2531 on 04/03/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import SQLite

class ContactOfflineInteractor
{
    //Contacts Table
    private let contactsNameColumn = Expression<String?>("Name")
    private let contacts = Table("Contacts")
    
    //Delegate
    var delegate:ContactOfflineInteractorDelegate!
    
    private var db:Connection?
    
    //Contacts Model
    private var contactsData:[Contacts] = [Contacts]()
    
    init()
    {
        DB.run
        db = DB.db
    }
    
    //Contacts Data -----------------------------------------------------
    func getContactRecords()
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
                delegate.tableEmpty()
            }
            else
            {
                delegate.offlineRecordsFetched(contactsData)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func setContactRecords(_ contactsData:[Contacts])
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
}
