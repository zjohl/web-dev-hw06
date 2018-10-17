# Task Tracker
## Zamir Johl

The main design decisions necessary for this assignment was deciding which users could access certain features. I decided to limit the user management, except for sign up, to admin users. Admin users can only be created via the db. Additionally, logged in users have a higher level of access than logged out users. There currently isn't an an audit log for task management, but it seems reasonable to want to be able to indentify users before they can create a task. 

I also added basic validation to the `time_spent` fields so that users can only input positive values that are multiples of 15. This feature, and the fact that the default user for new tasks is the current user, makes the task creation more user friendly. 
