defmodule Snowplow.Support.Events.HelperTest do
  use ExUnit.Case

  alias SnowplowTracker.Support.Events.Helper
  alias SnowplowTracker.OsMock

  describe "generate_uuid/0" do
    test "returns valid v4 UUID" do
      response = Helper.generate_uuid()
      version = Keyword.get(UUID.info!(response), :version)
      assert is_binary(response)
      assert version == 4
    end
  end

  describe "generate_timestamp/1" do
    test "calls the function to generate system time" do
      Helper.generate_timestamp(OsMock)
      assert_receive "timestamp generated"
    end
  end

  describe "to_string/1" do
    test "returns nil if the number is nil" do
      response = Helper.to_string(nil)
      assert is_nil(response)
    end

    test "rounds to 2 places and returns string for float number" do
      number = 32.7892
      expected = "32.79"
      response = Helper.to_string(number)
      assert expected == response
    end

    test "converts to string for integer number" do
      response = Helper.to_string(1234)
      assert "1234" == response
    end

    test "returns the variable without modification if all matches fail" do
      response = Helper.to_string("invalid_number")
      assert "invalid_number" == response
    end
  end
end
