//
//  HomeViewModel.swift
//  Test
//
//  Created by muffa-pt2531 on 27/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation


class HomeViewModel
{
    private let onlineInteractor:HomeOnlineInteractor = HomeOnlineInteractor()
    private let offlineInteractor:HomeOfflineInteractor = HomeOfflineInteractor()
    
    var user:Box<User> = Box(User())
    
    init()
    {
        onlineInteractor.delegate = self
//        Database.homeDelegate = self
        offlineInteractor.delegate = self
//        Database.initialize()
    }
    
    
    func getUserData()
    {
//        Database.getUserData()
        offlineInteractor.getUserData()
    }
}



extension HomeViewModel:HomeOnlineInteractorDelegate
{
    func onlineUserDataFetched(_ username: String, _ orgName: String, _ profilePicture: Data)
    {
        self.user.value = User(username,orgName,profilePicture)
//        Database.setUserData(username, orgName, profilePicture)
        offlineInteractor.setUserData(username, orgName, profilePicture)

    }
}


extension HomeViewModel:HomeOfflineInteractorDelegate
{
    func offlineUserDataFetched(_ username:String, _ orgName:String, _ profilePicture:Data)
    {
        self.user.value = User(username,orgName,profilePicture)
    }
    
    func tableEmpty()
    {
        onlineInteractor.getUserData()
    }
}
