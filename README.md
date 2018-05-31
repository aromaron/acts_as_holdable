[![Build Status](https://travis-ci.org/aromaron/acts_as_holdable.svg?branch=master)](https://travis-ci.org/aromaron/acts_as_holdable)
[![Maintainability](https://api.codeclimate.com/v1/badges/74d210e67822c530e218/maintainability)](https://codeclimate.com/github/aromaron/acts_as_holdable/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/aromaron/acts_as_holdable/badge.svg?branch=master)](https://coveralls.io/github/aromaron/acts_as_holdable?branch=master)

# ActsAsHoldable
ActsAsHoldable allows resources to be held by users. It:

* Is a MVC solution based on Rails engines

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'acts_as_holdable'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install acts_as_holdable
```

## Migrations

```bash
bundle exec rake acts_as_holdable_engine:install:migrations
```

## Holdables, Holders and Holdings

To set-up a Holdable model, use acts_as_holdable. A Holdable model is enabled to be held.

```ruby
class Ticket < ApplicationRecord
  acts_as_holdable
end
```

To set-up a Holder model, use acts_as_holder. Only Holders can create holdings.

```ruby
class User < ApplicationRecord
  acts_as_holder
end
```

From this time on, a User can hold a Ticket with

```ruby
@user.hold! @ticket
```

A User can unhold a Ticket with

```ruby
@holding = @user.hold! @ticket
@user.unhold! @holding
```

You can access holdings both from the Holdable and the Holder

```ruby
@ticket.holdings # return all holdings created on this ticket
@user.holdings # return all holdings made by this user
```

## Configuring Options

There are a number available options to make your models behave differently. They are all configurable in the Holdable model, passing a hash to `acts_as_holdable`

Available options (with values) are:

* `:on_hand_type`: Specifies how the `amount` of a holding (e.g. number of tickets from an event) affects the future availability of the holdable. Allowed values are:
  * `:none`
  * `:open`

### No constraints

The model accepts holdings without any constraint. This means every holder can create an infinite number of holdings on it and no capacity or time checks are performed.

Creating a holding on this model means holding it forever and without care for other existing holdings. In other words, the number of holdings do not affect the availability of this holdable. (e.g. pre-ordering a product that will be released soon)

### Capacity constraints

The option `on_hand_type` may be used to set a constraint over the `amount` attribute of the holding

#### No capacity constraints - `on_hand_type: :none`

The model is holdable without capacity constraints.

```ruby
class Product < ActiveRecord::Base
  # As `on_hand_type: :none` is a default and can be ommited
  acts_as_holdable on_hand_type: :none
end
```

#### Open capacity - `on_hand_type: :open`

> WARNING - **migration needed!** - with this option the model must have an attribute `on_hand: :integer`

The model is holdable until its `capacity` is reached. (e.g. an event't tickets types)

**Configuration**

```ruby
class Event < ActiveRecord::Base
  acts_as_holdable on_hand_type: :open
end
```

**Creating a new holdable**

Each instance of the model must define its capacity.

```ruby
@ticket = Ticket.new(...)
@ticket.on_hand = 30 # This event allows 30 tickets
@ticket.save!
```

**Holding**

```ruby
# Holding a model with `on_hand_type: :open` requires `:amount`

@user1.hold! @ticket, amount: 5 # holding tickets for 5 people, OK
@user2.hold! @ticket, amount: 20 # holding tickets for other 20 people, OK
@user3.hold! @ticket, amount: 10 # overholding! raise ActsAsHoldable::AvailabilityError
```

## Holding resources on a span of time

Holdings can be created to be 'living' within a span of time, if the holding doesn't gets confirmed within the time span, it will be destroyed. 


```ruby
@holding = @user.hold_for(@ticket, duration: 10.minutes, amount: 1)
```

A User can confirm a holding with

```ruby
@user.confirm_holding!(@holding)
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

### Acknowledgements

To speed-up the initialization process of this project, the structure of this repository was strongly influenced by ActsAsBookable by Tandù srl.
