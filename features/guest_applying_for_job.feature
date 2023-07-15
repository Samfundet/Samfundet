Feature: Guest applying for jobs
    In order to get accepted into a group
    As a guest
    I want to register and apply for jobs

    Scenario: Log in with pending application
        Given I am registered with email "user@example.org" and password "secret"
        And I am not logged in
        And there are jobs titled Webutvikler
        And I am on the admissions page
        When I follow "Webutvikler"
        And I fill in the following:
            | motivation | I like programming |
        And I press "Apply for this job"
        Then I should see "Register or log in as an applicant to complete your application"
        When I fill in the following:
            | applicant_login_field    | user@example.org |
            | applicant_login_password | secret              |
        And I press "Login as applicant"
        Then I should be on user@example.org's applications page
        And I should see "Webutvikler"

    Scenario: Registering with pending application
        Given I am not logged in
        And There are jobs titled Webutvikler
        And I am on the admissions page
        When I follow "Webutvikler"
        And I fill in the following:
            | motivation | I like programming |
        And I press "Apply for this job"
        Then I should see "Register or log in as an applicant to complete your application"
        When I fill in the following:
            | applicant_firstname   | John                |
            | applicant_surname     | Doe                 |
            | applicant_phone       | 12345678            |
            | applicant_email       | johndoe@example.org |
            | applicant_password    | secret              |
            | applicant_password_confirmation | secret              |
        And I press "Register me"
        Then I should be on johndoe@example.org's applications page
        And I should see "Webutvikler"
