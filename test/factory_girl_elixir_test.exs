defmodule FactoryGirlElixirTest do
  use ExUnit.Case

  defmodule Factory do
    use FactoryGirlElixir.Factory

    factory :user do
      field :name, "joe"
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

    parametrized_user = %{"email" => "foo1@example.com", "password" => "secret", "name" => "joe"}
    assert parametrized_user == Factory.attributes_for(:user) |> Factory.parametrize
  end

  test "override attributes" do
    FactoryGirlElixir.Worker.reset

    user_attributes = %{email: "foo1@example.com", password: "not-secret", name: "andrea"}
    assert user_attributes == Factory.attributes_for(:user, password: "not-secret", name: "andrea")
  end

  test "overriding dinamic attributes don't increment counter" do
    FactoryGirlElixir.Worker.reset

    user_attributes = %{email: "foo1@example.com", password: "secret", name: "joe"}
    assert user_attributes == Factory.attributes_for(:user)
    user_attributes = %{email: "user@example.com", password: "secret", name: "joe"}
    assert user_attributes == Factory.attributes_for(:user, email: "user@example.com")
    user_attributes = %{email: "foo2@example.com", password: "secret", name: "joe"}
    assert user_attributes == Factory.attributes_for(:user)
  end
end
