//
//  TaskListViewModel.swift
//  Test
//
//  Created by muffa-pt2531 on 27/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation

class TaskListViewModel
{
    private let onlineInteractor = TaskOnlineInteractor()
    private let offlineInteractor = TaskOfflineInteractor()
    
    var tasks:Box<[Tasks]> = Box([Tasks]())
    
    init()
    {
        onlineInteractor.delegate = self
//        Database.taskDelegate = self
        offlineInteractor.delegate = self
    }
    
    func getRecords()
    {
//        Database.getTaskRecords()
        offlineInteractor.getTaskRecords()
    }
    
    func getRefreshedRecords()
    {
        onlineInteractor.getRecords()
    }
    
}



extension TaskListViewModel:TaskOnlineInteractorDelegate
{
    func recordsFetched(_ tasks: [Tasks])
    {
        self.tasks.value = tasks
//        Database.setTaskRecords(tasks)
        offlineInteractor.setTaskRecords(tasks)
    }
}



extension TaskListViewModel:TaskOfflineInteractorDelegate
{
    func offlineRecordsFetched(_ tasks: [Tasks])
    {
        self.tasks.value = tasks
    }
    
    func tableEmpty()
    {
        onlineInteractor.getRecords()
    }
}
