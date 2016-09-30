@local @local_datahub @javascript

Feature: Import a version1 file.

    Background:
        Given I log in as "admin"


    # T3?:
    Scenario: version1 basic/period schedule user import succeeds.
        Given the following scheduled Datahub jobs exist
          | label | plugin | type | params |
          | dh1 | dhimport_version1 | period | 5m |
        Then a "local_datahub_schedule" record with '{"plugin":"dhimport_version1"}' "should" exist
        And I wait "0" minutes and run cron
        And I upload file "create_user_t33_6.csv" for "version1" "user" import
        And I wait "5" minutes and run cron
        Then I should see "Running s:9:\"run_ipjob\";(ipjob_"
        Then a "user" record with '{"idnumber":"testuser","username":"testuser","firstname":"Test","lastname":"User","city":"testcity","country":"CA"}' "should" exist
        Then a "user" record with '{"username":"testuser2","firstname":"Test","lastname":"User2","city":"testcity","country":"CA"}' "should" exist

    # T3?:
    Scenario: version1 advanced schedule course import succeeds.
        Given the following scheduled Datahub jobs exist
          | label | plugin | type | params |
          | dh2a | dhimport_version1 | advanced | {"runs":3,"frequency":5,"units":"minute"} |
        Then a "local_datahub_schedule" record with '{"plugin":"dhimport_version1"}' "should" exist
        And I wait "0" minutes and run cron
        And I upload file "create_course_t33_6.csv" for "version1" "course" import
        And I wait "5" minutes and run cron
        Then I should see "Running s:9:\"run_ipjob\";(ipjob_"
        Then a "course" record with '{"shortname":"testcourse2","fullname":"testcourse2"}' "should" exist

    # T3?:
    Scenario: version1 advanced schedule enrolment import succeeds.
        Given the following "users" exist:
          | username | firstname | lastname | email |
          | testuser | Test | User | testuser@email.com |
        And the following "courses" exist:
          | fullname | shortname | format |
          | Test Cousre 2 | testcourse2 | topics |
        And the following scheduled Datahub jobs exist
          | label | plugin | type | params |
          | dh2b | dhimport_version1 | advanced | {"startdate":"+5 minutes","enddate":"+2 days"} |
        Then a "local_datahub_schedule" record with '{"plugin":"dhimport_version1"}' "should" exist
        And I wait "0" minutes and run cron
        And I upload file "version1_create_enrolment.csv" for "version1" "enrolment" import
        And I wait "5" minutes and run cron
        Then I should see "Running s:9:\"run_ipjob\";(ipjob_"
        And the following enrolments should exist
           | course | user |
           | testcourse2 | testuser |

    # T3?
    #    Given the following scheduled Datahub jobs exist
    #      | label | plugin | type | params |
    #      | dh4 | dhimport_version1 | advanced | {"startdate":"now","recurrence":"calendar","enddate":"+1 day","hour":23,"minute":55,"weekdays":"2,3,4,5,6"} |
    #    Then a "local_datahub_schedule" record with '{"plugin":"dhimport_version1"}' "should not" exist
