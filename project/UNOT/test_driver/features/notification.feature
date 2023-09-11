Feature: Open notification page and it's different categories
  The notification page we created should appear when we click on it's respective drawer option

  Scenario: Login and access the different notification pages
    When I open the drawer
    And I tap the "key_Notificações" button
    Then I expect the text "Notificações" to be present
    Then I pause for 10 seconds
    And I tap the "Aulas" button
    Then I expect the text "Aulas" to be present
    Given I tap the back button
    Then I expect the text "Notificações" to be present
    And I tap the "Exames" button
    Then I expect the text "Exames" to be present
    Given I tap the back button
    Then I expect the text "Notificações" to be present
    And I tap the "Eventos" button
    Then I expect the text "Eventos" to be present

