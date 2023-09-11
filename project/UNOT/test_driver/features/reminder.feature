Feature: Add a reminder and set a time in advance to a notification
  Scenario: Write a reminder for a class
    When I open the drawer
    And I tap the "key_Notificações" button
    Then I pause for 10 seconds
    And I tap the "Aulas" button
    And I tap the "key_Sistemas Operativos (TE) - Quarta-feira" button
    Then I fill the "aulanota" field with "rever as teóricas"
    Then I expect the "aulanota" to be "rever as teóricas"
    Then I fill the "tempoaula" field with "10"
    Then I expect the "tempoaula" to be "10"
    And I tap the "confirmarau" button
    Then I expect the text "Aulas" to be present

  Scenario: Write a reminder for an exam
    When I open the drawer
    And I tap the "key_Notificações" button
    Then I pause for 10 seconds
    And I tap the "Exames" button
    And I tap the "key_IADE - EN - 22/Junho/2022" button
    Then I fill the "exnota" field with "trazer calculadora"
    Then I expect the "exnota" to be "trazer calculadora"
    Then I fill the "tempoex" field with "10"
    Then I expect the "tempoex" to be "10"
    And I tap the "confirmarex" button
    Then I expect the text "Exames" to be present

  Scenario: Write a reminder for an event
    When I open the drawer
    And I tap the "key_Notificações" button
    Then I pause for 10 seconds
    And I tap the "Eventos" button
    And I tap the "key_PRODEC Seminars" button
    Then I fill the "evnota" field with "trazer caneta"
    Then I expect the "evnota" to be "trazer caneta"
    Then I fill the "tempoev" field with "10"
    Then I expect the "tempoev" to be "10"
    And I tap the "confirmarev" button
    Then I expect the text "Eventos" to be present

  Scenario: Activate a notification for classes with default time in advance
    When I open the drawer
    And I tap the "key_Notificações" button
    Then I pause for 10 seconds
    And I tap the "Aulas" button
    And I tap the "key_Sistemas Operativos (TP) - Sexta-feira" button
    And I tap the "cancelarau" button
    Then I expect the text "Aulas" to be present


  Scenario: Activate a notification for exams with default time in advance
    When I open the drawer
    And I tap the "key_Notificações" button
    Then I pause for 10 seconds
    And I tap the "Exames" button
    And I tap the "key_TC - ER - 15/Julho/2022" button
    And I tap the "cancelarex" button
    Then I expect the text "Exames" to be present

  Scenario: Activate a notification for events with default time in advance
    When I open the drawer
    And I tap the "key_Notificações" button
    Then I pause for 10 seconds
    And I tap the "Eventos" button
    And I tap the "key_Fire Department - IEEE UP Student Branch" button
    And I tap the "cancelarev" button
    Then I expect the text "Eventos" to be present
