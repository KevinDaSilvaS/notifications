# Notifications

## About
Notifications is a push notifications microservice that uses broadway to receive notifications and broadcasts then trough phoenix channels and also saves then on couchdb.
Also notifications is a substitution of [`notifier`](https://github.com/KevinDaSilvaS/notifier) that has the same purpose, but the notifications is way more tested, more bug prone and uses broadway to process messages instead of amqp library

## How to run
There's two ways of running the application, the easier and simplest way is by using the docker-compose file, by just running:

  ```
   docker-compose up --build
  ```

Or by cloning and running manually

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000/api/notifications/${topic}`](http://localhost:4000/api/notifications/topic) from your browser.

Or pushing a notification on rabbitmq:

  ```
   {
      "topic": "12345",
      "title": "a notification title",
      "message": "a notification message",
      "redirect": "myapp.com/stuff-on-sale"
   }
  ```
