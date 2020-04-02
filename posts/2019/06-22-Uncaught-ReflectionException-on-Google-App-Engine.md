==title==
Uncaught ReflectionException on Google App Engine

==author==
Sky Chin

==description==

==featureimage==
1_SvKL-V77qebM3S7jU1ivkQ.jpeg

==tags==

==body==
If you are running PHP or Laravel application with Composer packages on GAE (Google App Engine), by any chance, you’re following my [previous tutorial](/posts/2018-10-27/laravel-5.7-lands-on-google-app-engine-standard-environment/), but still hitting the same Uncaught ReflectionException again. I have a temporary solution for you.

Seeing these familiar errors?

~~~ powershell
PHP message: PHP Fatal error: Uncaught ReflectionException: Class translator does not exist

// or

PHP message: PHP Fatal error: Uncaught ReflectionException: Class view does not exist
~~~

Everything is working fine on the local machine but the error just appears after deploying to the GAE.

I figured out it was the cache issue. GAE is using cache to speed up deployment. Somehow, the cache is breaking the application.

Therefore, the temporary solution is deploying without cache. Fortunately, you can deploy without cache with the Cloud SDK Beta version.

Try this command and it shall work. _Let me know if it doesn’t._

 ~~~ powershell
gcloud beta app deploy —no-cache
~~~

Hope this helps.
