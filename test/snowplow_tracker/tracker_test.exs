defmodule SnowplowTracker.TrackerTest do
  use ExUnit.Case

  alias SnowplowTracker.{Tracker, Errors}

  describe "validate/1" do
    test "fails if the emitter is nil" do
      assert_raise Errors.InvalidParam, ~r/^.*emitter cannot be nil.*$/, fn ->
        Tracker.validate(%Tracker{emitter: nil})
      end
    end

    test "fails if subject is nil" do
      assert_raise Errors.InvalidParam, ~r/^.*subject cannot be nil.*$/, fn ->
        Tracker.validate(%Tracker{subject: nil})
      end
    end

    test "fails if base64_encode is not boolean" do
      assert_raise Errors.InvalidParam, ~r/^.*base64_encode should be boolean.*$/, fn ->
        Tracker.validate(%Tracker{base64_encode: 1})
      end
    end
  end
end
