import CoreData

class StorageManager {
    static let shared = StorageManager()

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CFTNotes")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private let viewContext: NSManagedObjectContext

    private init() {
        viewContext = persistentContainer.viewContext
    }

    func create(_ noteBody: NSAttributedString) {
        let note = Note(context: viewContext)
        note.body = noteBody
        saveContext()
    }

    func fetchData(completion: (Result<[Note], Error>) -> Void) {
        let request = Note.fetchRequest()

        do {
            let noteList = try viewContext.fetch(request)
            completion(.success(noteList))
        } catch let error {
            completion(.failure(error))
        }
    }

    func update(_ note: Note, newBody: NSAttributedString) {
        note.body = newBody
        saveContext()
    }

    func delete(_ note: Note) {
        viewContext.delete(note)
        saveContext()
    }

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
