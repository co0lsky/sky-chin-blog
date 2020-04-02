==title==
Four Things You Need To Know Before You Getting Started With Laravel Passport

==author==
Sky Chin

==description==

==featureimage==
1_T-2VtbzFpVZ7l6Jm-J4xLQ.jpeg

==tags==

==body==
[Laravel Passport](https://laravel.com/docs/5.7/passport) adds the capabilities as an OAuth2 server to your Laravel application, which manages how third party accessing to your application data.

There are four things you need to know before you getting started with Laravel Passport.

1. **Protect your API routes with middleware**
2. **Set Bearer token in Postman**
3. **Protect other user information with middleware**
4. **Laravel Passport has pre-built frontend UI**

# Protect your API routes with middleware

Although Laravel Passport provides a simple and easy implementation, you still need to define the [how Passport protects your routes]( https://laravel.com/docs/5.7/passport#protecting-routes). In order to protect your API routes, you apply the `auth:api` middleware to any route that requires a valid access token.

For example, you want to protect the route `/api/user`.

~~~ php
// routes/api.php

Route::middleware(['auth:api'])->group('/user', function () {
    //
});
~~~

# Set Bearer token in Postman

If you’re using [Postman](https://www.getpostman.com/) as your testing tool, remember to set the token in the headers or Authorization tab.

This is the response with valid access token you receive after requesting from `/oauth/token`.

~~~ powershell
// Response from /oauth/token

{
    "token_type": "Bearer",
    "expires_in": 31536000,
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImY5YmIyOWM1MjllOWZhYWNmOWE0NDNhMjk1N2EyNzU1Zjk4YjdlZDE4NDBlMDBlOTFlMTRlNGQzZmJlNTBiNjc4NzI3ZjlkMDdlOWE1YzVkIn0.eyJhdWQiOiI0IiwianRpIjoiZjliYjI5YzUyOWU5ZmFhY2Y5YTQ0M2EyOTU3YTI3NTVmOThiN2VkMTg0MGUwMGU5MWUxNGU0ZDNmYmU1MGI2Nzg3MjdmOWQwN2U5YTVjNWQiLCJpYXQiOjE1NDMzNTYwNzgsIm5iZiI6MTU0MzM1NjA3OCwiZXhwIjoxNTc0ODkyMDc4LCJzdWIiOiIyMCIsInNjb3BlcyI6W119.EQVpphH8YpEbOJ3H97r0zRvE57TSfKXpihOcPIDKEn5BAP0RHZxYzOBzeDLJnu6G4ZyTN1-bkZlriCzFwChipyJOytZAxpe4b5AoTIFu2XQNexZNxwgkOZDRUjZ4IsdZjvGyyDYOyj8hHuu5Ve3MeamBDT80oxJfxE3Cb0CvsHmyILr7WmNdCsgt4rJ73kZ8bfuyqAzMaBc7NvuAKqaGfYjtbBkf7s9UtLZPNum_cU3hk1Of7fzxd0BRDolUctvFLmR7NyEUq_Gvdw2c1aTE_an2R15u7p1mT5Ki0lUSTNH1dfz9bE8Cd1qfT9TPUfhKhjmrDYL6QrKa-zCRLlUjjGohj0HelCcOor9EOPFvNgu1lLRyUSzf2CHsONZXRuAETUrKSTvUfht5QYQeklRfCQ0I68BbKhytfycdynhyCUSN5UnNCRsWa0QN-MwV5Fm827T2SzCOhVAMJCEZdkW-IHTS-kjPoNLuaBYGuTp-G51soqt9Q97DIj8YNSHMLXndoI8I7nxARWIMQ9hzVUBn95zFTKBbA2sglXcTp05HYBO0tjwkFrEE5E2rFzCksYttDHhwqkotstgbIKEurjETIbDFrHNgIbzq1_pvp1juWlkM6pOE0LyHlPh4nKLHAw4NyNGSuXllX6vwM4gOHCbKj-EawGA-N1Asu8u8_NamwY8",
    "refresh_token": "def5020017bbf26e6559fe132e6bd44d20a0f246877d45aca9bb79a69bf95136e77f9f8f20b74a79095f8abda4bcdf478af3595dd58eef23cf506d8dbb682b1e9f023fe3fc6b29c9dd0bfa6d21a8ea14e58aa7e829b1cf00b4ed7077ae028e484019996133e56758270a5ed0ab44d0cb79d2cc9e59f9d6c2d7c175e1b7fe356ca460f955fe42dc3b78fa0c534ca28df0f1bbeb2caf98a1de77df2d55bbbc82184236a1f93e60f71f99506eb41e81ea995d2e968733a3027ed2751828736a40c22ff8b407e3b0d566b0b11a1a65fe134e957b9069f7060bf3dc65f453a93171ded27314e82e83ef2752c6bccf17c6f9d61969df3ff8247dcdda772af7a024bb116ff26806f52d8ab2194fa3be815df44befd20cdb05ebf0c6febbf8d4b0dc9570d0199bb1d8086d00098f3315c6faccd45def76f8cff0c7840fe244848a21409c1f19a77f07b4fa9d5655e1c57aaef0e48db2074a3bc5a4879d3d82504cac83f9f686"
}
~~~

You can set the Bearer token in Postman

1. From the Authorization tab

![](/assets/images/1_X5AvTqLb52LCKtyIFvRpEA.png)

2. Set it manually from Headers tab

![](/assets/images/1_96KEGJMCFwDvH9_iSItCjw.png)

# Protect other user information with middleware

Although your application data is protected by the authorization rules. But you still need to implement the business rule to prevent the authorized user from accessing to other user data.

For example, User A whose `user_id` is 21 and he can retrieve his information from `/users/21`. With the valid access token, User A can retrieve User B information from `/users/22`. User A shouldn’t be able to access User B information.

You can add a middleware to restrict the access. At code below, you response `Unauthorized Access` when the user is trying to access to other `user_id`.

~~~ php
// app/Http/Middleware/AuthUser.php

namespace App\Http\Middleware;

use Illuminate\Support\Facades\Auth;

class AuthUser
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        if ($request->route(‘userId’) != Auth::id()) {
        return response()->json([
            'status' => 'fail',
            'message' => 'Unauthorized Access.'
        ], 401);
        }

        return $next($request);
    }
}
~~~

# Laravel Passport has pre-built frontend UI

Laravel Passport provides JSON API to allow your user to create clients and personal access tokens. In order to save time on building a frontend to interact with the JSON API, Passport has [pre-built Vue components](https://laravel.com/docs/5.7/passport#frontend-quickstart) for you to getting started.

First, you publish the Passport Vue components by using the `vendor:publish` Artisan command.

~~~ powershell
// Terminal

$ php artisan vendor:publish --tag=passport-components
~~~

Register Vue components in `app.js`.

~~~ js
// resources/js/app.js

Vue.component(
    'passport-clients',
    require('./components/passport/Clients.vue')
);

Vue.component(
    'passport-authorized-clients',
    require('./components/passport/AuthorizedClients.vue')
);

Vue.component(
    'passport-personal-access-tokens',
    require('./components/passport/PersonalAccessTokens.vue')
);
~~~

Then, recompile your assets.

~~~ powershell
// Terminal

$ npm run dev
~~~

And, build a simple layout that contains the [Vue](https://vuejs.org/) components.

~~~ html
// resources/views/clients.blade.php

<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <title>Laravel</title>

        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    </head>
    <body>

    <div id="app">
        <passport-clients></passport-clients>
        <passport-authorized-clients></passport-authorized-clients>
        <passport-personal-access-tokens></passport-personal-access-tokens>
    </div>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    <script src="/js/app.js"></script>
    </body>
</html>
~~~

Register a route with the layout.

~~~ php
// routes/web.php

Route::get('/', function () {
    return view('clients');
});
~~~

Once your application is up, you should see the page as below.

![](/assets/images/1_TN4jVdG3Lkp4khrNG-ofaQ.png)

The JSON API is required a logged in user. If you just want to test, this is a quick hack by logging in a user manually.

~~~ php
// app/Providers/AppServiceProvider.php

public function boot()
{
    Auth::loginUsingId(1);
}
~~~

# What’s next

Do you have any tips and tricks which can help other developers to save tons of time on googling? Do share them at the comment area below.
