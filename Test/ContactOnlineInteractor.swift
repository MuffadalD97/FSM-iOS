//
//  ContactOnlineInteractor.swift
//  Test
//
//  Created by muffa-pt2531 on 27/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import ZCRMiOS

protocol ContactOnlineInteractorDelegate:class
{
    func onlineRecordsFetched(_ contacts:[Contacts])
}

class ContactOnlineInteractor
{
    private var records: [ZCRMRecord] = [ZCRMRecord]()
    private var contacts:[Contacts] = [Contacts]()
    weak var delegate:ContactOnlineInteractorDelegate!
    
    func getRecords()
    {
        contacts.removeAll()
        do
        {
            let moduleData: ZCRMModule = ZCRMModule(moduleAPIName: "Contacts")
            self.records = try moduleData.getRecords().getData() as! [ZCRMRecord]
            for record in records
            {
                let fullName = try record.getValue(ofField: "Full_Name") as? String
                contacts.append(Contacts(fullName))
            }
            delegate.onlineRecordsFetched(contacts)
        }
        catch
        {
            print(error)
        }
    }
}
