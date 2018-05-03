defmodule SnowplowTracker.Emitters.HelperTest do
  use ExUnit.Case

  alias SnowplowTracker.Errors
  alias SnowplowTracker.Emitters.Helper

  describe "generate_endpoint/5" do
    test "generates url with parameters from payload" do
      payload = %{test: "value"}

      url =
        Helper.generate_endpoint(
          "http",
          "localhost",
          nil,
          payload,
          "GET"
        )

      assert String.contains?(url, "http://localhost/i?test=value")

      url =
        Helper.generate_endpoint(
          "http",
          "localhost",
          8000,
          payload,
          "GET"
        )

      assert String.contains?(url, "http://localhost:8000/i?test=value")
    end

    test "raises error when POST method is called" do
      assert_raise Errors.NotImplemented, fn ->
        Helper.generate_endpoint(
          "http",
          "localhost",
          nil,
          %{},
          "POST"
        )
      end
    end
  end
end
