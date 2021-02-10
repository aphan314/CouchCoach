import Foundation
import EventKit
import EventKitUI


class CalendarManager {
    static let shared = CalendarManager()
    var eventStore: EKEventStore?
    
    var isAuthorized: Bool {
        return EKEventStore.authorizationStatus(for: .event) == .authorized
    }
    
    private init() {
        self.eventStore = EKEventStore()
        if EKEventStore.authorizationStatus(for: .event) == .notDetermined {
            self.eventStore?.requestAccess(to: .event, completion: { granted, error in
                
            })
        }
        
    }
    
    var events: [EKEvent] {
        
        guard isAuthorized, let eventStore = eventStore else { return [] }
        
        let calendars = eventStore.calendars(for: .event)
        var totalEvents = [EKEvent]()
        for calendar in calendars {
            let today = NSDate(timeIntervalSinceNow: 0)
            let oneWeekAfter = NSDate(timeIntervalSinceNow: +7*24*3600)
            let predicate = eventStore.predicateForEvents(withStart: today as Date, end: oneWeekAfter as Date, calendars: [calendar])

            totalEvents.append(contentsOf: eventStore.events(matching: predicate))
        }
        return totalEvents
    }
}
