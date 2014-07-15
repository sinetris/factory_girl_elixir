# FactoryGirlElixir

[![Build Status](https://travis-ci.org/sinetris/factory_girl_elixir.svg?branch=master)](https://travis-ci.org/sinetris/factory_girl_elixir)

Minimal implementation of Ruby's [factory_girl](http://github.com/thoughtbot/factory_girl) in Elixir.

This is a rewrite of the [factory_boy](https://github.com/inkr/factory_boy) project to make it work on Elixir v0.14.x.

## Usage

Add FactoryGirlElixir as a dependency in your `mix.exs` file.

```elixir
defp deps do
  [
    {:factory_girl_elixir, , github: "sinetris/factory_girl_elixir"}
  ]
end
```

You should also update your applications list to include both projects:

```elixir
def application do
  [applications: [:factory_girl_elixir]]
end
```

After you are done, run `mix deps.get` in your shell to fetch the dependencies.


## Defining a Factory

```elixir
defmodule Factory do
  use FactoryGirlElixir.Factory

  factory :user do
    field :password, "secret"
    # create a sequence using an anonymous functions
    field :username, fn(n) ->
      "username#{n}"
    end
    # or an anonymous functions shortcut
    field :email, &("foo#{&1}@example.com")
  end

  factory :assets do
    field :name, "bob"
  end
end
```

Then query the module to get a list of attributes for your record

```elixir
Factory.attributes_for(:user) #=> [username: "foo", password: "bar", email: "foo1@bar.com"]
```
