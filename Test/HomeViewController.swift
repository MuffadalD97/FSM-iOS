//
//
//  HomeViewController.swift
//  Test
//

import UIKit
import ZCRMiOS

class HomeViewController: UIViewController
{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userTextView: UILabel!
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ( UIApplication.shared.delegate as! AppDelegate ).loadLoginView
        {   ( success ) in
            if( success == true )
            {
                print( "Login successful" )
            }
        }
        
        self.addLogoutButton()
        self.renderNavBar()
        
        viewModel.user.bind
        {   [unowned self](value) in
            self.navigationItem.title = value.orgName
            self.userTextView.text = "Welcome, " + value.username + "!"
            self.profileImage.image = UIImage(data: value.userImage)
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        }
        
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.viewModel.getUserData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        print("Hello")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func logout(_ sender: Any)
    {
        
        ( UIApplication.shared.delegate as! AppDelegate ).logout { (success) in
            
            if success {
                print("logout successfull")
            }
        }
    }
    
    @objc private func showContacts(_ sender: Any)
    {
        performSegue(withIdentifier: "contactListView", sender: self)
    }
    
    @objc private func showTasks(_ sender: Any)
    {
        performSegue(withIdentifier: "taskListView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("Muffi")
    }
    
    private func renderNavBar()
    {
        self.navigationController?.navigationBar.tintColor = .green
        let attrs = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 22)]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 11/255, green: 94/255, blue: 122/255, alpha: 0)
        
    }
    
    
    private func addLogoutButton()
    {
        let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setBackgroundImage(UIImage(named: "logoutIcon"), for: .normal)
        button.addTarget(self, action: #selector(self.logout(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
}
