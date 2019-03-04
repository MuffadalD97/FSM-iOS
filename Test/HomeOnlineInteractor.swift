//
//  OnlineInteractor.swift
//  Test
//
//  Created by muffa-pt2531 on 27/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import ZCRMiOS

protocol HomeOnlineInteractorDelegate:class
{
    func onlineUserDataFetched(_ username:String, _ orgName:String, _ profilePicture:Data)
}

class HomeOnlineInteractor
{
    private let restClient : ZCRMRestClient = ZCRMRestClient()
    private var records: [ZCRMRecord] = [ZCRMRecord]()
    weak var delegate:HomeOnlineInteractorDelegate!
    
    func getUserData()
    {
        do
        {
            let currentUser: ZCRMUser = try self.restClient.getCurrentUser().getData() as! ZCRMUser
            let profilePicture: Data = try currentUser.downloadProfilePhoto().getFileData()
            let organization: ZCRMOrganisation = try self.restClient.getOrganisationDetails().getData() as! ZCRMOrganisation
            let title : String = organization.getCompanyName()
            
            delegate.onlineUserDataFetched(currentUser.getFullName()!, title, profilePicture)
        }
        catch
        {
            print(error)
        }
    }
}
