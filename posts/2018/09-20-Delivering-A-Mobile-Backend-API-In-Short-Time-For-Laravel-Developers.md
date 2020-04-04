==title==
Delivering A Mobile Backend API In Short Time For Laravel Developers

==author==
Sky Chin

==description==

==featureimage==
1_A4yjt_j5kJBKEIys0JSMuw.jpeg

==tags==

==body==
Recently I was working on a mobile app project with my friend, Steven where the user can receive location updates from friends and family. Each user will have a tracking code and a list of users with their most recent location.

The biggest challenge of this project was the timeline. We needed to deliver it within two weeks while working a day job.

However, we managed to deliver it in one weekend.

I was assigned to build the backend API for the mobile app. In this article, I’d like to share with you the key practices that I used to deliver the backend API in such a short time.

Key practices:
1. Design your API before writing code
2. Write API with Lumen, not Laravel
3. Simplify your code by using Single Action Controllers

# Design your API before writing code

When starting development, most of the inexperienced developers jump into writing code immediately. 

That is a common mistake.

Without designing your API before writing code,
1. You could be frustrated by the unexpected workload in the later stage
2. You could miss the deadline 

## Draft API endpoints

Draft your API endpoints in document collaboration tools like [Google Docs](https://docs.google.com/document/) or [Dropbox](https://www.dropbox.com/).

Here is the example API I drafted.

![Google Docs](/images/1_b1X2BMB64G2l6uNrBqUe-g.png)

After you have the first version of the draft ready. You can start the discussion with mobile app developer or client.

## Discuss with mobile app developer or client

With [Google Docs](https://docs.google.com/document/) or [Dropbox](https://www.dropbox.com/), you can share your API draft with mobile app developer or client easily. Get their feedback as early as possible to prevent miscommunication.

After the discussion, you have clear requirements and documentation (API draft). Then, you can start to prototype your APIs.

## Prototype your API endpoints without writing code

One of my favourite API development tools is [Apiary](https://apiary.io/).

Before spending hours on development, you can prototype your API endpoints on [Apiary](https://apiary.io/). [Apiary](https://apiary.io/) provides a mock server for your API which means your API is instantly ready to be called and response as documented.

Mobile app development can start immediately without having to wait for the actual backend API to be ready.

The mobile app should send the request to the API as documented, and backend API should return the response as designed.

# Write API with Lumen, not Laravel

Lumen is the lighter version of Laravel which is specifically designed for API development.

## Easier

The first reason I recommend Lumen is easier to learn. Lumen is specifically designed for stateless API, so you don’t need to learn Session, Views and some other 3rd party components.

![](/images/1__JuBhpbwgAzjYbqXJrSslw.png)

## Faster

The second reason is the speed.

Check out this performance comparison done by Laurence (Creator of [Eyewitness.io](http://eyewitness.io/) — A Laravel monitoring application)

![](/images/1_JHY6LbWwKqoEuyAnjOimWQ.png)
Source: https://medium.com/@laurencei/lumen-vs-laravel-performance-in-2018-1a9346428c01

Without touching the database, Lumen is 22.82% faster than Laravel (web) and 13.89% faster than Laravel (api).

By selecting data from the database, Lumen is 16.67% faster than Laravel (web) and 6.13% faster than Laravel (api).

By inserting and deleting from the database, Lumen is 33.08% faster than Laravel (web) and 16.02% faster than Laravel (api).

Generally, Lumen is 24.19% faster than Laravel (web) and 12.01% faster than Laravel (api).

## Compatible with Laravel

The third reason is you can shift to Laravel easily as application codes are compatible with both frameworks.

![](/images/1_ieeaMYoUYil7uyPTwg1b4w.png)
Source: https://jason.pureconcepts.net/2017/02/lumen-is-dead-long-live-lumen/#comment-3412664960

When the application grows, you can shift to Laravel anytime to serve the application’s needs.

# Simplify your code by using Single Action Controllers

To keep your code simple and easy to maintain, implement [Single Action Controller](https://laravel.com/docs/5.7/controllers#single-action-controllers) from Laravel.

Single Action Controller is one controller performs one action only. For example, add a tracking code or get a tracking list.

Here are my single action controllers look like in one of my projects.

![](/images/1_RAkrtO68iqG32ZG1BSiF7Q.png)

And the other single action controllers in the project.

![](/images/1_Hw8z_gtFlnhEUCg88AVdBQ.png)

And, the routes.

![](/images/1_GAo4-3emglNC7FOiMUKP8w.png)

What about the shared code? If you have a function which is needed by more than one controllers, you can write a [Trait](http://php.net/manual/en/language.oop5.traits.php).

# Tech Stack

Tech stack I was using in this project.

[Google Docs](https://docs.google.com/document/) - Collaborate and discuss API
[Apiary](https://apiary.io/) - Prototype API before actual writing code
[Lumen](https://lumen.laravel.com/) - Micro-framework specifically for API development

# What’s next

Have you try Apiary, have you not? This is the [tutorial](https://help.apiary.io/api_101/api_blueprint_tutorial/) that can help you get started. If you did, what’s your experience using Apiary?

Have you ever use Lumen in real life project before? Email me about your experience at [sky4just@gmail.com](mailto:sky4just@gmail.com)
