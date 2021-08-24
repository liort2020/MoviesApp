//
//  MockedPersistentStore.swift
//  MoviesAppTests
//
//  Created by Lior Tal on 21/08/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import CoreData
import Combine
@testable import MoviesApp

final class MockedPersistentStore: Mock {
    // PersistentStore context snapshot
    struct Snapshot: Equatable {
        let insertedObjects: Int
        let updatedObjects: Int
        let deletedObjects: Int
    }
    
    enum Action: Equatable {
        case fetch(Snapshot)
        case update(Snapshot)
        case delete(Snapshot)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    lazy var inMemoryContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        return container
    }()
    
}

extension MockedPersistentStore: PersistentStore {
    func fetch<Item>(_ fetchRequest: NSFetchRequest<Item>) -> AnyPublisher<[Item], Error> {
        do {
            let context = inMemoryContainer.viewContext
            context.reset()
            let items = try context.fetch(fetchRequest)
            if Item.self is Movie.Type {
                add(.fetch(context.snapshot))
            } else {
                fatalError("Currently, we do not support \(Item.self) for tests")
            }
            return Future<[Item], Error> { promise in
                promise(.success(items))
            }.publish()
        } catch let error {
            return Fail<[Item], Error>(error: error).publish()
        }
    }
    
    func update<Item>(fetchRequest: NSFetchRequest<Item>, update: @escaping (Item) -> Void) -> AnyPublisher<Item?, Error> {
        do {
            let context = inMemoryContainer.viewContext
            context.reset()
            var item: Item
            if let itemsToUpdate = try context.fetch(fetchRequest).first {
                update(itemsToUpdate)
                item = itemsToUpdate
                add(.update(context.snapshot))
            } else {
                return Future<Item?, Error> { promise in
                    promise(.success(nil))
                }.publish()
            }
            return Future<Item?, Error> { promise in
                promise(.success(item))
            }.publish()
        } catch let error {
            return Fail<Item?, Error>(error: error).publish()
        }
    }
    
    func update<Item>(fetchRequest: NSFetchRequest<Item>, update: @escaping (Item) -> Void, createNew: @escaping (NSManagedObjectContext) -> Item) -> AnyPublisher<Item, Error> {
        do {
            let context = inMemoryContainer.viewContext
            context.reset()
            var item: Item
            if let itemsToUpdate = try context.fetch(fetchRequest).first {
                update(itemsToUpdate)
                item = itemsToUpdate
                add(.update(context.snapshot))
            } else {
                item = createNew(context)
                add(.update(context.snapshot))
            }
            return Future<Item, Error> { promise in
                promise(.success(item))
            }.publish()
        } catch let error {
            return Fail<Item, Error>(error: error).publish()
        }
    }
    
    func delete<Item: NSManagedObject>(_ fetchRequest: NSFetchRequest<Item>) -> AnyPublisher<Void, Error> {
        let context = inMemoryContainer.viewContext
        
        do {
            let itemsToDelete = try context.fetch(fetchRequest)
            itemsToDelete.forEach {
                context.delete($0)
                add(.delete(context.snapshot))
            }
            
            try context.save()
            
            return Future<Void, Error> { promise in
                promise(.success(()))
            }.publish()
        } catch let error {
            context.reset()
            return Fail<Void, Error>(error: error).publish()
        }
    }
}

fileprivate extension NSManagedObjectContext {
    var snapshot: MockedPersistentStore.Snapshot {
        MockedPersistentStore.Snapshot(insertedObjects: insertedObjects.count,
                                       updatedObjects: updatedObjects.count,
                                       deletedObjects: deletedObjects.count)
    }
}
