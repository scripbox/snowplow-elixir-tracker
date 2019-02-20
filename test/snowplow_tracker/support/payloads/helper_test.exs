defmodule SnowplowTracker.Support.Payloads.HelperTest do
  use ExUnit.Case

  alias SnowplowTracker.Errors
  alias SnowplowTracker.Support.Payloads.Helper

  describe "sanitize/1" do
    test "raises an error if the input is empty" do
      assert_raise Errors.InvalidParam, ~r/^.*empty string is not valid.*$/, fn ->
        Helper.sanitize("")
      end
    end

    test "returns the param if it is valid" do
      assert "hello" == Helper.sanitize("hello")
    end
  end

  describe "convert_to_json/2" do
    test "returns base64 encoded json string of map" do
      map = %{test: "value"}
      expected_response = "eyJ0ZXN0IjoidmFsdWUifQ=="
      response = Helper.convert_to_json(map, true)
      assert expected_response == response
    end

    test "returns unencoded json string of map" do
      map = %{test: "value"}
      expected_response = "{\"test\":\"value\"}"
      response = Helper.convert_to_json(map, false)
      assert expected_response == response
    end
  end
end
