defmodule SnowplowTracker.Events.EcommerceTransactionItemTest do
  use ExUnit.Case

  alias SnowplowTracker.{Events, Errors, Payload}

  describe "validate/1" do
    test "raises and error if sku, price or quantity is missing" do
      assert_raise Errors.InvalidParam, ~r/^.*sku cannot be empty.*$/, fn ->
        %Events.EcommerceTransactionItem{sku: "", price: 10.0, quantity: 1}
        |> Events.EcommerceTransactionItem.validate()
      end

      assert_raise Errors.InvalidParam, ~r/^.*sku cannot be nil.*$/, fn ->
        %Events.EcommerceTransactionItem{sku: nil, price: 10.0, quantity: 1}
        |> Events.EcommerceTransactionItem.validate()
      end

      assert_raise Errors.InvalidParam, ~r/^.*price cannot be nil.*$/, fn ->
        %Events.EcommerceTransactionItem{sku: "TV", price: nil, quantity: 1}
        |> Events.EcommerceTransactionItem.validate()
      end

      assert_raise Errors.InvalidParam, ~r/^.*quantity cannot be nil.*$/, fn ->
        %Events.EcommerceTransactionItem{sku: "TV", price: 10.0, quantity: nil}
        |> Events.EcommerceTransactionItem.validate()
      end
    end

    test "returns event if it is valid" do
      event = %Events.EcommerceTransactionItem{sku: "TV", price: 10.0, quantity: 1}
      response = Events.EcommerceTransactionItem.validate(event)
      assert event == response
    end
  end

  describe "get/1" do
    test "returns map containing valid data" do
      event_id = "1E501"
      currency = "INR"

      event = %Events.EcommerceTransactionItem{
        sku: "TV",
        price: 10.3792,
        quantity: 1,
        name: nil,
        category: nil,
        event_id: "test_event"
      }

      expected_response = %{
        "e" => "ti",
        "eid" => "test_event",
        "ti_id" => "1E501",
        "ti_sk" => "TV",
        "ti_nm" => nil,
        "ti_ca" => nil,
        "ti_pr" => "10.38",
        "ti_qu" => "1",
        "ti_cu" => "INR"
      }

      response =
        event
        |> Events.EcommerceTransactionItem.get(event_id, currency)
        |> Payload.get()

      assert match?(^expected_response, response)
    end
  end
end
