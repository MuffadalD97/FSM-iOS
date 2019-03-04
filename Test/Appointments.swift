//
//  Appointments.swift
//  Test
//
//  Created by muffa-pt2531 on 28/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation

class Appointments
{
    var name:String!
    var status:String!
    var from:String!
    var to:String!
    var desc:String!
    var contact:String!
    var workOrderId:Int64?
    
    init()
    {
        
    }
    
    init(_ name:String, _ status:String, _ from:String, _ to:String, _ desc:String, _ contact:String, _ workOrderId:Int64?)
    {
        self.name = name
        self.status = status
        self.from = from
        self.to = to
        self.desc = desc
        self.contact = contact
        self.workOrderId = workOrderId
    }
}
