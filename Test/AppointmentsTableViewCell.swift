//
//  AppointmentsTableViewCell.swift
//  Test
//
//  Created by muffa-pt2531 on 28/02/19.
//  Copyright © 2019 TestOrg. All rights reserved.
//

import UIKit

class AppointmentsTableViewCell: UITableViewCell
{
    @IBOutlet weak var appointmentName: UILabel!
    @IBOutlet weak var appointmentStatus: UILabel!
    @IBOutlet weak var appointmentFrom: UILabel!
    @IBOutlet weak var appointmentTo: UILabel!
    @IBOutlet weak var appointmentDesc: UILabel!
    @IBOutlet weak var contact: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    func setTextForAppointments(_ appointment:Appointments)
    {
        appointmentName.text = appointment.name
        appointmentStatus.text = appointment.status!
        appointmentFrom.text = appointment.from
        appointmentTo.text = appointment.to
        appointmentDesc.text = appointment.desc
        self.contact.text = appointment.contact
    }
}
