## Architecture and Design

In this section we'll describe the logical and physical architectures of our project.


### Logical Architecture

#### Notification System
- App Screens: Responsible for screen elements and receiving user interaction.
- Notifications User Logic: Responsible for processing user interactions that change the preferences of notifications.
- Database: Communication between database. Data can be retrieved, updated and also stored.
- Notifications Scheduler: Responsible for scheduling a notification on the system based on the user preferences.
- External Events Handler: Responsible for updating the possible notifications for user, getting/updating new events, classes, and tests.

#### External services
- Sigarra: Service where app can retrieve new info.
- Moodle: Service where app can retrieve new info.
- Mobile Notification System: Mobile OS Service that provides interaction with notification the notifications system.

 <p align="center" justify="center">
  <img src="https://github.com/LEIC-ES-2021-22/2LEIC11T2/blob/main/images/Logical%20Architecture.png"/>
</p>


### Physical architecture
For the frontend we used Flutter/Dart and decided to keep the database as a local SQLITE file, so it is kept in the User Phone.

 <p align="center" justify="center">
  <img src="https://github.com/LEIC-ES-2021-22/2LEIC11T2/blob/main/images/Physical%20Architecture.png"/>
</p>

