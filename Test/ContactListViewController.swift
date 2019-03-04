//
//  ListViewController.swift
//   Test
//

import UIKit

class ContactListViewController: UITableViewController
{

	@IBOutlet var listView: UITableView!
    private let viewModel:ContactListViewModel = ContactListViewModel()
    private let refresh = UIRefreshControl()
    
	override func viewDidLoad()
    {
		super.viewDidLoad()
		self.listView.dataSource = self
        
        refresh.addTarget(self, action: #selector(self.reloadScreen(_:)), for: .valueChanged)
        
        tableView.addSubview(refresh)
        
        
        viewModel.contacts.bind
        {   (value) in
            DispatchQueue.main.async
            {
                print("Main")
                self.listView.reloadData()
                self.refresh.endRefreshing()
            }
        }
        
        refresh.beginRefreshing()
        
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.viewModel.getRecords()
        }
    
	}
    
    @objc func reloadScreen(_ sender:Any?)
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.viewModel.getRefreshedRecords()
        }
    }
}

extension ContactListViewController
{
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
		return self.viewModel.contacts.value.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
		
		let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        let text = self.viewModel.contacts.value[indexPath.row].fullName
        cell.textLabel?.text = text
		return cell
	}
}
