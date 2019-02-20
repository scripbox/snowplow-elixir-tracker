defmodule SnowplowTracker.Support.Subjects.HelperTest do
  use ExUnit.Case

  alias SnowplowTracker.Errors
  alias SnowplowTracker.Support.Subjects.Helper

  describe "validate_platform/1" do
    test "raises an error if the platform is invalid" do
      platform = "invalid_platform"

      assert_raise Errors.InvalidParam, ~r/^.*specified platform is not supported.*$/, fn ->
        Helper.validate_platform(platform)
      end
    end

    test "return the platform if it is valid" do
      platform = "pc"
      assert platform == Helper.validate_platform(platform)
    end
  end
end
