# Better API Server  

![The Better API](http://a2.mzstatic.com/us/r30/Purple4/v4/85/c4/6a/85c46af1-646e-be03-d023-2b62dd46956b/mzl.xchqgper.175x175-75.jpg)

## API

Using the API? Read on.

### Documentation

The most recent API docs are at [http://api-dev.getbetter.com/docs](http://api-dev.getbetter.com/docs).

Please ask another engineer for the *User Name* and *Password*.

#### Local

To generate API docs locally at [http://localhost:3000/docs](http://localhost:3000/docs), run:

```
% rake docs:generate
```

### Scheduled jobs

**_Muy importante!!!  The times in the cron files are in UTC!!!_**

We run scheduled jobs in all of our environments.  Here's how it's set up:

* Scheduled jobs are executed via the system cron
* The crontab is written during every deploy
* Cron files are located in config; there's one per server
  * Since devhosted and QA reside on same server they share the same cron file
* In environments with multiple app servers only one app server is designated as the cron runner

To add a new scheduled job:

1. Add a new method in ScheduledJobs + corresponding specs
2. Add a thin wrapper rake task in scheduled_jobs.rake
3. Add the rake task to the appropriate cron files (under the config directory)

### Health Care Provider (HCP) Taxonomy data

The HCPTaxonomy model translates taxonomy codes into a human-readable description.

To load HCP data in the database, run this: rake admin:import_hcp_taxonomy

### Metadata

Metadata dynamically controls variables and features in the API without needing to deploy or reboot the servers. All values are stored as strings. A list is below:

| Key                         | Possible Values        | Controls                                       |
|:----------------------------|:-----------------------|:-----------------------------------------------|
| *use_invite_flow*           | true/false             | When "true", new members must be invited.                         |
| *remove_robot_response*     | true/false             | When "true", automated response to messages is removed. |
| *enable_pha_phone_queue*    | true/false             | When "true", incoming calls to PHAs are queued up (rather than sent directly to a Google Voice # shared by PHAs) |
| *version*                   | #.#.#                  | Lowest version API supports, used for killswitch |
| *app_store_url*             | URL                    | URL that leads users to download the app |
| *nurse_phone_number*        | ##########             | Phone number client and API uses to dial nurseline (routes through Twilio) |
| *direct_nurse_phone_number* | ##########             | Direct number to nurseline (does not route through Twilio) |
| *pha_phone_number*          | ##########             | Phone number client and API uses to dial PHAs |
| *force_phas_off_call*       | true/false             | When "true", phas are set off call regardless of time. Resets to "false" the following day and continually texts PHA stakeholders while "true" |
| *new_onboarding_flow*       | true/false             | Activates the new onboarding flow which can be viewed here [here](https://www.lucidchart.com/documents/view/368a98b2-8585-41d3-8574-fa4559cfba9b/0) |
| *offboard_free_trial_members* | true/false           | When "true", starts the offboarding flow for free trial members (as of now only "engaged") |
| *offboard_free_trial_start_date*       | MM/DD/YYYY             | Only free trial members that signed up after this date are offboarded. When unset, offboarding is halted. |
| *offboard_expired_members*  | true/false             | When "true", starts the offboarding flow for members who's subscription has expired |
| *ignore_events_from_test_users*  | true/false        | When "true", does not create RemoteEvents for test users (email ending with getbetter.com or example.com) |
| *automated_onboarding* | true/false | When "true", uses automated onboarding communication workflow for new members |
| *automated_offboarding* | true/false | When "true", uses automated offboarding communication workflow for expiring members |
| *new_signup_second_message_delay* | integer | Number of seconds to delay the 2nd message after sign up |
| *minutes_to_inactive_conversation* | integer | Number of minutes that must elapse without a response from PHA or member to mark a consult as inactive |

## Development

Developing for the API? Read on.

### Setup

Getting your environment up and running is detailed on the wiki page  [Development Environment](https://github.com/RemoteHealthServices/RHSMocker/wiki/Development-Environment).
