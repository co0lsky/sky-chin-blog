==title==
Mocking is not making fun of the class or object

==author==
Sky Chin

==description==

==featureimage==
1_pmIbzE_TE6w5_0wsZQI76Q.jpeg

==tags==

==body==
Back to development.

![](/assets/images/52491528_1751003725000852_8532183389404562976_n.jpg)

Lately, I was busy with management tasks. This week, I have the chance to contribute to our latest API project.

This is a very productive week. I managed to setup monorepo, practised TDD by writing unit testing and end-to-end testing, and learned to use mocking strategy in the testing.

Monorepo and Manyrepos are a very interesting topic. I figured them out while diving deep into how Taylor Otwell structured the Laravel's code.

I'm writing about it, but I need some time because it is a big topic. Source code repository strategy is a very important decision to an engineering team. I'll spend some time to explain it better.

Therefore, I want to share with you another thing I've learned in this week. Mocking in the unit test is a very useful strategy.

# Mocking

Mocking is simulating the behaviour of a class or an object. You can define the expected value from a class.

If you have a `Post` model, which has a `getContent` method that returns the post content. The post content is a string containing HTML script like `<p>`, `<div>`, etc.

In the unit testing, you can mock a `Post` model and returns different post content to simulate different use cases. For example, you can mock the model to returns malicious script from `getContent` method and see how it breaks the application.

## Simple example

~~~ php
$mock = \Mockery::mock(Post::class);
$mock->shouldReceive('getContent')->andReturn('<img src="http://url.to.file.which/not.exist" onerror=alert(document.cookie);>');
$mock->getContent(); // returns '<img src="http://url.to.file.which/not.exist" onerror=alert(document.cookie);>'
~~~

I know this can be done by inserting a row in the database.

Remember these two points. 

- First, unit testings should be isolated and not involving the database. If you want to test with the database, you can write integration testing. 
- Second, for a complex case like a series of actions/operations are needed to reproduce the steps, you can mock the object to behave as expected without going through all the steps.

In my case, I was creating a new API endpoint for Subscription services. This endpoint is returning a list of available subscription plans for a shop.

To list down the available subscription plans, there were few considerations.
 
1. Is the current shop has an active subscription?
2. Is the current shop eligible for upgrading to higher value plans?
3. Is the current shop eligible to extend the subscribed plan?

To test all the above, I need multiple shops with different subscription plans.
 
Let's say I have three types of subscription plan, they are Trial, Limited, and Beginner.

## Installation

The mock library I am using is [Mockery](http://docs.mockery.io/en/latest/index.html).

~~~ php
composer require mockery/mockery --dev
~~~

## Mock a class or object

In this example, I mock a `Shop` model and `getActivePlans` method is defined to return an empty `Collection`.

~~~ php
// This method mocks a Shop model which can be reused to simulate
// different subscriptions.
private function mockShop()
{
    $mock = \Mockery::mock(Shop::class);
    return $mock;
}

// This method mocks a Shop that subscribed to Limited plan. 
// No active plan means it is Limited.
private function mockShopWithLimitedPlan($countryCode = 'MY')
{
    $shop = $this->mockShop();
    $shop->shouldReceive('getActivePlans')
        ->andReturn(collect([]));
    return $shop;
}
~~~

## Mock a collection

In this example, I mock a `Shop` model and `getActivePlans` method is defined to return a `Collection` that contains an active `SubscriptionPlan`.
  
~~~ php
// This method mocks a Shop that subscribed to Beginner plan
private function mockShopWithBeginnerPlan($countryCode = 'MY')
{
    $shop = $this->mockShop();

    // Mock a SubscriptionPlan which has a property named plan_code
    $beginnerPlan = \Mockery::mock(SubscriptionPlan::class);
    $beginnerPlan->shouldReceive('getAttribute')
        ->with('plan_code')
        ->andReturn('beginner_plan');
    
    // Create a collection
    $collection = new Collection();
    $collection->push($beginnerPlan);

    $shop->shouldReceive('getActivePlans')
        ->andReturn($collection);

    return $shop;
}
~~~

Otherwise, you can use the shorthand.

~~~ php
$shop->shouldReceive('getActivePlans')
        ->andReturn(collect([$beginnerPlan]));
~~~

Have fun mocking!

