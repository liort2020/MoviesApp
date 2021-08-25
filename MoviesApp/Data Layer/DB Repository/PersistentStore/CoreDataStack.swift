//
//  CoreDataStack.swift
//  MoviesApp
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import CoreData
import Combine

protocol PersistentStore {
    func fetch<Item>(_ fetchRequest: NSFetchRequest<Item>) -> AnyPublisher<[Item], Error>
    func update<Item>(fetchRequest: NSFetchRequest<Item>, update: @escaping (Item) -> Void, createNew: @escaping (NSManagedObjectContext) -> Item) -> AnyPublisher<Item, Error>
    func update<Item>(fetchRequest: NSFetchRequest<Item>, update: @escaping (Item) -> Void) -> AnyPublisher<Item?, Error>
    func delete<Item: NSManagedObject>(_ fetchRequest: NSFetchRequest<Item>) -> AnyPublisher<Void, Error>
}

struct CoreDataStack: PersistentStore {
    static let modelName = "MovieModel"
    private let container: NSPersistentContainer
    private let coreDataQueue = DispatchQueue(label: "coredata_stack_queue")
    
    init() {
        container = NSPersistentContainer(name: Self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func fetch<Item>(_ fetchRequest: NSFetchRequest<Item>) -> AnyPublisher<[Item], Error> {
        Future<[Item], Error> { promise in
            let context = container.viewContext
            do {
                let resultItems = try context.fetch(fetchRequest)
                promise(.success(resultItems))
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update<Item>(fetchRequest: NSFetchRequest<Item>, update: @escaping (Item) -> Void, createNew: @escaping (NSManagedObjectContext) -> Item) -> AnyPublisher<Item, Error> {
        Future<Item, Error> { [weak container] promise in
            coreDataQueue.async {
                guard let context = container?.newBackgroundContext() else { return }
                
                context.performAndWait {
                    do {
                        var result: Item
                        if let itemsToUpdate = try context.fetch(fetchRequest).first {
                            update(itemsToUpdate)
                            result = itemsToUpdate
                        } else {
                            result = createNew(context)
                        }
                        
                        guard context.hasChanges else {
                            context.reset()
                            promise(.success(result))
                            return
                        }
                        
                        try context.save()
                        promise(.success(result))
                    } catch {
                        context.reset()
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update<Item>(fetchRequest: NSFetchRequest<Item>, update: @escaping (Item) -> Void) -> AnyPublisher<Item?, Error> {
        Future<Item?, Error> { [weak container] promise in
            coreDataQueue.async {
                guard let context = container?.newBackgroundContext() else { return }
                
                context.performAndWait {
                    do {
                        var result: Item
                        if let itemsToUpdate = try context.fetch(fetchRequest).first {
                            update(itemsToUpdate)
                            result = itemsToUpdate
                        } else {
                            context.reset()
                            promise(.success(nil))
                            return
                        }
                        
                        guard context.hasChanges else {
                            context.reset()
                            promise(.success(result))
                            return
                        }
                        
                        try context.save()
                        promise(.success(result))
                    } catch {
                        context.reset()
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete<Item: NSManagedObject>(_ fetchRequest: NSFetchRequest<Item>) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak container] promise in
            coreDataQueue.async {
                guard let context = container?.newBackgroundContext() else { return }
                
                context.performAndWait {
                    do {
                        if let itemsToDelete = try? context.fetch(fetchRequest) {
                            itemsToDelete.forEach {
                                context.delete($0)
                            }
                        }
                        guard context.hasChanges else {
                            context.reset()
                            promise(.success(()))
                            return
                        }
                        try context.save()
                        promise(.success(()))
                    } catch {
                        context.reset()
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
