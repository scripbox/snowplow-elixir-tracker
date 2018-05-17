defmodule SnowplowTracker.Events.TimingTest do
  use ExUnit.Case

  alias SnowplowTracker.{Errors, SelfDescribingJson}
  alias SnowplowTracker.Events.Timing
  alias SnowplowTracker.Events.SelfDescribing

  describe "new/1" do
    test "returns a struct containing the appropriate fields" do
      event =
        Timing.new(%{
          category: "electronics",
          variable: "page_view",
          timing: 10
        })

      assert event.category == "electronics"
      assert event.variable == "page_view"
      assert event.timing == 10
    end

    test "raises an error on invalid input parameter" do
      assert_raise Errors.InvalidParam, ~r/^.*expected map.*$/, fn ->
        Timing.new("test")
      end
    end
  end

  describe "validate/1" do
    test "raises an error if the category attribute is empty" do
      assert_raise Errors.InvalidParam, ~r/^.*category cannot be blank.*$/, fn ->
        Timing.validate(%Timing{category: nil, variable: "test", timing: 10})
      end

      assert_raise Errors.InvalidParam, ~r/^.*category cannot be blank.*$/, fn ->
        Timing.validate(%Timing{category: "", variable: "test", timing: 10})
      end
    end

    test "raises an error if the variable attribute is empty" do
      assert_raise Errors.InvalidParam, ~r/^.*variable cannot be blank.*$/, fn ->
        Timing.validate(%Timing{category: "animal", variable: nil, timing: 10})
      end

      assert_raise Errors.InvalidParam, ~r/^.*variable cannot be blank.*$/, fn ->
        Timing.validate(%Timing{category: "animal", variable: "", timing: 10})
      end
    end

    test "raises an error if the timing attribute is empty" do
      assert_raise Errors.InvalidParam, ~r/^.*timing cannot be blank.*$/, fn ->
        Timing.validate(%Timing{category: "animal", variable: "test", timing: nil})
      end
    end

    test "returns the event if it is valid" do
      event = %Timing{category: "animal", variable: "test", timing: 10}
      assert event == Timing.validate(event)
    end
  end

  describe "get/1" do
    test "returns self describing object with valid attributes" do
      event = %Timing{
        category: "animal",
        variable: "test",
        timing: 10,
        label: "test",
        timestamp: 123,
        event_id: "test_event",
        true_timestamp: 123
      }

      expected_response = %SelfDescribing{
        event: %SelfDescribingJson{
          schema: "iglu:com.snowplowanalytics.snowplow/timing/jsonschema/1-0-0",
          data: %{
            "category" => "animal",
            "variable" => "test",
            "timing" => 10,
            "label" => "test"
          }
        },
        timestamp: 123,
        event_id: "test_event",
        true_timestamp: 123
      }

      response = Timing.get(event)
      assert match?(^expected_response, response)
    end
  end
end
