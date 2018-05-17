defmodule SnowplowTracker.Events.ScreenViewTest do
  use ExUnit.Case

  alias SnowplowTracker.{Errors, Events, SelfDescribingJson}

  describe "new/1" do
    test "returns a struct containing the appropriate fields" do
      event =
        Events.ScreenView.new(%{
          name: "screen_view"
        })

      assert event.name == "screen_view"
    end

    test "raises an error on invalid input parameter" do
      assert_raise Errors.InvalidParam, ~r/^.*expected map.*$/, fn ->
        Events.ScreenView.new("test")
      end
    end
  end

  describe "validate/1" do
    test "raises error if name and id are blank" do
      assert_raise Errors.InvalidParam, ~r/^.*both cannot be blank.*$/, fn ->
        Events.ScreenView.validate(%Events.ScreenView{})
      end

      assert_raise Errors.InvalidParam, ~r/^.*both cannot be blank.*$/, fn ->
        Events.ScreenView.validate(%Events.ScreenView{name: ""})
      end

      assert_raise Errors.InvalidParam, ~r/^.*both cannot be blank.*$/, fn ->
        Events.ScreenView.validate(%Events.ScreenView{id: ""})
      end

      assert_raise Errors.InvalidParam, ~r/^.*both cannot be blank.*$/, fn ->
        Events.ScreenView.validate(%Events.ScreenView{name: "", id: ""})
      end
    end

    test "returns event if it is valid" do
      event = %Events.ScreenView{name: "test_screen"}
      assert event == Events.ScreenView.validate(event)
    end
  end

  describe "get/1" do
    test "returns a valid self describing event" do
      event = %Events.ScreenView{name: "test_screen"}

      expected_response = %SelfDescribingJson{
        schema: "iglu:com.snowplowanalytics.snowplow/screen_view/jsonschema/1-0-0",
        data: %{
          "name" => "test_screen",
          "id" => nil
        }
      }

      response = Events.ScreenView.get(event)
      assert struct(response)
      assert expected_response == response.event
    end
  end
end
