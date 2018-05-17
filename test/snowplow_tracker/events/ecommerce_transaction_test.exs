defmodule SnowplowTracker.Events.EcommerceTransactionTest do
  use ExUnit.Case

  alias SnowplowTracker.{Errors, Events, Payload}

  describe "new/1" do
    test "returns a struct containing the appropriate fields" do
      event =
        Events.EcommerceTransaction.new(%{
          order_id: "ORDER_001",
          total_value: 2301.23
        })

      assert event.order_id == "ORDER_001"
      assert event.total_value == 2301.23
    end

    test "raises an error on invalid input parameter" do
      assert_raise Errors.InvalidParam, ~r/^.*expected map.*$/, fn ->
        Events.EcommerceTransaction.new("test")
      end
    end
  end

  describe "validate/1" do
    test "raises error if order_id is blank" do
      assert_raise Errors.InvalidParam, ~r/^.*order_id cannot be blank.*$/, fn ->
        Events.EcommerceTransaction.validate(%Events.EcommerceTransaction{
          order_id: nil,
          total_value: nil
        })
      end

      assert_raise Errors.InvalidParam, ~r/^.*order_id cannot be blank.*$/, fn ->
        Events.EcommerceTransaction.validate(%Events.EcommerceTransaction{
          order_id: "",
          total_value: ""
        })
      end
    end

    test "raises error if total_value is blank" do
      assert_raise Errors.InvalidParam, ~r/^.*total_value cannot be nil.*$/, fn ->
        Events.EcommerceTransaction.validate(%Events.EcommerceTransaction{
          order_id: "10",
          total_value: nil
        })
      end
    end

    test "returns event if it is valid" do
      event = %Events.EcommerceTransaction{order_id: "1E501", total_value: 10.0}
      assert event == Events.EcommerceTransaction.validate(event)
    end
  end

  describe "get/1" do
    test "returns a valid ecommerce transaction event" do
      event = %Events.EcommerceTransaction{
        order_id: "1E501",
        total_value: 300.321,
        affiliation: nil,
        tax_value: nil,
        shipping: nil,
        city: nil,
        state: nil,
        country: nil,
        currency: nil,
        timestamp: 123,
        event_id: "test_event",
        true_timestamp: 123
      }

      expected_response = %{
        "e" => "tr",
        "tr_id" => "1E501",
        "tr_tt" => "300.32",
        "tf_af" => nil,
        "tr_tx" => nil,
        "tr_sh" => nil,
        "tr_ci" => nil,
        "tr_st" => nil,
        "tr_co" => nil,
        "tr_cu" => nil,
        "dtm" => "123",
        "eid" => "test_event",
        "ttm" => "123"
      }

      response =
        event
        |> Events.EcommerceTransaction.get()
        |> Payload.get()

      assert expected_response["e"] == response["e"]
      assert expected_response["tr_id"] == response["tr_id"]
      assert expected_response["tr_tt"] == response["tr_tt"]
      assert expected_response["tf_af"] == response["tf_af"]
      assert expected_response["tr_tx"] == response["tr_tx"]
      assert expected_response["tr_sh"] == response["tr_sh"]
      assert expected_response["tr_ci"] == response["tr_ci"]
      assert expected_response["tr_st"] == response["tr_st"]
      assert expected_response["tr_co"] == response["tr_co"]
      assert expected_response["tr_cu"] == response["tr_cu"]
      assert expected_response["dtm"] == response["dtm"]
      assert expected_response["eid"] == response["eid"]
      assert expected_response["ttm"] == response["ttm"]
    end
  end
end
