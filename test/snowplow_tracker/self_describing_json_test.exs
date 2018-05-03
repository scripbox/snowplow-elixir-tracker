defmodule SnowplowTracker.SelfDescribingJsonTest do
  use ExUnit.Case

  alias SnowplowTracker.SelfDescribingJson

  describe "get/1" do
    test "returns json encoded event" do
      event = %SelfDescribingJson{
        schema: "test_schema",
        data: "test_data"
      }

      expected_response = "{\"data\":\"test_data\",\"schema\":\"test_schema\"}"
      response = SelfDescribingJson.get(event)
      assert expected_response == response
    end
  end
end
