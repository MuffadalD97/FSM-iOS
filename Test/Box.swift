//
//  Box.swift
//  Test
//
//  Created by muffa-pt2531 on 27/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import Foundation

class Box<T>
{
    typealias Listener = (T) -> Void
    var listener:Listener?
    
    func bind (listener:Listener?)
    {
        self.listener = listener
    }
    
    var value:T
    {
        didSet
        {
            listener?(value)
        }
    }
    
    init(_ value: T)
    {
        self.value = value
    }
}
