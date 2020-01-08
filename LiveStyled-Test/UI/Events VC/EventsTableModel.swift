//
//  EventsTableModel.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/6/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage
import CoreData

class EventsTableModel: NSObject {
    var modelChangedPublisher = PassthroughSubject<Void, Never>()
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LiveStyled_Test")
        
        container.loadPersistentStores { (description, error) in }
        
        return container
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<EventObject> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<EventObject> = EventObject.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    private let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        
        subscribeToDBChanges()
        fetchEventsFromStore()
    }
    
    func numberOfRows() -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func event(at indexPath: IndexPath) -> EventObject? {
        let eventObject = fetchedResultsController.object(at: indexPath)
        
        return eventObject
    }
    
    func add(image: UIImage, for event: EventObject) {
        event.imageData = image.pngData()
        
        do {
            try update(event: event)
        } catch {
            print("Could not save image: \(error.localizedDescription)")
        }
    }
    
    //MARK:- Core Data Helpers
    func subscribeToDBChanges() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedObjectContext.persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
        }
        
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .receive(on: RunLoop.main)
            .map { notification in }
            .sink(receiveValue: { [weak self] _ in
                self?.fetchEventsFromStore()
                self?.modelChangedPublisher.send()
            })
            .store(in: &cancellables)
    }
    
    func fetchEventsFromStore() {
        do {
            try self.fetchedResultsController.performFetch()
            print("Fetch completed")
        } catch {
            print("Error fetching: \(error.localizedDescription)")
        }
    }
    
    //MARK:- Core Data Helper Functions
    func save(events: [Event]) {
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return
//        }
//
//        let context = appDelegate.persistentContainer.viewContext
        
        let context = managedObjectContext
        
        context.perform {
            for event in events {
                autoreleasepool {
                    guard let entity = NSEntityDescription.entity(forEntityName: "EventObject", in: context) else {
                        return
                    }
                    
                    let eventObj = NSManagedObject(entity: entity,
                                                   insertInto: context)
                    
                    eventObj.setValue(event.title, forKeyPath: "title")
                    eventObj.setValue(event.id, forKey: "id")
                    eventObj.setValue(event.image, forKey: "image")
                    eventObj.setValue(event.startDate, forKey: "startDate")
                    eventObj.setValue(false, forKey: "favourited")
                }
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func update(event: EventObject) throws {
        guard let eventID = event.id else {
            throw CoreDataError.fetchError
        }
        
        let context = managedObjectContext
        
        let fetchRequest: NSFetchRequest<EventObject> = EventObject.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", eventID)
        
        fetchRequest.predicate = predicate
        
        let fetchedObjects = try context.fetch(fetchRequest)
        
        guard fetchedObjects.count == 1, let object = fetchedObjects.first else {
            print("Fetched objects: \(fetchedObjects.count)")
            throw CoreDataError.fetchError
        }
        
        object.title = event.title
        object.id = event.title
        object.image = event.image
        object.imageData = event.imageData
        object.favourited = event.favourited
        object.startDate = event.startDate
        
        try context.save()
    }
}

extension EventsTableModel {
    static var empty: EventsTableModel {
        return EventsTableModel()
    }
}

extension EventsTableModel: NSFetchedResultsControllerDelegate {
    
}
