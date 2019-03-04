//
//  HomeOfflineInteractor.swift
//  Test
//
//  Created by muffa-pt2531 on 04/03/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import SQLite

//protocol HomeOfflineInteractorDelegate:class
//{
//    func offlineUserDataFetched(_ username:String, _ orgName:String, _ profilePicture:Data)
//    func tableEmpty()
//}

class HomeOfflineInteractor
{
    //Home Table
    private let userName = Expression<String>("Full_Name")
    private let userOrgName = Expression<String>("Organization_Name")
    private let userImage = Expression<Data>("User_Image")
    private let users = Table("User")
    
    //Delegate
    var delegate:HomeOfflineInteractorDelegate!
    
    private var db:Connection?
    
    init()
    {
        DB.run
        db = DB.db
    }
    
    func getUserData()
    {
        do
        {
            //try db?.run(users.delete())
            if let user = try db?.pluck(users)
            {
                delegate.offlineUserDataFetched(try user.get(userName), try user.get(userOrgName), try user.get(userImage))
                print("data retrieved")
            }
            else
            {
                delegate.tableEmpty()
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func setUserData(_ username:String, _ orgName:String, _ profilePicture:Data)
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
}
