==title==
3 simple ways to use Collection's map method

==author==
 Sky Chin

==description==

==featureimage==
 1_2kVG4qDSmvBM4lFlJKMChg.jpeg

==tags==

==body==
Laravel’s Collection has many powerful methods that can help you to do the complex tasks.

Map method applies a callback function to each of the items in the collection. In the callback function, you can modify the item before returning it.

Here are three simple ways you can use the map method.

Given you have a collection of fruits.
~~~ php
$fruits = collect([‘apple’, ‘orange’, ‘watermelon']);
~~~
You can transform the value in the collection.

You turn the fruits into big size.
~~~ php
$bigFruits = $fruits->map(function($fruit) {
    return strtoupper($fruit);
});

// [‘APPLE’, ‘ORANGE', ‘WATERMELON’]
~~~
Besides, you can perform checking in the callback function.

You don’t like to eat the orange, so you replace it with the grape.
~~~ php
$noOrange = $bigFruits->map(function($fruit) {
    if ($fruit === ‘ORANGE’) {
        return ‘GRAPE’;
    }

    return $fruit;
});

// [‘APPLE’, ‘GRAPE’, ‘WATERMELON’]
 ~~~
Otherwise, you can modify the item. For example, modify the string collection into associative array collection.

You put the fruits into the basket in order.
~~~ php
$fruitBasket = $noOrange->map(function($fruit, $index) {
    return [
        ’name’ => $fruit,
        ’seq’ => $index + 1
    ];
});

// [[’name’: ‘APPLE’, ’seq’ => 1], [’name’: ‘GRAPE’, ’seq’ => 2], [’name’: ‘WATERMELON’, ’seq’ => 3]]
~~~
# What’s next

How do you use the map method? What is your use case? Email me at [sky4just@gmail.com](mailto:sky4just@gmail.com).
