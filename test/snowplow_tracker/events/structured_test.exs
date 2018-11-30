defmodule SnowplowTracker.Events.StructuredTest do
  use ExUnit.Case

  alias SnowplowTracker.{Events, Errors, Payload}

  describe "new/1" do
    test "returns a struct containing the appropriate fields" do
      event =
        Events.Structured.new(%{
          category: "electronics",
          action: "page_view"
        })

      assert event.category == "electronics"
      assert event.action == "page_view"
    end

    test "raises an error on invalid input parameter" do
      assert_raise Errors.InvalidParam, ~r/^.*expected map.*$/, fn ->
        Events.Structured.new("test")
      end
    end
  end

  describe "validate/1" do
    test "return invalid_param if category is nil" do
      assert_raise Errors.InvalidParam, ~r/^.*category cannot be blank.*$/, fn ->
        %Events.Structured{category: nil, action: "test"}
        |> Events.Structured.validate()
      end

      assert_raise Errors.InvalidParam, ~r/^.*category cannot be blank.*$/, fn ->
        %Events.Structured{category: "", action: "test"}
        |> Events.Structured.validate()
      end
    end

    test "return invalid_param if action is nil" do
      assert_raise Errors.InvalidParam, ~r/^.*action cannot be blank.*$/, fn ->
        %Events.Structured{category: "test", action: nil}
        |> Events.Structured.validate()
      end

      assert_raise Errors.InvalidParam, ~r/^.*action cannot be blank.*$/, fn ->
        %Events.Structured{category: "test", action: ""}
        |> Events.Structured.validate()
      end
    end

    test "returns the event if it is valid" do
      event = Events.Structured.new(%{category: "animal", action: "pet"})
      assert event == Events.Structured.validate(event)
    end
  end

  describe "get/1" do
    test "returns payload object with valid attributes" do
      event = %Events.Structured{
        category: "animal",
        action: "pet",
        label: "test",
        property: "paw",
        value: 100.0,
        timestamp: 123,
        event_id: "test_event",
        true_timestamp: 123
      }

      expected_response = %{
        "e" => "se",
        "se_ca" => "animal",
        "se_ac" => "pet",
        "se_la" => "test",
        "se_pr" => "paw",
        "se_va" => "100.0",
        "dtm" => "123",
        "eid" => "test_event",
        "ttm" => "123"
      }

      response =
        event
        |> Events.Structured.get()
        |> Payload.get()

      assert match?(^expected_response, response)
    end
  end
end
