defmodule SnowplowTracker.Events.SelfDescribingTest do
  use ExUnit.Case

  alias SnowplowTracker.{Errors, Events, SelfDescribingJson, Payload}

  describe "new/1" do
    test "returns a struct containing the appropriate fields" do
      event =
        Events.SelfDescribing.new(%{
          event: %SelfDescribingJson{}
        })

      assert event.event == %SelfDescribingJson{}
    end

    test "raises an error on invalid input parameter" do
      assert_raise Errors.InvalidParam, ~r/^.*expected map.*$/, fn ->
        Events.SelfDescribing.new("test")
      end
    end
  end

  describe "validate/1" do
    test "returns the event if it is valid" do
      event = %Events.SelfDescribing{event: %SelfDescribingJson{}}
      assert event == Events.SelfDescribing.validate(event)
    end
  end

  describe "get/1" do
    test "returns unencoded map with params if event is valid" do
      expected_response = %{
        "e" => "ue",
        "dtm" => "123",
        "eid" => "test_event",
        "ttm" => "123",
        "ue_pr" => "{\"data\":\"test_data\",\"schema\":\"test\"}"
      }

      event = %Events.SelfDescribing{
        event: %SelfDescribingJson{schema: "test", data: "test_data"},
        timestamp: 123,
        event_id: "test_event",
        true_timestamp: 123
      }

      response =
        event
        |> Events.SelfDescribing.get(false)
        |> Payload.get()

      assert match?(^expected_response, response)
    end

    test "returns base64 encoded map with params if event is valid" do
      expected_response = %{
        "e" => "ue",
        "dtm" => "123",
        "eid" => "test_event",
        "ttm" => "123",
        "ue_px" => "eyJkYXRhIjoidGVzdF9kYXRhIiwic2NoZW1hIjoidGVzdCJ9"
      }

      event = %Events.SelfDescribing{
        event: %SelfDescribingJson{schema: "test", data: "test_data"},
        timestamp: 123,
        event_id: "test_event",
        true_timestamp: 123
      }

      response =
        event
        |> Events.SelfDescribing.get(true)
        |> Payload.get()

      assert match?(^expected_response, response)
    end
  end
end
