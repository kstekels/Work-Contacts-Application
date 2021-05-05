//
//  ContactsViewController.swift
//  Work Contact Application
//
//  Created by karlis.stekels on 04/05/2021.
//

import UIKit

class ContactsViewController: UIViewController {
    
    @IBOutlet var fnameLabel: UILabel!
    @IBOutlet var lnameLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var projectsTableView: UITableView!
    @IBOutlet var mainInfoTablView: UITableView!
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phone: String?
    var position: String = ""
    var project: [String]?
    
    let titles = ["POSITION", "E-MAIL", "PHONE NUMBER"]
    var infoDataArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoDataArray = [position, email, phone ?? ""]

        
    }


}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == projectsTableView {
            return project?.count ?? 0
        }else if tableView == mainInfoTablView {
            return infoDataArray.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == projectsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ContactsDetailsTableViewCell
            cell.projectLabel.text = project![indexPath.row]
            return cell
        } else if tableView == mainInfoTablView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as! InfoTableViewCell
            if !(infoDataArray[indexPath.row] == "") {
                cell.infoTitleLabel.text = titles[indexPath.row]
                cell.infoSubtitleLabel.text = infoDataArray[indexPath.row]
            } else {
                cell.infoTitleLabel.text = nil
                cell.infoSubtitleLabel.text = nil
            }
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == projectsTableView {
            return "Projects"
        }
        return nil
    }
    
}
