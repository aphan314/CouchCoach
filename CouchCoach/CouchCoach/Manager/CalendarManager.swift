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

        if !(doesCalendarExist()), let eventStore = eventStore {
            let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
            newCalendar.title = "CouchCoach"
            newCalendar.source = eventStore.defaultCalendarForNewEvents?.source
            do {
                try eventStore.saveCalendar(newCalendar, commit: true)
            } catch {
                print("Error failed to create CouchCoach Calendar")
            }
        }
    }

    private func doesCalendarExist() -> Bool {
        guard let eventStore = eventStore else {
            return false
        }

        let calendars = eventStore.calendars(for: .event) as [EKCalendar]
        for calendar in calendars {
            if calendar.title == "CouchCoach" {
                return true
            }
        }
        return false
    }

    // Contains the events a user has in one week
    var events: [EKEvent] {
        
        guard isAuthorized, let eventStore = eventStore else { return [] }
        
        let calendars = eventStore.calendars(for: .event)
        var totalEvents = [EKEvent]()
        for calendar in calendars {
            if calendar.title != "US Holidays" {
                let today = NSDate(timeIntervalSinceNow: 0)
                let morning = Calendar(identifier: .gregorian).startOfDay(for: today as Date)
                let midnight = NSDate(timeInterval: +1*24*3600, since: morning)
                //let oneWeekAfter = NSDate(timeIntervalSinceNow: +7*24*3600)
                let predicate = eventStore.predicateForEvents(withStart: today as Date, end: midnight as Date, calendars: [calendar])

                    totalEvents.append(contentsOf: eventStore.events(matching: predicate))

            }
        }
        return totalEvents
    }

    // Given a date, will fetch the events for that date
    func fetchEvents(for date: Date) -> [Int: [EKEvent]]{
        guard isAuthorized, let eventStore = eventStore else { return [:] }

        let calendars = eventStore.calendars(for: .event)
        var totalEvents = [EKEvent]()
        for calendar in calendars {
            let startOfDay = getStartOfDay(date: date)
            let endOfDay = getEndOfDay(date: date)

            let predicate = eventStore.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: [calendar])

            totalEvents.append(contentsOf: eventStore.events(matching: predicate))
        }
        return sortEventsByHour(with: totalEvents)
    }

    // Given a list of events, will return a sorted list by time it starts
    func sortEventsByHour(with events: [EKEvent]) -> [Int: [EKEvent]] {
        var hourlyEvents = [Int: [EKEvent]]()
        for event in events {
            let startDateComponents = getDateComponents(from: event.startDate)
            if let hour = startDateComponents.hour {
                if hourlyEvents.keys.contains(hour) {
                    hourlyEvents[hour]?.append(event)
                } else {
                    hourlyEvents[hour] = [event]
                }
            }

        }
        return hourlyEvents
    }

    // Will insert an event into the users calendar
    func insertEvent(_ event: EKEvent) {
        guard let eventStore = eventStore else {
            return
        }
        let calendars = eventStore.calendars(for: .event)
        for calendar in calendars {
            if calendar.title == "CouchCoach" {
                do {
                    try eventStore.save(event, span: .thisEvent)
                }
                catch {
                   print("Error saving event in calendar")
                }
            }
        }
    }

    //Breaks down a date object into components to allow value to be easily accessible
    func getDateComponents(from date: Date) -> DateComponents {
        let userCalendar = Calendar.current

        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        return userCalendar.dateComponents(requestedComponents, from: date)
    }

    //This will take the time from secondDate and assign it to the firstDate
    func assignTimeToDate(firstDate: Date, secondDate: Date) -> Date {
        let userCalendar = Calendar.current

        let firstDateComponents = getDateComponents(from: firstDate)
        let secondDateComponents = getDateComponents(from: secondDate)

        var combinedDateComponents = DateComponents()
        combinedDateComponents.year = firstDateComponents.year
        combinedDateComponents.month = firstDateComponents.month
        combinedDateComponents.day = firstDateComponents.day
        combinedDateComponents.hour = secondDateComponents.hour
        combinedDateComponents.minute = secondDateComponents.minute
        combinedDateComponents.second = secondDateComponents.second

        guard let combinedDate = userCalendar.date(from: combinedDateComponents) else {
            print("Error Creating a date object")
            return Date()
        }

        return combinedDate
    }

    private func getStartOfDay(date: Date) -> Date {
        let userCalendar = Calendar.current

        let dateComponents = getDateComponents(from: date)
        var startOfDayComponents = DateComponents()
        startOfDayComponents.year = dateComponents.year
        startOfDayComponents.month = dateComponents.month
        startOfDayComponents.day = dateComponents.day
        startOfDayComponents.hour = 0
        startOfDayComponents.minute = 0
        startOfDayComponents.second = 0

        guard let startOfDay = userCalendar.date(from: startOfDayComponents) else {
            print("Error Creating a date object")
            return Date()
        }
        return startOfDay
    }

    private func getEndOfDay(date: Date) -> Date {
        let userCalendar = Calendar.current

        let dateComponents = getDateComponents(from: date)
        var endOfDayComponents = DateComponents()
        endOfDayComponents.year = dateComponents.year
        endOfDayComponents.month = dateComponents.month
        endOfDayComponents.day = dateComponents.day
        endOfDayComponents.hour = 24
        endOfDayComponents.minute = 60
        endOfDayComponents.second = 60

        guard let endOfDay = userCalendar.date(from: endOfDayComponents) else {
            print("Error Creating a date object")
            return Date()
        }
        return endOfDay
    }
}
