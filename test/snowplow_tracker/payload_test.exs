defmodule SnowplowTracker.PayloadTest do
  use ExUnit.Case

  alias SnowplowTracker.Payload

  describe "add/1" do
    test "adds a new key-value pair to the payload object" do
      response =
        %Payload{}
        |> Payload.add(:test, "value")
        |> Payload.get()

      assert response[:test] == "value"
    end
  end

  describe "add_map/2" do
    test "adds a map to the payload object" do
      response =
        %Payload{}
        |> Payload.add_map(%{test: "value"})
        |> Payload.get()

      assert response[:test] == "value"
    end
  end

  describe "add_json/5" do
    test "encodes a map as base64 and adds it as a new key" do
      expected_response = "eyJ0ZXN0IjoidmFsdWUifQ=="

      response =
        %Payload{}
        |> Payload.add_json(%{test: "value"}, "encoded", nil, true)
        |> Payload.get()

      assert expected_response == response["encoded"]
    end

    test "does not encode the map and adds it as a new key" do
      expected_response = "{\"test\":\"value\"}"

      response =
        %Payload{}
        |> Payload.add_json(%{test: "value"}, nil, "not_encoded", false)
        |> Payload.get()

      assert expected_response == response["not_encoded"]
    end
  end

  describe "get/1" do
    test "returns the payload map" do
      response =
        %Payload{pairs: %{test: "value"}}
        |> Payload.get()

      assert "value" == response[:test]
    end
  end

  describe "string/1" do
    test "encodes the payload as base64 string" do
      expected_response = "eyJ0ZXN0IjoidmFsdWUifQ=="

      response =
        %Payload{}
        |> Payload.add(:test, "value")
        |> Payload.string(true)

      assert expected_response == response
    end

    test "encodes the payload as json string" do
      expected_response = "{\"test\":\"value\"}"

      response =
        %Payload{}
        |> Payload.add(:test, "value")
        |> Payload.string(false)

      assert expected_response == response
    end
  end

  describe "decode/1" do
    test "decodes the json input string" do
      expected_response = Payload.new(%{test: "value"})

      response = Payload.decode("{\"test\":\"value\"}")

      assert response == expected_response
    end

    test "fails for invalid json" do
      response = Payload.decode("Invalid Json")

      assert response == {
               :error,
               %Jason.DecodeError{data: "Invalid Json", position: 0, token: nil}
             }
    end
  end

  describe "decode!/1" do
    test "returns payload object with JSON data" do
      response =
        "{\"test\":\"value\"}"
        |> Payload.decode!()
        |> Payload.get()

      assert response == %{"test" => "value"}
    end
  end
end
