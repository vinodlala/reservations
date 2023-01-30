# README

This is for https://github.com/joinjustworksptu/TaxTechChallenge/blob/main/Backend.md

# To run this locally

You need `ruby 3.1.3p185` and `Rails 7.0.4.2`.  Clone this repo to your local machine.  Then run:

```
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
rails s
```

# To hit the `GET /reservations` endpoint

Do something like:

```
curl --location --request GET 'localhost:3000/reservations' \
--form 'contact_email="1@usa.net"' \
--form 'contact_phone="2125551212"' \
--form 'party_name="name"' \
--form 'party_size="2"' \
--form 'starts_at="2023-02-01T22:00:00.000Z"' \
--form 'ends_at="2023-02-01T23:00:00.000Z"'
```

Which will return something like:

```
{
    "reservations": [
        {
            "id": 2,
            "contact_email": "1@usa.net",
            "contact_phone": "2125551212",
            "party_name": "name",
            "party_size": 2,
            "starts_at": "2023-02-01T21:30:00.000Z",
            "ends_at": "2023-02-01T22:30:00.000Z"
        },
        {
            "id": 3,
            "contact_email": "1@usa.net",
            "contact_phone": "2125551212",
            "party_name": "name",
            "party_size": 2,
            "starts_at": "2023-02-01T22:00:00.000Z",
            "ends_at": "2023-02-01T23:00:00.000Z"
        },
        {
            "id": 4,
            "contact_email": "1@usa.net",
            "contact_phone": "2125551212",
            "party_name": "name",
            "party_size": 2,
            "starts_at": "2023-02-01T22:30:00.000Z",
            "ends_at": "2023-02-01T23:30:00.000Z"
        }
    ]
}
```
# To hit the `POST /reservations` endpoint

Do something like:

```
curl --location --request POST 'localhost:3000/reservations' \
--form 'contact_email="1@usa.net"' \
--form 'contact_phone="2125551212"' \
--form 'party_name="name"' \
--form 'party_size="2"' \
--form 'starts_at="2023-02-01T23:00:00.000Z"' \
--form 'ends_at="2023-02-01T24:00:00.000Z"'
```

Which will return something like:

```
{
    "reservation": {
        "id": 7,
        "contact_email": "1@usa.net",
        "contact_phone": "2125551212",
        "party_name": "name",
        "party_size": 2,
        "starts_at": "2023-02-01T23:00:00.000Z",
        "ends_at": "2023-02-02T00:00:00.000Z"
    }
}
```

# Thought process

The two endpoints were relatively straightforward except when it came to reservation slots.

When creating reservations, I made it so that the caller could specify the `starts_at` and `ends_at` of a reservation
since the time needed for a reservation can vary.  For example, a party of two averages about 75 minutes at a table
and a party of 12 could be there for 3 hours.

Creating a reservation is blocked if there is not enough capacity available even if the time slots do not match up.
For example:
- if the restaurant has 10 seats
- and there is a reservation for 10 from 1 pm to 2 pm
- and there is a reservation for 10 from 2 pm to 3 pm
- then reservations cannot be made for 1 pm to 2 pm, 2 pm to 3pm, 1 pm to 3pm, 1:30 pm to 2:30 pm, etc.

When listing reservations, specifying a reservation date (without a time) did not really make sense because of time
zones.  The data is stored as UTC following best practices, and the UTC time range for a specific UTC date will not
match the UTC time range for a time zone like Eastern Time.

However, by specifying the `starts_at` and `ends_at`, we can list all reservations that are within that time range,
e.g., a 24 hour period or a 30 minute period.  Any reservation that is fully or even just partially within a
specified time range will appear in the list.

# Other stuff I would do

- Add more validations on the models, such as making sure the phone number was numeric only and email was correctly
formatted
- Add more tests for the `ReservationAvailabilityChecker` service object and for the requests
- Refactor the controllers
- Add authentication, including a users table
- Switch from `sqlite3` to PostgreSQL or MySQL
- Add pagination for the list of reservations
- When creating a reservation, if `ends_at` is not passed, add a default `ends_at` based on `party_size`
- Handle errors like missing information
