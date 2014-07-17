defmodule FactoryGirlElixirTest do
  use ExUnit.Case

  defmodule Factory do
    use FactoryGirlElixir.Factory

    factory :user do
      field :password, "secret"
      field :email, &("foo#{&1}@example.com")
    end

    factory :assets do
      field :name, "bob"
    end
  end

  test "factories" do
    assert "secret" == Factory.attributes_for(:user).password
    assert "bob" == Factory.attributes_for(:assets).name
  end

  test "generates a sequence" do
    FactoryGirlElixir.Worker.reset

    assert "foo1@example.com" == Factory.attributes_for(:user).email
    assert "foo2@example.com" == Factory.attributes_for(:user).email
  end

  test "parametrize simple factory" do
    parametrized_assets = %{"name" => "bob"}
    assert parametrized_assets == Factory.attributes_for(:assets) |> Factory.parametrize
  end

  test "parametrize factory with sequence" do
    FactoryGirlElixir.Worker.reset

    parametrized_user = %{"email" => "foo1@example.com", "password" => "secret"}
    assert parametrized_user == Factory.attributes_for(:user) |> Factory.parametrize
  end
end
