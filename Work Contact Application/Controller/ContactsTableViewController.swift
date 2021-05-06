//
//  ContactsTableViewController.swift
//  Work Contact Application
//
//  Created by karlis.stekels on 04/05/2021.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var employees = [Employee]()
    let searchController = UISearchController(searchResultsController: nil)
    let links: [String] = ["https://tallinn-jobapp.aw.ee/employee_list/", "https://tartu-jobapp.aw.ee/employee_list/"]

    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Core Data
    var persons:[Contacts]?
    var selectedPersons: [Contacts]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Employees"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        self.definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by name"
                
        if persons?.count == nil {
            fetchData()
        }
        
        if persons?.count == 0 {
            for link in links {
                loadData(from: link)
            }
            saveData()
        }
        
        let iosDeveloper = persons?.filter({ person in
            return person.position == "IOS"
        })
        print("IOS Developers = \(iosDeveloper!.count)")
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    
    //MARK: - Fetch from Core Data
    func fetchData(_ searchText: String? = nil, fname: String? = nil, lname: String? = nil) -> [Contacts]? {
        do {
            let request = Contacts.fetchRequest() as NSFetchRequest<Contacts>
            
            // Search (Filter) ByName
            if let searchWord = searchText {
                
                let pred = NSPredicate(
                    format: "name LIKE[c] %@ OR surname LIKE[c] %@ OR position LIKE[c] %@",
                    "*\(searchWord)*",
                    "*\(searchWord)*",
                    "*\(searchWord)*"
                )
                request.predicate = pred
                
            }
            

            
            if let name = fname, let surname = lname {
                let findPersonPredicate = NSPredicate(format: "name == %@ AND surname == %@", name, surname)
                request.predicate = findPersonPredicate
                
                self.selectedPersons = try context.fetch(request)
                print("Fetch data for selected row: \(selectedPersons?.count ?? 0)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return selectedPersons
            }
            
            // Sort
            let sort = NSSortDescriptor(key: "surname", ascending: true)
            request.sortDescriptors = [sort]
            
            self.persons = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            print("[Error]: Core data Fetch error!")
        }
        return nil
    }
    
    //MARK: - Save to Core Data
    func saveData() {
        for index in 0..<employees.count {
            let newPerson = Contacts(context: self.context)
            newPerson.name = employees[index].fname
            newPerson.surname = employees[index].lname
            newPerson.position = employees[index].position
            newPerson.projects = employees[index].projects
            newPerson.phone = employees[index].contact_details?["phone"]
            newPerson.email = employees[index].contact_details?["email"]
        }
        
        do {
            try self.context.save()
        } catch {
            print("[Error]: Core Data Saving Error!")
        }
        
        self.fetchData()
        
    }
    
    func loadData(from urlString: String) {
        if let url = URL(string: urlString) {
            print(url)
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonData = try? decoder.decode(Employees.self, from: json) {
            employees += jsonData.employees
            tableView.reloadData()
        } else {
            print("Parsing Error")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            fetchData()
        } else {
            fetchData(searchText)
        }
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        var positions: [String] = []
        guard let data = persons else {
            return 0
        }
        for employee in data {
            if let position = employee.position {
                if !positions.contains(position) {
                    positions.append(position)
                }
            }
        }
        return positions.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "iOS"
        case 1:
            return "Android"
        case 2:
            return "Web"
        case 3:
            return "PM"
        case 4:
            return "Tester"
        case 5:
            return "Sales"
        case 6:
            return "Others"
        default:
            print("")
        }
        
        return nil
    }
  
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return "Developer"
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
//            print(returnNumberOfRoowsInSection(for: "IOS"))
            return returnNumberOfRoowsInSection(for: "IOS")
        case 1:
//            print(returnNumberOfRoowsInSection(for: "ANDROID"))
            return returnNumberOfRoowsInSection(for: "ANDROID")
        case 2:
//            print(returnNumberOfRoowsInSection(for: "WEB"))
            return returnNumberOfRoowsInSection(for: "WEB")
        case 3:
//            print(returnNumberOfRoowsInSection(for: "PM"))
            return returnNumberOfRoowsInSection(for: "PM")
        case 4:
//            print(returnNumberOfRoowsInSection(for: "TESTER"))
            return returnNumberOfRoowsInSection(for: "TESTER")
        case 5:
//            print(returnNumberOfRoowsInSection(for: "SALES"))
            return returnNumberOfRoowsInSection(for: "SALES")
        case 6:
//            print(returnNumberOfRoowsInSection(for: "OTHER"))
            return returnNumberOfRoowsInSection(for: "OTHER")
        default:
            print("Default")
        }
        
        return 0
//        return persons?.count ?? 0
    }
    
    
    func returnNumberOfRoowsInSection(for position: String) -> Int {
        guard let personsArray = persons else {
            return 0
        }
        var counter: Int = 0
        for pos in personsArray {
//            print("Position = \"\(pos.position!)\" is equal required position \(position) [\(pos.position == position)] // counter = \(counter)")
            if pos.position == position {
                counter += 1
//                print("Counter = \(counter)")
            }
        }
        return counter
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactsTableViewCell
        
//        cell.fullNameLabel.text = "\(persons![indexPath.row].surname ?? "Last name") \(persons![indexPath.row].name ?? "First name")"
        switch indexPath.section {
        case 0:
            let iosDeveloper = persons?.filter({ person in
                return person.position == "IOS"
            })
            cell.fullNameLabel.text = "\(iosDeveloper![indexPath.row].name!) \(iosDeveloper![indexPath.row].surname!)"
            
        case 1:
            let androidDeveloper = persons?.filter({ person in
                return person.position == "ANDROID"
            })
            cell.fullNameLabel.text = "\(androidDeveloper![indexPath.row].name!) \(androidDeveloper![indexPath.row].surname!)"

        case 2:
            let webDeveloper = persons?.filter({ person in
                return person.position == "WEB"
            })
            cell.fullNameLabel.text = "\(webDeveloper![indexPath.row].name!) \(webDeveloper![indexPath.row].surname!)"
        case 3:
            let pm = persons?.filter({ person in
                return person.position == "PM"
            })
            cell.fullNameLabel.text = "\(pm![indexPath.row].name!) \(pm![indexPath.row].surname!)"
        case 4:
            let tester = persons?.filter({ person in
                return person.position == "TESTER"
            })
            cell.fullNameLabel.text = "\(tester![indexPath.row].name!) \(tester![indexPath.row].surname!)"
        case 5:
            let sales = persons?.filter({ person in
                return person.position == "SALES"
            })
            cell.fullNameLabel.text = "\(sales![indexPath.row].name!) \(sales![indexPath.row].surname!)"
        case 6:
            let other = persons?.filter({ person in
                return person.position == "OTHER"
            })
            cell.fullNameLabel.text = "\(other![indexPath.row].name!) \(other![indexPath.row].surname!)"
        default:
            return cell
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "DetailedViewID") as? ContactsViewController else {
            return
        }
        
        guard let person = persons else {
            fatalError("No data in Persons!")
        }
        
        var personName: String = "", personSurname: String = ""
        var fetchResult: [Contacts]? = nil
        
        if let cell = self.tableView.cellForRow(at: indexPath) as? ContactsTableViewCell {
            let fullname = cell.fullNameLabel.text
            let indexOfSpace = fullname?.firstIndex(of: " ")
            let indexAfterSpace = fullname?.index(after: indexOfSpace!)
            if let index = indexOfSpace {
                personName = String(fullname![..<index])
            }
            if let index = indexAfterSpace {
                personSurname = String(fullname![index...])
            }
            print("First Name: \(personName)\nSecond name: \(personSurname)")
            fetchResult = fetchData(fname: personName, lname: personSurname)

        }
                
//        vc.firstName = person[indexPath.row].name!
//        vc.lastName = person[indexPath.row].surname!
//        vc.email = person[indexPath.row].email!
//        vc.phone = person[indexPath.row].phone ?? ""
//        vc.position = person[indexPath.row].position!
//        vc.project = person[indexPath.row].projects
        
        vc.firstName = fetchResult![0].name!
        print(fetchResult![0].name!)
        vc.lastName = fetchResult![0].surname!
        print(fetchResult![0].surname!)
        vc.email = fetchResult![0].email!
        vc.phone = fetchResult![0].phone ?? ""
        vc.position = fetchResult![0].position!
        vc.project = fetchResult![0].projects
        
        print(indexPath)

        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
