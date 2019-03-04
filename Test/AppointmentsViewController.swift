//
//  AppointmentsViewController.swift
//  Test
//
//  Created by muffa-pt2531 on 28/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import UIKit

class AppointmentsViewController: UIViewController
{
    
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var appointmentsTableViewController:AppointmentsTableViewController!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        appointmentsTableViewController = (segue.destination as? AppointmentsTableViewController)!
    }
    
    
    @IBAction func reloadData(_ sender: Any)
    {
        appointmentsTableViewController.reloadData(datePicker.date.iso8601)
    }
}

