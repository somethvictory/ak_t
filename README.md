## Requirements
- Ruby 3.0.3
- Rails 7.0.1
- Database sqlite3

## Setup
```git clone git@github.com:somethvictory/ak_t.git```

cd `ak_t`, run:
- `rails db:create`
- `rails db:migrate`
- `rails db:seed`

To start the server, run `rails s`

To run tests, run `rspec`
## Features
The input of the data can be manage by the admin panel by visiting `localhost:3000/admin`

##### STOCK
* **Blocks** For blocking the inventory
* **Inventories** For setting up stock for the items. Each inventory is a unique combination of an `outlet`, `item`, `modifier`, and `fulfilment_type`. This means that the inventory is an atomic record of an item and a modifier and a fulfilment_type within an outlet.

Say if Pizza Hut has `Pizza` with `Small` and `Large` size with `Delivery` and `Pickup` options, the user has to create 4 inventories:
1. Inventory 1: A combination of `Pizza Hut(outlet_id)`, `Pizza(item_id)`, `Small(modifier_id)`, `Delivery(fulfilment_type)`
2. Inventory 1: A combination of `Pizza Hut(outlet_id)`, `Pizza(item_id)`, `Large(modifier_id)`, `Delivery(fulfilment_type)`
3. Inventory 1: A combination of `Pizza Hut(outlet_id)`, `Pizza(item_id)`, `Small(modifier_id)`, `Pickup(fulfilment_type)`
3. Inventory 1: A combination of `Pizza Hut(outlet_id)`, `Pizza(item_id)`, `Large(modifier_id)`, `Pickup(fulfilment_type)`

The inventory can be set up with `serving_date_start`, `serving_date_end`, `timeslot_start`, `timeslot_end`. This means that the inventory is only available for a specific provided date and timeslot range.

In order to create a new order, the inventory of item with the unique combination mentioned above must be present.

##### OPERATION
* **Orders** For the user create new orders.The order can only be created once the order item and its related modifier is already in the inventory list.

When the order is created with order item, the quantity from the inventory should be deducted. Similarly, when the order item of the order is updated, the inventory quantity should be updated accordingly.
##### ARRAGEMENT
This sections store all the information related to the item and its related components. There are no stock related logic on this part. All the information are used to set up the structure of the restaurant menu only.

After running `rails db:seed`, there should be sample data for each of the item.

## Stock Availability API

After setting up the inventories and blocks. The item availability can be queried by calling:

`http://localhost:3000/stock?outlet_id=4&fulfilment_type=Delivery`

Accepted params:
* `outlet_id`(required): The ID of the outlet
* `fulfilment_type`(required): The fulfilment_type of the inventory
* `serving_date_start`: serving date start of the inventory. For example `2022-01-30`
* `serving_date_end`: serving end start of the inventory. For example `2022-02-30`
* `timeslot_start`: Integer represents timeslot start value. For example `12:00AM` = `0`
* `timeslot_end`: Integer represents timeslot end value. For example `11:00PM` = `82800`

**Timeslot Integer**
'12:00AM' => 0,
'01:00AM' => 3600,
'02:00AM' => 7200,
'03:00AM' => 10800,
'04:00AM' => 14400,
'05:00AM' => 18000,
'06:00AM' => 21600,
'07:00AM' => 25200,
'08:00AM' => 28800,
'09:00AM' => 32400,
'10:00AM' => 36000,
'11:00AM' => 39600,
'12:00PM' => 43200,
'01:00PM' => 46800,
'02:00PM' => 50400,
'03:00PM' => 54000,
'04:00PM' => 57600,
'05:00PM' => 61200,
'06:00PM' => 64800,
'07:00PM' => 68400,
'08:00PM' => 72000,
'09:00PM' => 75600,
'10:00PM' => 79200,
'11:00PM' => 82800

## Missing Features

* When a modifier group with a minimum required has no available modifiers, the product should be marked as sold out.

## Implementation details
- Please refer to [each commit for implementation details](https://github.com/somethvictory/ak_t/commits/main)