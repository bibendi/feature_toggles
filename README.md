[![Gem Version](https://badge.fury.io/rb/feature_toggles.svg)](https://badge.fury.io/rb/feature_toggles)
[![Build Status](https://travis-ci.org/bibendi/feature_toggles.svg?branch=master)](https://travis-ci.org/bibendi/feature_toggles)

# FeatureToggles

This gem provides a mechanism for pending features that take longer than a single release cycle. The basic idea is to have a configuration file that defines a bunch of toggles for various features you have pending. The running application then uses these toggles in order to decide whether or not to show the new feature.

<a href="https://evilmartians.com/?utm_source=feature_toggles">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54"></a>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'feature_toggles'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install feature_toggles

## Usage

```ruby
features = FeatureToggles.build do
  # define env var prefix to enable features
  # globally by passing MY_PREFIX_BAR=1
  env "MY_PREFIX"

  feature :bar do
    user.can_bar?
  end

  feature :foo do |user: nil|
    !user.nil? && user.can_foo?
  end
end

features.enabled?(:bar)
features.enabled?(:bar, user: user)
features.for(user: user).enabled?(:foo)
```

### Example

This is step-by-step guide to add `feature_toggles` to Rails application.

**Step 0. (optional) Add `features` to User model**

**NOTE**: This is not the part of this gem–you can model you per-user features settings differently.

```ruby
class AddFeaturesToUsers < ActiveRecord::Migration
  def change
    # we use a `features` array column to store user's active features
    add_column :users, :features, :string, array: true, default: []
  end
end
```

**Step 1. Define features**

```ruby
# config/initializers/features.rb
Features = FeatureToggles.build do
  env "FEATURE"

  feature :chat do |user: nil|
    user&.features.include?("chat")
  end
end
```

**Step 2. Add `current_features` helper and use it.**

```ruby
class ApplicationController < ActionController::Base
  # ...
  helper_method :current_features
  
  def current_features
    Features.for(user: current_user)
  end
end
```

**Step 3. Use `current_features`.**

For example, in your navigation template:

```erb
<ul>
 <% if current_features.enabled?(:chat) %>
   <li><a href="/chat">Chat</a></li>
 <% end %>
</ul>
```

Or in your controller:

```ruby
class ChatController < ApplicationController
  def index
    unless current_features.enabled?(:chat)
      return render template: "comming_soon"
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bibendi/feature_toggles. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FeatureToggles project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bibendi/feature_toggles/blob/master/CODE_OF_CONDUCT.md).
