//
//  CoreDataManager.swift
//  Supplement_Dispenser
//
//  Created by ROLF J. on 2022/07/13.
//

import UIKit
import CoreData

class CoreDataManger {
    
    static var shared: CoreDataManger = CoreDataManger()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    let modelName = "Supplement"
    let userInformationModelname = "UserInformation"
    
    func getSupplements(ascending: Bool = false) -> [Supplement] {
        var models: [Supplement] = [Supplement]()
        
        if let context = context {
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
            do {
                if let fetchRequest: [Supplement] = try context.fetch(fetchRequest) as? [Supplement] {
                    models = fetchRequest
                }
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    func getUserInformation(ascending: Bool = false) -> [UserInformation] {
        var models: [UserInformation] = [UserInformation]()
        
        if let context = context {
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: userInformationModelname)
            do {
                if let fetchRequest: [UserInformation] = try context.fetch(fetchRequest) as? [UserInformation] {
                    models = fetchRequest
                }
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    func saveSupplement(newSupplementImage: Data, newSupplementName: String, newSingleIntake: String, newDailyIntake: String, newTakeTime: String, nfdsnNumber: String) {
        if let context = context, let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: modelName, in: context) {
            if let newSupplement: Supplement = NSManagedObject(entity: entity, insertInto: context) as? Supplement {
                newSupplement.supplementImage = newSupplementImage
                newSupplement.supplementName = newSupplementName
                newSupplement.singleIntakeCount = newSingleIntake
                newSupplement.dailyIntakeCount = newDailyIntake
                newSupplement.takeTimeString = newTakeTime
                newSupplement.nfsdnNumber = nfdsnNumber
            }
        }
        appDelegate?.saveContext()
    }
    
    func saveUserInformation(userName: String, existUser: Int16, userUUID: String) {
        if let context = context, let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: userInformationModelname, in: context) {
            if let newUserInformation: UserInformation = NSManagedObject(entity: entity, insertInto: context) as? UserInformation {
                newUserInformation.username = userName
                newUserInformation.existUser = existUser
                newUserInformation.userApplicationEntityUUID = userUUID
            }
        }
        appDelegate?.saveContext()
    }
    
    func deleteSupplement(deleteSupplementName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = supplementFilteredReuqest(filterSupplementName: deleteSupplementName)
        do {
            if let results: [Supplement] = try context?.fetch(fetchRequest) as? [Supplement] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fetch: \(error), \(error.userInfo)")
        }
        appDelegate?.saveContext()
    }
    
    func deleteUserInformation(userName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = supplementFilteredReuqest(filterSupplementName: userName)
        do {
            if let results: [UserInformation] = try context?.fetch(fetchRequest) as? [UserInformation] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fetch: \(error), \(error.userInfo)")
        }
        appDelegate?.saveContext()
    }
    
    fileprivate func supplementFilteredReuqest(filterSupplementName: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "supplementName = %@", String(filterSupplementName))
        return fetchRequest
    }
    
    fileprivate func userInformationFilteredReuqest(fitlerUserName: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: userInformationModelname)
        fetchRequest.predicate = NSPredicate(format: "supplementName = %@", String(fitlerUserName))
        return fetchRequest
    }
    
}
