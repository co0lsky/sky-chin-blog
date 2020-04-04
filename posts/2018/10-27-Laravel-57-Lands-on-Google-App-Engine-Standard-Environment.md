==title==
Laravel 5.7 Lands on Google App Engine Standard Environment

==author==
Sky Chin

==description==

==featureimage==
1_lKtGkuxZo8_M03q0b7H6lQ.jpeg

==tags==

==body==
> Update on 22 June 2019, check out my [new post](/posts/2019-06-22/uncaught-reflectionexception-on-google-app-engine/) if you hit any deployment error.

On 2nd October, I attended Google Cloud Summit 2018 in Kuala Lumpur.

I realised how impactful cloud platform to the fast-growing application. By utilising cloud technology, most of the application needs least workload on ops, ultimately, no-ops at all.

Imagine I can run an application without having to install software or configure project root path by myself. I can fully focus on the application code.

My goal here is run Laravel application on GCP (Google Cloud Platform) with no ops.

# Google Compute Engine and Google App Engine

In GCP, there are two services that can run Laravel application, which is GCE (Google Compute Engine) and GAE (Google App Engine).

GCE is a high-performance and scalable VMs and GAE is a fully managed serverless application platform.

It is easy to understand to run an application on VM based like GCE. You have a server that you can install the dependencies that suit the application need.

However, that’s not my goal. I aim for no-ops. Therefore, I go for GAE.

# GAE (Google App Engine)

The cloud platform is complex. Just now I mentioned two services that run the application.

In GAE, you can run your applications using the flexible environment or standard environment. ([Compare between two environments](https://cloud.google.com/appengine/docs/the-appengine-environments#comparing_high-level_features))

From the internet, there are a few tutorials teach you how to setup Laravel in flexible environment. 

* https://cloud.google.com/community/tutorials/run-laravel-on-appengine-flexible
* https://mikateach.com/setting-up-laravel-5-6-on-google-app-engine/
* https://updivision.com/blog/post/how-to-deploy-a-laravel-web-app-on-google-app-engine

I couldn’t find any tutorial teaching on the standard environment. Therefore, I decided to dive into it.

In this post, I will run Laravel 5.7 in GAE standard environment.

# Prerequisites

Before you getting started, you need to prepare

1. Create a project in the [Google Cloud Platform Console](https://console.cloud.google.com/project).
2. Enable billing for your project.
3. Install the [Google Cloud SDK](https://cloud.google.com/sdk/).

# Install Laravel

Install your Laravel project via Composer

~~~ powershell
// Terminal

$ composer create-project --prefer-dist laravel/laravel blog
~~~

Alternatively, you can install via other methods, refer to https://laravel.com/docs/5.7/installation#installing-laravel.

After the installation, run the application.

~~~ powershell
// Terminal

$ php artisan serve
~~~

![](/images/1_drnJqw8hV2vc6RS_s7i9zQ.png)

Alright, this is what you are going to deploy to the GAE.

# Preparing for deployment

There are a couple of actions need to be done before your Laravel application able to run in GAE.

## Defining Runtime Settings

GAE is configured using an `app.yaml` file, that contains the runtime and other general settings including environment variables.

Create `app.yaml` at your project root.

~~~ powershell
// app.yaml

runtime: php72

# Put production environment variables here.
env_variables:
  # Applicaton key
  APP_KEY: base64:neD3pkZQV26sd9OxZ8cp3jyERMnrt0X5guevJzw65N4=
  # Storage path
  APP_STORAGE: /tmp
~~~

## Set storage path

Laravel application compile view files and store in the storage folder. One of restriction in GAE is you don’t have the freedom to write file at anywhere you want.

In second generation runtimes, you only able to read or write file to `/tmp`. (Learn more from [here](https://cloud.google.com/appengine/docs/standard/appengine-generation))

Therefore, you need to set the custom storage path, which is the `/tmp`. Laravel application will write the compiled files to the `/tmp`.

Modify the `bootstrap/app.php` to use `APP_STORAGE` as storage path, and `APP_STORAGE` has been set as environment variable in `app.yaml`.

~~~ php
// bootstrap/app.php

...

/*
|--------------------------------------------------------------------------
| Set Storage Path
|--------------------------------------------------------------------------
|
| This script allows us to override the default storage location used by
| the  application.  You may set the APP_STORAGE environment variable
| in your .env file,  if not set the default location will be used
|
*/

$app->useStoragePath(env('APP_STORAGE', base_path() . '/storage'));

/*
|--------------------------------------------------------------------------
| Return The Application
|--------------------------------------------------------------------------
|
| This script returns the application instance. The instance is given to
| the calling script so we can separate the building of the instances
| from the actual running of the application and sending responses.
|
*/

return $app;
~~~

Set the `storage_path()` as compiled view path.

~~~ php
// config/view.php

'compiled' => storage_path(),
~~~

## Ignore some files

In order to prevent confusion on too many environment files, you set the production environment variables in the `app.yaml`.

`.env` is primarily using for local development. Therefore, you need to prevent `.env` to be deploy to the GAE.

Create a file named `.gcloudignore`.

~~~ powershell
// .gcloudignore

.env
~~~

It’s not done yet.

During the exploration, I kept on hitting an error after the deployment.

![](/images/1_ICJP9I8-SP6wwAF8bpdaOQ.png)

The error was gone after I stopped the `composer.lock` from the deployment. 

~~~ powershell
// .gcloudignore

composer.lock
~~~

I have yet figuring out the root cause yet. I guess my local `composer.lock` is not compatible with the environment runtime.

However, I don’t think this is a good strategy to ignore the `composer.lock`. The application may break if there’s any package has a breaking changes. I’ll continue to explore the better strategy. Perhaps Cloud Build is the better choice.

# Finally, deploy

I am sure you’ve set up Google Cloud SDK. Let’s go to your project root and execute the deploy command.

~~~ powershell
// Terminal

$ cd [project root]

$ gcloud app deploy
~~~

Once the deployment is done. You can browse the application with this command.

~~~ powershell
// Terminal

$ gcloud app browse
~~~

Tada!

![](/images/1_sdsC5FkpNXAlMEY6O18DAg.png)

Besides, you can watch the application log with this command.

~~~ powershell
// Terminal

$ gcloud app logs tail -s default
~~~

Now, you have your Laravel 5.7 application running on GCP.

# Stay tune

After two weeks of trial and error, I clear off many doubts and able to write this tutorial to you. 

I know this is not a complete tutorial. Without writing data to database, the application is incomplete.

Next week, I’m going to write about connecting to the database.
