//
//  DataController.swift
//  SwiftPortfolio
//
//  Created by User23198271 on 11/3/20.
//

import CoreData
import SwiftUI

// class to set up Core Data and to handle interactions with it
// conforms to ObservableObject so that any view can create an instance and watch
// NSPersistentCloudKitContainer loads and manages local data and syncs to cloud
class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    // inMemory = true will store in memory as opposed to disc, and so is temporary
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Loads database on disc or creates it
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    // Method to create projects and items for testing
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            
            for j in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.creationDate = Date()
                item.completed = false
                item.project = project
                item.priority = Int16.random(in: 1...3)
                
                item.completed = Bool.random()
            }
        }
        
        try viewContext.save()
    }
    
    // save data if (and only if) another part of the app has made changes
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    // delete data if desired
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    // delete all data
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
    
    // preview to see data in canvas
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()
}



