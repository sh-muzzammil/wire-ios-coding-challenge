//
// Wire
// Copyright (C) 2023 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import CoreData

struct PersistenceController {

    // MARK: - Properties

    let viewContext: NSManagedObjectContext

    private let container: NSPersistentContainer

    // MARK: - Life cycle

    init(
        inMemory: Bool = false,
        forceAddInitialData: Bool = false
    ) {
        container = NSPersistentContainer(name: "PlainText")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        viewContext = container.viewContext

        if forceAddInitialData {
            addInitialData()
        } else {
            addInitialDataIfNeeded()
        }
    }

    // MARK: - Helpers

    private func addInitialDataIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: "didAddInitialData") else { return }
        addInitialData()
        UserDefaults.standard.set(true, forKey: "didAddInitialData")
    }

    private func addInitialData() {
        let alice = User.insertNewObject(
            name: "Alice",
            in: viewContext
        )

        let bob = User.insertNewObject(
            name: "Bob",
            in: viewContext
        )

        let caterina = User.insertNewObject(
            name: "Caterina",
            in: viewContext
        )

        let conversation1 = Conversation.insertNewObject(
            name: "Weekend in Italy",
            participants: [alice, bob, caterina],
            in: viewContext
        )

        Message.insertNewObject(content: "Ciao Bob! Did you book the hotel?",
                                sender: alice,
                                isSent: true,
                                conversation: conversation1,
                                in: viewContext)

        Message.insertNewObject(content: "Hi Alice, yes it's all done.",
                                sender: bob,
                                isSent: true,
                                conversation: conversation1,
                                in: viewContext)

        Message.insertNewObject(content: "Awesome, I'm so excited!",
                                sender: caterina,
                                isSent: true,
                                conversation: conversation1,
                                in: viewContext)

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Failed to add initial data \(nsError), \(nsError.userInfo)")
        }
    }

}

extension PersistenceController {

    static var preview = PersistenceController(
        inMemory: true,
        forceAddInitialData: true
    )

}
