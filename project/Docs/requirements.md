## Requirements

#### Functional requirements:
- The system shall notify the students with the activities he chose with the corresponding time in advance.
- The system shall ask the students if they give permission to receive notifications from the app the first time they log in.
- The system shall send an email with a file containing information about all the activities in that month when the user exports the monthly activities file.

#### Nonfunctional requirements:
- The user can’t choose an invalid time in advance for the notifications.
- Support as many devices as possible.

### Use case model 
 
 <p align="center" justify="center">
  <img src="https://github.com/LEIC-ES-2021-22/2LEIC11T2/blob/main/images/ESof.drawio.png"/>
</p>



|||
| --- | --- |
| *Name* |  Manage notifications |
| *Actor* |  Student | 
| *Description* | Allows the student to access the tab for each different category. |
| *Preconditions* | - The user must be connected to the internet. <br> - The user must be logged in. <br> - The user must be enrolled in a course. <br> - The user must have accepted to receive notifications from the application. |
| *Postconditions* | - The user is able to enable, disable or personalize notifications for each category. |
| *Normal flow* | 1. The user opens the app on the main screen<br> 2. The user selects the notification tab.<br> 3. The system displays an user agreement message.<br> 4. If accepted the system displays the categories of notifications available.<br> |
| *Alternative flows and exceptions* | 1. The user opens the app on the main screen.<br> 2. The user selects the notification tab.<br> 3. The system displays a user agreement message.<br> 4. If rejected the system will not display the categories of notifications available. |



|||
| --- | --- |
| *Name* | Enable notifications |
| *Actor* |  Student | 
| *Description* | Allows the user to enable specific activities of different categories of notifications they want to receive. |
| *Preconditions* | - The user must be connected to the internet. <br> - The user must be logged in. <br> - The user must be enrolled in a course. <br> - There must be specific activities that trigger a new notification. |
| *Postconditions* | - The user receives a notification. |
| *Normal flow* | 1. The user opens the app on the main screen<br> 2. The user selects the notification tab.<br> 3. The system shows the categories of notifications available.<br> 4. The user chooses the desired category.<br> 5. The system displays the list of upcoming activities in the chosen category.<br> 6. The user enables the activity he wishes.<br> 7.If the category is “Aulas” the user may choose if he wants to enable notifications for both theoretical and practical classes or just one of them.<br> 8. If wanted, the user may Choose time in advance to receive the notification.<br> 9. If wanted, the user may write a reminder.<br> 10. The system delivers the notification to the user. |
| *Alternative flows and exceptions* | 1. The user opens the app on the main screen.<br> 2. The user selects the notification tab.<br> 3. The system shows the categories of notifications available.<br> 4. The user chooses the desired category.<br> 5. The system displays the list of upcoming activities in the chosen category.<br> 6. The user only confirms which ones are currently selected. |



|||
| --- | --- |
| *Name* | Disable notifications |
| *Actor* |  Student | 
| *Description* | Allows the user to disable specific activities of different categories of notifications they don’t want to receive. |
| *Preconditions* | - The user must be connected to the internet. <br> - The user must be logged in. <br> - The user must be enrolled in a course. |
| *Postconditions* | - The user stops being notified about the disabled notifications and only the selected ones are displayed in the user screen. |
| *Normal flow* | 1. The user opens the app on the main screen<br> 2. The user selects the notification tab.<br> 3. The system shows the categories of notifications available.<br> 4. The user chooses the desired category.<br> 5. The system displays the list of upcoming activities in the chosen category.<br> 6. The user disables the undesired activity.<br> 7. The system updates and only the current selection will display notifications to the users screen. |
| *Alternative flows and exceptions* | 1. The user opens the app on the main screen.<br> 2. The user selects the notification tab.<br> 3. The system shows the categories of notifications available.<br> 4. The user chooses the desired category.<br> 5. The system displays the list of upcoming activities in the chosen category.<br> 6. The user only confirms which ones are currently selected. |


|||
| --- | --- |
| *Name* | Personalize notifications |
| *Actor* |  Student | 
| *Description* | Allows the user to define a new and different time in advance to every notification rather than the default one, matching his needs, as well as changing the ringtone for each category. |
| *Preconditions* | - The user must be connected to the internet. <br> - The user must be logged in. <br> - The user must be enrolled in a course. <br> - The user must have accepted to receive notifications from the application. <br> - The time range available must be limited according to the notifications category. |
| *Postconditions* | - The system will display the notification according to the new personalization. |
| *Normal flow* | 1. The user opens the app on the main screen<br> 2. The user selects the notification tab.<br> 3. The system shows the categories of notifications available.<br> 4. The user chooses the desired category.<br> 5. The user clicks on the button that redirects him to the configurations tab.<br> 6. The user defines a new time in advance and/or a new ringtone.<br> 7. The system will display the notification according to the new personalization. |
| *Alternative flows and exceptions* | 1. The user opens the app on the main screen.<br> 2. The user selects the notification tab.<br> 3. The system shows the categories of notifications available.<br> 4. The user chooses the desired category.<br> 5. The user clicks on the button that redirects him to the configurations tab.<br> 6. The user defines an invalid time in advance.<br> 7. The system generates an error message, warning the user to select a different time.  |


|||
| --- | --- |
| *Name* | Export monthly PDF |
| *Actor* |  Student |
| *Description* | Allows the user to export a file with all the activities occurring in the current month, that file will be generated and sent to the location the user chooses. |
| *Preconditions* | - The user must be connected to the internet. <br> - The user must be logged in. <br> - The user must be enrolled in a course. |
| *Postconditions* | - The system will send a PDF to the location the user chooses with the requested file. |
| *Normal flow* | 1. The user opens the app on the main screen<br> 2. The user selects the notification tab.<br> 3. The system displays an “Exportar como PDF” option.<br> 4. The user clicks on that option.<br> 5. The system displays a screen with several options for where the PDF can be sent.<br> 6. The user chooses the location he wants and confirms he wants to receive the file.<br> 7. The system sends the file to the chosen lcoation. |
| *Alternative flows and exceptions* | 1. The user opens the app on the main screen.<br> 2. The user selects the notification tab.<br> 3. The system displays an "Exportar como PDF" Option.<br> 4. As no events and exams are occurring that month, the system will not generate the monthly file and will display a "Sem atividades no mês atual." message. |


## Domain model
![rating](https://github.com/LEIC-ES-2021-22/2LEIC11T2/blob/main/images/UML_ESof2.jpg)



### Description

- Student: The one who interacts with the system
- Notification: The main feature of the system. There are notifications for different activities.
- Classes, Exams, Events: Different types of activities.
- Classroom: The location where classes and exames take place.
- Subjects: Units of study which you enrol in as a part of your course. 





