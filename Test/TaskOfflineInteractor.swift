//
//  TaskOfflineInteractor.swift
//  Test
//
//  Created by muffa-pt2531 on 04/03/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import SQLite

class TaskOfflineInteractor
{
    //Tasks Table
    private let tasksNameColumn = Expression<String?>("Name")
    private let tasks = Table("Tasks")
    
    //Delegate
    var delegate:TaskOfflineInteractorDelegate!
    
    private var db:Connection?
    
    //Tasks Model
    private var tasksData:[Tasks] = [Tasks]()
    
    init()
    {
        DB.run
        db = DB.db
    }
    
    //Tasks Data -----------------------------------------------------
    func getTaskRecords()
    {
        tasksData.removeAll()
        do
        {
            for task in try (db?.prepare(tasks))!
            {
                let subject = try task.get(tasksNameColumn)
                tasksData.append(Tasks(subject))
            }
            if(try db?.scalar(tasks.count) == 0)
            {
                delegate.tableEmpty()
            }
            else
            {
                delegate.offlineRecordsFetched(tasksData)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func setTaskRecords(_ tasksData:[Tasks])
    {
        let isChanged = (!self.tasksData.elementsEqual(tasksData, by:{(task1, task2) -> Bool in
            task1.subject == task2.subject
        }))   //Subject is not unique!!!
        
        if(isChanged)
        {
            do
            {
                self.tasksData = tasksData
                try db?.run(tasks.create(ifNotExists: true)
                { t in
                    t.column(tasksNameColumn,defaultValue: nil)
                })
                
                try db?.run(tasks.delete())
                
                for task in tasksData
                {
                    let subject = task.subject
                    try db?.run(tasks.insert(tasksNameColumn <- subject))
                    print("row added in Tasks")
                }
            }
            catch
            {
                print(error)
            }
        }
    }
}
