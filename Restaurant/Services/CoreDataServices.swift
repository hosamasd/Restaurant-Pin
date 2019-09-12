//
//  CoreDataServices.swift
//  Restaurant
//
//  Created by hosam on 9/12/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import CoreData

class CoreDataServices {
    
    static let shared  = CoreDataServices()
    
    func saveDataToCoreData(completion: (Error?)->Void)  {
        do {
            try context.save()
            completion(nil)
        } catch let err {
            completion(err)
        }
    }
    
    func loadDataFromCoreData( completion: ([Restaurant]?,Error?)->Void)  {
        let request:NSFetchRequest = Restaurant.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            completion(results,nil)
        } catch let err {
            completion(nil,err)
        }
    }
    
    func deleteDataFromCoreData(index: Int,rest:Restaurant,restArray: inout [Restaurant], completion: (Error?)->Void)  {
        
        
        context.delete(rest)
        restArray.remove(at: index)
        
        saveDataToCoreData(completion: completion)
    }
    
    func createNewRestaruant(index: [String],visited:Bool,image:UIImage,completion: (Error?)->Void)  {
        
        let rest = Restaurant(context: context)
        rest.name = index[0]
        rest.type = index[1]
        rest.location = index[2]
        rest.phone = index[3]
        rest.isVisited = visited
        let data = image.pngData()
        rest.image = data
       
        saveDataToCoreData(completion: completion)
    }
    
}
