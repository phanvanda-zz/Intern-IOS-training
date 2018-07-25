//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Da on 7/24/18.
//  Copyright © 2018 Da. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datasTableView: UITableView!
    private let keyProperty = "name"
    private let entityName = "Person"
    private var objectDatas = [NSManagedObject]()
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: Function
    
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    private func getData() {
        guard let context = getContext() else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let results = try context.fetch(request)
            guard let datas = results as? [NSManagedObject] else {
                return
            }
            objectDatas = datas
            datasTableView.reloadData()
            nameTextField.text = nil
            nameTextField.resignFirstResponder()
        } catch {
            print("Error while get data")
        }
    }
    
    private func saveData() {
        guard let context = getContext(), let name = nameTextField.text, let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(name, forKey: keyProperty)
        do {
            try context.save()
            getData()
        } catch {
            print("Error while get data")
        }
    }
    private func updateData() {
        guard let context = getContext(), let name = nameTextField.text else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "\(keyProperty) = %@", name)
        do {
            let results = try context.fetch(request)
            guard let datas = results as? [NSManagedObject],
                  let object = datas.first,
                  let oldName = object.value(forKey: keyProperty)
            else { return }
            object.setValue("\(oldName) - UPDATED", forKey: keyProperty)
            try context.save()
            getData()
        } catch {
            print("Error while update data")
        }
    }
    private func deleteData() {
        guard let context = getContext(), let name = nameTextField.text else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "\(keyProperty) = %@", name)
        do {
            let results = try context.fetch(request)
            guard let datas = results as? [NSManagedObject],
                let object = datas.first
                else { return }
            context.delete(object)
            try context.save()
            getData()
        } catch {
            print("Error while delete data")
        }
    }
    // MARK: Action
    
    @IBAction func buttonSaveAction(_ sender: Any) {
        saveData()
    }
    @IBAction func buttonUpdateAction(_ sender: Any) {
        updateData()
    }
    @IBAction func buttonDeleteAction(_ sender: Any) {
        deleteData()
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectDatas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = objectDatas[indexPath.row].value(forKey: keyProperty) as? String
        return cell
    }
}








