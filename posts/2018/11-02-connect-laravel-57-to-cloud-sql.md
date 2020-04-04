==title==
Connect Laravel 5.7 To Cloud SQL

==author==
 Sky Chin

==description==

==featureimage==
1_sQKAMLOCAJJQ63dK6nOwSA.png

==tags==

==body==
In the [previous post](/posts/2018-10-27/laravel-5.7-lands-on-google-app-engine-standard-environment/), our Laravel 5.7 application lands on the GAE (Google App Engine) Standard Environment.

In this post, we are going to connect Laravel 5.7 application to the Cloud SQL.

# Cloud SQL

Cloud SQL is a fully-managed database system that supports PostgreSQL and MySQL databases in the GCP (Google Cloud Platform).

With Cloud SQL, I don’t need to install MySQL manually or maintain the database. It matches my goal of running Laravel application on GCP with no-ops.

# Prerequisites

Before you getting started, you need to prepare

1. Create a project in the [Google Cloud Platform Console](https://console.cloud.google.com/project).
2. Enable billing for your project.
3. Enable the [Cloud SQL API](https://console.cloud.google.com/flows/enableapi?apiid=sqladmin&redirect=https://console.cloud.google.com).
4. Install the [Google Cloud SDK](https://cloud.google.com/sdk/).

# Create a new instance

First of all, create a new instance of CSQL (Cloud SQL).

1. Login to your [GCP console](http://console.cloud.google.com).
2. Search `sql` from the search bar.

![](/images/1_y9ciPlJUYy71FyN7OSUo-w.png)

3. Click on the CREATE INSTANCE button.

![](/images/1_o95RbajfUsY8v9Zv0Vjazg.png)

4. Select MySQL.

![](/images/1_bW8r74Iq5Aah_TYOIxXMwQ.png)

5. Choose the second generation.

![](/images/1_NxxQt0Y6PIMx9mv6NrR3fg.png)

6. Fill up all the field then click the Create button.

![](/images/1_h2irJLhLftpjH52VkrGuFA.png)

There you go! You have created a new instance of CSQL.

![](/images/1_iXR_4bqsmX3LyAdU3_umQw.png)

# Create a new database

The beauty of a cloud server is you can connect anywhere.

To connect to the database, you connect the CSQL by using the [Cloud SQL Proxy](https://cloud.google.com/sql/docs/mysql/sql-proxy).

## Connect from the local machine

1. Follow the [guide here](https://cloud.google.com/sql/docs/mysql/connect-external-app#install) to Install the proxy client on your local machine.
2. Connect to the CSQL instance via the proxy client.

~~~ powershell
// Terminal

$ ./cloud_sql_proxy -instances=running-laravel-on-gcp:asia-southeast1:running-laravel-on-gcp=tcp:3306
~~~

If you have a local database which is running on the port number 3306, you can connect with another port number. In my case, I connect with port number 33060.

~~~ powershell
// Terminal

$ ./cloud_sql_proxy -instances=running-laravel-on-gcp:asia-southeast1:running-laravel-on-gcp=tcp:33060
~~~

## Create a database

The CSQL is empty right now, let’s create a new database.

~~~ powershell
// Terminal

$ mysql -h 127.0.0.1 -u root -p -e "CREATE DATABASE running-laravel-on-gcp;”
~~~

In my case, I need to specify the port number 33060.

~~~ powershell
// Terminal

$ mysql -h 127.0.0.1 -P 33060 -u root -p -e "CREATE DATABASE running-laravel-on-gcp;”
~~~

Next step is run the database migration to create all the tables.

# Run the database migration for Laravel

By setting database connection in `.env`, your local Laravel application connects to the CSQL instance directly.

~~~ powershell
// .env

DB_DATABASE: running-laravel-on-gcp
DB_USERNAME: root
DB_PASSWORD: secret
DB_SOCKET: "/cloudsql/running-laravel-on-gcp:asia-southeast1:running-laravel-on-gcp”
~~~

If you don’t want to mess up with your local environment settings, you can run the database migration by passing the database connection as environment variables.

~~~ powershell
// Terminal

$ export DB_DATABASE=laravel DB_USERNAME=root DB_PASSWORD=secret DB_SOCKET: "/cloudsql/running-laravel-on-gcp:asia-southeast1:running-laravel-on-gcp”
~~~

Okay! Run the migration now.

~~~ powershell
// Terminal

$ php artisan migrate
~~~

Then, deploy the application.

# Deployment

Like the setting in `.env`, you set the database connection parameters as environment variables in `app.yaml`.

~~~ powershell
// app.yaml

runtime: php72

# Put production environment variables here.
env_variables:
  # Applicaton key
  APP_KEY: base64:neD3pkZQV26sd9OxZ8cp3jyERMnrt0X5guevJzw65N4=
  # Storage path
  APP_STORAGE: /tmp
  ## Set these environment variables according to your CloudSQL configuration.
  DB_DATABASE: running-laravel-on-gcp
  DB_USERNAME: root
  DB_PASSWORD: secret
  DB_SOCKET: "/cloudsql/running-laravel-on-gcp:asia-southeast1:running-laravel-on-gcp”
~~~

After the setting, run the deployment.

~~~ powershell
// Terminal

$ gcloud app deploy
~~~

Tada!

![](/images/1_vPBWUimSQE21aSiGPfnuPQ.png)

Using root user in the production environment is not recommended, don’t mention about the simple password I set previously. Let’s change the root user's password and create a new user for your Laravel application.

# Manage MySQL user accounts

You can manage your MySQL user accounts from GCP console.

1. From the console, select your instance then switch to USERS tab.

![](/images/1_PIQ5FLRL9tesAFMcnwc4pw.png)

2. Create a new user named laravel and set a complex password.

![](/images/1_Hqgw-jf0Di7KC_-AidZXcg.png)

3. After creating the user, you change the password of the root user account.

![](/images/1_aRWeW6jivKVp6NNGT2Qmqw.png)

4. Then, update the `app.yaml` with the new credentials.

~~~ powershell
// app.yaml

  DB_USERNAME: laravel
  DB_PASSWORD: C0mpl3xP4ssw0rd
~~~

5. And, deploy it.

~~~ powershell
// Terminal

$ gcloud app deploy
~~~

Your Laravel application on GAE should work the same as previous.

![](/images/1_vPBWUimSQE21aSiGPfnuPQ.png)

Now, your Laravel 5.7 application is connected to the GSQL.

# Stay tune

Laravel has an awesome filesystem which is powered by the [Flysystem](https://github.com/thephpleague/flysystem) PHP package by Frank de Jonge.

Next post, I’m going to write about how to manage your filesystem on the cloud.
