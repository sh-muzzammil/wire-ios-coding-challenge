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

import Foundation
import CoreData

final class FetchedResults<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {

    // MARK: - Properties

    @Published
    private(set) var results = [T]()

    // MARK: - Dependencies

    private let controller: NSFetchedResultsController<T>

    // MARK: - Life cycle

    init(
        request: NSFetchRequest<T>,
        context: NSManagedObjectContext
    ) {
        controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        do {
            try controller.performFetch()
            results = controller.fetchedObjects ?? []
        } catch {
            print("failed to fetch items: \(error)")
        }
    }

    // MARK: - Methods

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        results = self.controller.fetchedObjects ?? []
    }

}

