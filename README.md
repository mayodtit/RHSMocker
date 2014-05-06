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

We run scheduled jobs in all of our environments.  Here's how it's set up:

* Scheduled jobs are executed via the system cron
* The crontab is written during every deploy
* Cron files are located in config; there's one per server
  * Since devhosted and QA reside on same server they share the same cron file
* In environments with multiple app servers only one app server is designated as the cron runner

To add a new scheduled job:

1. Add a new method in ScheduledJobs + corresponding specs
2. Add a thin wrapper rake task in scheduled_jobs.rake
3. Add the rake task to the appropriate cron files

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
| *use_pub_sub*               | true/false             | When "true", turns on publishing messages to rhs_pub_sub server |
| *force_phas_off_call*       | true/false             | When "true", phas are set off call regardless of time. Only works in non-production environments |

## Development

Developing for the API? Read on.

### Setup

Getting your environment up and running is detailed [here](https://sites.google.com/a/getbetter.com/engineering/development-environment/rails).
