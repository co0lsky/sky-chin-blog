==title==
Upload Image To Google Cloud Storage From Laravel 5.7

==author==
Sky Chin

==description==

==featureimage==
1_8q2U-kX76M3Qbuxebtn58Q.jpeg

==tags==

==body==
> Update on 22 June 2019, check out my [new post](/posts/2019-06-22/uncaught-reflectionexception-on-google-app-engine/) if you hit any deployment error.

In the [previous post](/posts/2018-11-02/connect-laravel-5.7-to-cloud-sql/), our Laravel 5.7 application connected to Cloud SQL.

In this post, we are going to upload an image to Google Cloud Storage from Laravel 5.7 application.

# Google Cloud Storage

GCS (Google Cloud Storage) is an object storage in the cloud. 

With GCS, I don’t need to care about how much space left in the server and images not available when GAE (Google App Engine) scales up the instances.

# Prerequisites

Before you getting started, you need to prepare

1. Create a project in the [Google Cloud Platform Console](https://console.cloud.google.com/project).
2. Install the [Google Cloud SDK](https://cloud.google.com/sdk/).
3. Install [Postman](https://www.getpostman.com/apps) (this software is used for testing, optional to install)

# Free GCS bucket for GAE

GCS provides a free bucket (allow to store up to 5GB) for each GAE application. You can a bucket created with your application domain name under GCS browser.

![](/images/1_MfNPxjRJOp4i19tddi0thw.png)

# Install GCS in Laravel

Next, install GCS as a custom file system in your Laravel 5.7 application. Superbalist released a [handy package](https://github.com/Superbalist/laravel-google-cloud-storage) as a GCS adapter for [flysystem](https://github.com/thephpleague/flysystem).

The first step, install the package.

~~~ powershell
// Terminal

$ composer require superbalist/laravel-google-cloud-storage
~~~

Register the service provider.

~~~ php
// config/app.php

'providers' => [

        ...

        /*
         * Package Service Providers...
         */
        Superbalist\LaravelGoogleCloudStorage\GoogleCloudStorageServiceProvider::class,

        ...

    ],
~~~

Next step, add a new disk to the filesystem.

~~~ php
// config/filesystems.php

'disks' => [

        ...

        'gcs' => [
            'driver' => 'gcs',
            'project_id' => env('GOOGLE_CLOUD_PROJECT_ID', 'your-project-id'),
            'key_file' => env('GOOGLE_CLOUD_KEY_FILE', null), // optional: /path/to/service-account.json
            'bucket' => env('GOOGLE_CLOUD_STORAGE_BUCKET', 'your-bucket'),
            'path_prefix' => env('GOOGLE_CLOUD_STORAGE_PATH_PREFIX', null), // optional: /default/path/to/apply/in/bucket
            'storage_api_uri' => env('GOOGLE_CLOUD_STORAGE_API_URI', null), // see: Public URLs below
        ],
    ],
~~~

There are 5 environment variables you can set:
1. `GOOGLE_CLOUD_PROJECT_ID` - your GCP project ID
2. `GOOGLE_CLOUD_KEY_FILE` - your service account, you don’t need to set this now because GAE has built-in credential ready. Check out more from [here](https://github.com/Superbalist/laravel-google-cloud-storage#authentication)
3. `GOOGLE_CLOUD_STORAGE_BUCKET` - your bucket name, in my case, it is  running-laravel-on-gcp.appspot.com
4. `GOOGLE_CLOUD_STORAGE_PATH_PREFIX` - your image path/folder in the bucket
5. `GOOGLE_CLOUD_STORAGE_API_URI` - your custom domain, you don’t need to set this now. Check out more from [here](https://github.com/Superbalist/laravel-google-cloud-storage#public-urls)

The last step in the installation, set the variables in `app.yaml`.

~~~ powershell
// app.yaml

# Put production environment variables here.
env_variables:
  ...
  FILESYSTEM_DRIVER: gcs
  GOOGLE_CLOUD_PROJECT_ID: running-laravel-on-gcp
  GOOGLE_CLOUD_STORAGE_BUCKET: running-laravel-on-gcp.appspot.com
~~~

Once the installation is done, you create an endpoint for image uploading.

## Create an endpoint for image upload

Create a new controller named `UserAvatarController`.

~~~ powershell
// Terminal

$ php artisan make:controller UserAvatarController
~~~

In `UserAvatarController`, create a method named `update` which stores the uploaded image file to GCS bucket into the path/folder named `avatars`.

~~~ php
// app/Http/Controllers/UserAvatarController.php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class UserAvatarController extends Controller
{
    /**
     * Update the avatar for the user.
     *
     * @param  Request  $request
     * @return Response
     */
    public function update(Request $request)
    {
        $path = $request->file('avatar')->store('avatars');

        return $path;
    }
}
~~~

Don’t forget to enable the endpoint to the route file.

~~~ php
// routes/web.php

Route::post('/updateAvatar', 'UserAvatarController@update’);
~~~

In this case, you aren’t going to build a form to test the upload. If you are, you can skip this step.

The upload test will be running via Postman which cannot generate the CSRF token automatically. Therefore, you exclude the `/updateAvatar` from the `VerifyCsrfToken` Middleware.

~~~ php
// app/Http/Middleware/VerifyCsrfToken.php

class VerifyCsrfToken extends Middleware
{
    ...

    /**
     * The URIs that should be excluded from CSRF verification.
     *
     * @var array
     */
    protected $except = [
        'updateAvatar'
    ];
}
~~~

# Deploy

Deploy the application to the GAE.

~~~ powershell
// Terminal

$ gcloud app deploy
~~~

# Test

Once the deployment is completed, run the test now.

You can use Postman or another method to test the application. Now, you are going to use Postman.

From the Postman, 
1. Create a new POST request
2. Set the domain and the endpoint
3. Name a field data as `avatar` and set the type as `File`
4. Select an image 
5. Click Send

After clicking the send button, the endpoint should return the file path and the uploaded image file name.

Tada!

![](/images/1_YjNM46kMlwpQ8Q974V0a7Q.png)

You can find the uploaded image file through GCP console.

![](/images/1_mhmGVa4_lV8tNYCFApQaQw.png)
