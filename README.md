# Q.0
The best iOS app for making office hour queues

#Developers

- Patrick Archbold
- Guillermo Alvarez

#Github Repository
https://github.com/gmoalvarez/awesome-queue/

#Description of Project

Our project is a cloud based queue app that is specifically taylored to professor's hosting student office hours. The app uses a Parse database as the backend.

#####User Accounts
The app uses Parse to set up user accounts with different roles. There are Professor accounts and User accounts.

#####Professor account
Logging in as a Professor allows the user to create a new event and print out a QR code for the event by taking a screen shot of the QR and e-mailing it to themselves. A **UIDatePicker** is used to set the start and ending time of the queue. Once the queue is created, the user can view all members of the most recently created queue from a table view that also allows for a detailed view of each student in the queue and their reason for the visit (optional).

The Professor has the ability to "de-queue" the next person in line and the student is notified with a smiley face on the screen.

#####Student account 
Logging in as a Student they will be able to join the queue by scanning the QR code with the included QR reader. If a student logs in and they are already in a queue it will automatically show their position in that queue. 

The app currently does not support joining multiple queues at the same time. If they would like to join a new queue they will have to exit their current queue and sign up for the new one.

#####Future improvements
- Currently we have the app limited to using a timer to poll the database for changes but for actual implementation we would use push notifications.
- Try to show a student the approximate waiting time using past waiting time data.


#####Bugs
There are currently 2 bugs which we are not yet able to figure out.

1. If a user logs in as a teacher and creates a new queue, if they log out and log back in as a student using the same device, they are not able to join the new queue that was just created.

2. We tried to implement a share feature for the QR code but we couldn't get it to work with CI images.
3. There is an error joining the queue if a phone is in 24 hour mode.

