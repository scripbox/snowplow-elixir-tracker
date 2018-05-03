defmodule SnowplowTracker.Events.SelfDescribingTest do
  use ExUnit.Case

  alias SnowplowTracker.{Events, SelfDescribingJson, Payload}

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
        "ue_pr" =>
          "\"{\\\"data\\\":\\\"{\\\\\\\"data\\\\\\\":\\\\\\\"test_data\\\\\\\",\\\\\\\"schema\\\\\\\":\\\\\\\"test\\\\\\\"}\\\",\\\"schema\\\":\\\"iglu:com.snowplowanalytics.snowplow/unstruct_event/jsonschema/1-0-0\\\"}\""
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
        "ue_px" =>
          "IntcImRhdGFcIjpcIntcXFwiZGF0YVxcXCI6XFxcInRlc3RfZGF0YVxcXCIsXFxcInNjaGVtYVxcXCI6XFxcInRlc3RcXFwifVwiLFwic2NoZW1hXCI6XCJpZ2x1OmNvbS5zbm93cGxvd2FuYWx5dGljcy5zbm93cGxvdy91bnN0cnVjdF9ldmVudC9qc29uc2NoZW1hLzEtMC0wXCJ9Ig=="
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
