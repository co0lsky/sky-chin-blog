==title==
Write an API wrapper in PHP

==author==
Sky Chin

==description==

==featureimage==
1_m4c4EAIS-VItrUFNLW6c1Q.jpeg

==tags==

==body==
It is common that your application is calling to one or more third-party APIs.

_In this post, I'm using [Guzzle](http://docs.guzzlephp.org/en/stable/) as the examples._

A simple API calling script would look like this.

~~~ php
$client = new Client();
$client->get('/endpoint');
~~~

If you are writing an eCommerce site. You would integrate with the third party courier service provider. 

Let's say the third party service provider provides two endpoints, `/consignmentnote` and `/pickup`.

~~~ php
// ControllerA

class ControllerA
{
    public function __construct() 
    {
        $this->client = new Client(/* necessary parameters */)
    }

    public function consignmentNote($request) 
    {
        $this->client->post('/consignmentnote');
    }

    public function pickup($request) 
    {
        $this->client->post('/pickup');
    }
}
~~~

Calling the APIs in `Controller` class is not encouraging reusable code. Usually, you couldn't call the method from another `Controller` class.

Instead, you write a simple wrapper class which contains the logic and presents as an object, `CourierA`.

~~~ php
// CourierA

class CourierA
{
    public function __construct()
    {
        $this->client = new Client(/* necessary parameters */)
    }

    public function generateConsignmentNote()
    {
        $this->client->post('/consignmentnote', []);
    }

    public function callPickup()
    {
        $this->client->post('/pickup', []);
    }
}

// ControllerA

class ControllerA
{
    public function __construct() 
    {
        $this->courier = new CourierA()
    }

    public function consignmentNote($request) 
    {
        $this->courier->generateConsignmentNote();
    }

    public function pickup($request) 
    {
        $this->courier->callPickup();
    }
}
~~~

Now, another `Controller` class can use the `CourierA` without any problem.

This approach is good enough. However, you can do it better.

Robert C. Martin expresses the [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single_responsibility_principle) as, "A class should have only one reason to change."

When the service provider adding more services, you would need to modify `CourierA` class which is against the principle. Otherwise, `CourierA` class will soon become a monster class.

To prevent that happen, you can utilise the magic method `__call` to improve the scalability and stick with the principle.

~~~ php
// Courier A

class CourierA
{
    public function __construct()
    {
        $this->client = new Client(/* necessary parameters */)
    }

    public function __call($name, $arguments)
    {
        // Transform method name generateConsignmentNote to class name GenerateConsignmentNote
        $serviceClass = 'Service\\' . ucfirst($name);

        // Check whether Service class exists
        if (class_exists($serviceClass)) {

            // Create a new instance with arguments
            $request = new $serviceClass(...$arguments);

            try {
                // Call to API
                return $this->client->send($request);
            } catch (GuzzleException $e) {
                // Throw exception
                throw new \Exception('Service ' . $name . ' failed because ' . $e->getMessage());
            }
        }

        // Throw exception if the Service class does not exist
        throw new \Exception('Service ' . $name . ' does not defined.');
    }
}

// Service\GenerateConsignmentNote

use GuzzleHttp\Psr7\Request;

class GenerateConsignmentNote extends Request
{
    public function __construct()
    {
        parent::__construct('POST', 'consignmentnote');
    }
}

// Service\CallPickup

use GuzzleHttp\Psr7\Request;

class CallPickup extends Request
{
    public function __construct()
    {
        parent::__construct('POST', 'pickup');
    }
}
~~~

When calling to any method of `CourierA`, the `__call` method magically map it with the classes under `Service`. `ControllerA` remains the same.

~~~ php
// ControllerA

class ControllerA
{
    public function __construct() 
    {
        $this->courier = new CourierA()
    }

    public function consignmentNote($request) 
    {
        $this->courier->generateConsignmentNote();
    }

    public function pickup($request) 
    {
        $this->courier->callPickup();
    }
}
~~~

By adding a new class like `Service\CheckStatus`, you can call the method `$courierA->checkStatus()` without modifying `CourierA` class.

Besides, you can add @[method](http://docs.phpdoc.org/references/phpdoc/tags/method.html) to let the caller know which methods are supported.

 ~~~ php
// CourierA

/**
 *
 * @method mixed generateConsignmentNote()
 * @method mixed callPickup()
 */

class CourierA
{
    ...
}
~~~

![](/assets/images/1_MbjpimY8uyFysnLCkuGEaQ.png)

Have fun coding!
