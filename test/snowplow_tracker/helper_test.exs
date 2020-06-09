defmodule SnowplowTracker.HelperTest do
  use ExUnit.Case

  alias SnowplowTracker.SelfDescribingJson
  alias SnowplowTracker.{Tracker, Subject, Helper, Payload}

  describe "add_data/3" do
    test "returns a payload containing the standard pairs" do
      tracker = %Tracker{app_id: "test"}
      contexts = []

      expected_response = %{
        "aid" => "test",
        "p" => "srv",
        "tna" => nil,
        "tv" => "elixir-0.1.0"
      }

      response =
        %Payload{}
        |> Helper.add_data(
          tracker,
          contexts
        )
        |> Payload.get()

      assert match?(^expected_response, response)
    end

    test "returns a payload containing the subject pairs" do
      subject = Subject.set_user_id(%Subject{}, "UCANTSEEME")
      tracker = %Tracker{app_id: "test", subject: subject}
      contexts = []

      expected_response = %{
        "aid" => "test",
        "p" => "srv",
        "tna" => nil,
        "tv" => "elixir-0.1.0",
        "uid" => "UCANTSEEME"
      }

      response =
        %Payload{}
        |> Helper.add_data(
          tracker,
          contexts
        )
        |> Payload.get()

      assert match?(^expected_response, response)
    end

    test "returns a base64 encoded payload containing the context data" do
      subject = Subject.set_user_id(%Subject{}, "UCANTSEEME")
      tracker = %Tracker{app_id: "test", subject: subject}
      contexts = [%SelfDescribingJson{schema: "test_schema", data: "data"}]

      expected_response = %{
        "aid" => "test",
        "p" => "srv",
        "tna" => nil,
        "tv" => "elixir-0.1.0",
        "uid" => "UCANTSEEME",
        "cx" =>
          "eyJkYXRhIjpbeyJkYXRhIjoiZGF0YSIsInNjaGVtYSI6InRlc3Rfc2NoZW1hIn1dLCJzY2hlbWEiOiJpZ2x1OmNvbS5zbm93cGxvd2FuYWx5dGljcy5zbm93cGxvdy9jb250ZXh0cy9qc29uc2NoZW1hLzEtMC0xIn0="
      }

      response =
        %Payload{}
        |> Helper.add_data(
          tracker,
          contexts
        )
        |> Payload.get()

      assert match?(^expected_response, response)
    end

    test "returns a unencoded payload containing the context data" do
      subject = Subject.set_user_id(%Subject{}, "UCANTSEEME")
      tracker = %Tracker{app_id: "test", subject: subject, base64_encode: false}
      contexts = [%SelfDescribingJson{schema: "test_schema", data: "data"}]

      expected_response = %{
        "aid" => "test",
        "p" => "srv",
        "tna" => nil,
        "tv" => "elixir-0.1.0",
        "uid" => "UCANTSEEME",
        "co" =>
          ~s({"data":[{"data":"data","schema":"test_schema"}],"schema":"iglu:com.snowplowanalytics.snowplow/contexts/jsonschema/1-0-1"})
      }

      response =
        %Payload{}
        |> Helper.add_data(
          tracker,
          contexts
        )
        |> Payload.get()

      assert match?(^expected_response, response)
    end
  end
end
