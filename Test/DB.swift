//
//  DB.swift
//  Test
//
//  Created by muffa-pt2531 on 04/03/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation
import SQLite

class DB
{
    static var db:Connection?
    
    static let run: Void =
    {
        print("Behold! \(#function) runs!")
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do
        {
            db = try Connection("\(path)/db.sqlite3")
        }
        catch
        {
            print(error)
        }
    }()
}
