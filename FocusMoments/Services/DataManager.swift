// DataManager - CoreData Management
import Foundation
import CoreData
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()

    let container: NSPersistentContainer

    @Published var focusSessions: [FocusSession] = []

    private init() {
        container = NSPersistentContainer(name: "FocusMoments")

        // Configure for automatic lightweight migration
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("CoreData error: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        fetchAllSessions()
    }

    // MARK: - Save Focus Session
    func saveFocusSession(sceneName: String, duration: Int, isCompleted: Bool = true) {
        let context = container.viewContext

        let session = FocusSession(context: context)
        session.id = UUID()
        session.date = Date()
        session.duration = Int16(duration)
        session.sceneName = sceneName
        session.isCompleted = isCompleted
        session.createdAt = Date()

        do {
            try context.save()
            fetchAllSessions()
        } catch {
            print("Failed to save focus session: \(error)")
        }
    }

    // MARK: - Fetch All Sessions
    func fetchAllSessions() {
        let request: NSFetchRequest<FocusSession> = FocusSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusSession.date, ascending: false)]

        do {
            focusSessions = try container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch sessions: \(error)")
            focusSessions = []
        }
    }

    // MARK: - Get Total Session Count
    var totalSessionCount: Int {
        focusSessions.filter { $0.isCompleted }.count
    }

    // MARK: - Get Today's Session Count
    var todaySessionCount: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return focusSessions.filter { session in
            guard let date = session.date, session.isCompleted else { return false }
            return calendar.isDate(date, inSameDayAs: today)
        }.count
    }

    // MARK: - Get This Week's Session Count
    var weekSessionCount: Int {
        let calendar = Calendar.current
        let today = Date()
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return 0
        }
        return focusSessions.filter { session in
            guard let date = session.date, session.isCompleted else { return false }
            return date >= weekStart
        }.count
    }

    // MARK: - Get Total Focus Minutes
    var totalFocusMinutes: Int {
        focusSessions.filter { $0.isCompleted }.reduce(0) { $0 + Int($1.duration) }
    }

    // MARK: - Get Sessions for Date
    func sessions(for date: Date) -> [FocusSession] {
        let calendar = Calendar.current
        return focusSessions.filter { session in
            guard let sessionDate = session.date, session.isCompleted else { return false }
            return calendar.isDate(sessionDate, inSameDayAs: date)
        }
    }

    // MARK: - Get Dates with Sessions (for Calendar)
    func datesWithSessions() -> Set<Date> {
        let calendar = Calendar.current
        var dates = Set<Date>()
        for session in focusSessions where session.isCompleted {
            if let date = session.date {
                let startOfDay = calendar.startOfDay(for: date)
                dates.insert(startOfDay)
            }
        }
        return dates
    }

    // MARK: - Delete Session
    func deleteSession(_ session: FocusSession) {
        let context = container.viewContext
        context.delete(session)
        do {
            try context.save()
            fetchAllSessions()
        } catch {
            print("Failed to delete session: \(error)")
        }
    }
}
