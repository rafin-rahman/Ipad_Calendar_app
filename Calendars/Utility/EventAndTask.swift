import UIKit

class EventAndTask{
    static func editEventAndTask(profile:Profile, profileName: String, profileColor: String){
        let eventDAO = EventDAO()
        let taskDAO = TaskDAO()
        eventDAO.getAllEventFromProfile(profileName: profile.profileName)
        taskDAO.getAllTasksFromProfile(profile: profile.profileName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for event in eventDAO.eventList{
                event.profile = profileName
                event.profileColour = profileColor
                eventDAO.editEvent(updatedEvent: event)
            }
            
            for task in taskDAO.taskList{
                task.profile = profileName
                task.profileColour = profileColor
                taskDAO.editTask(updatedTask: task)
            }
        }
    }
    
}
