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

### Metadata

Metadata dynamically controls variables and features in the API without needing to deploy or reboot the servers. All values are stored as strings. A list is below:

| Key                       | Possible Values        | Controls                                       |
|:--------------------------|:-----------------------|:-----------------------------------------------|
| *use_invite_flow*         | true/false             | When "true", new members must be invited.                         |
| *remove_robot_response*   | true/false             | When "true", automated response to messages is removed. |
| *enable_phone_queue*      | true/false             | When "true", incoming calls to PHAs are queued up (rather than sent directly to a Google Voice # shared by PHAs) |
| *version*                 | #.#.#                  | Lowest version API supports, used for killswitch |
| *app_store_url*           | URL                    | URL that leads users to download the app |
| *nurse_phone_number*      | ##########             | Phone number client and API uses to dial nurseline |
| *pha_phone_number*        | ##########             | Phone number client and API uses to dial PHAs |
| *use_pub_sub*             | true/false             | When "true", turns on publishing messages to rhs_pub_sub server |


## Development

Developing for the API? Read on.

### Setup

Getting your environment up and running is detailed [here](https://sites.google.com/a/getbetter.com/engineering/development-environment/rails).


