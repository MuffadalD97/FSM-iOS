//
//  User.swift
//  Test
//
//  Created by muffa-pt2531 on 27/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation

class User
{
    var username:String!
    var orgName:String!
    var userImage:Data!
    
    init()
    {

    }
    
    init(_ username:String, _ orgName:String, _ userImage:Data)
    {
        self.username = username
        self.orgName = orgName
        self.userImage = userImage
    }
}
