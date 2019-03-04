//
//  WorkOrder.swift
//  Test
//
//  Created by muffa-pt2531 on 01/03/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation

class WorkOrders
{
    var id:Int64!
    var transactionName:String!
    var ownerName:String!
    
    init()
    {
        
    }
    
    init(_ id:Int64,_ transactionName:String, _ ownerName:String)
    {
        self.id = id;
        self.transactionName = transactionName
        self.ownerName = ownerName
    }
}
