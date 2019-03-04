//
//  TaskOnlineInteractor.swift
//  Test
//
//  Created by muffa-pt2531 on 28/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import ZCRMiOS

protocol TaskOnlineInteractorDelegate:class
{
    func recordsFetched(_ tasks:[Tasks])
}

class TaskOnlineInteractor
{
    private var records: [ZCRMRecord] = [ZCRMRecord]()
    private var tasks:[Tasks] = [Tasks]()
    weak var delegate:TaskOnlineInteractorDelegate!
    
    func getRecords()
    {
        tasks.removeAll()
        do
        {
            let moduleData: ZCRMModule = ZCRMModule(moduleAPIName: "Tasks")
            self.records = try moduleData.getRecords().getData() as! [ZCRMRecord]
            for record in records
            {
                let fullName = try record.getValue(ofField: "Subject") as? String
                tasks.append(Tasks(fullName))
            }
            delegate.recordsFetched(tasks)
        }
        catch
        {
            print(error)
        }
    }
}
