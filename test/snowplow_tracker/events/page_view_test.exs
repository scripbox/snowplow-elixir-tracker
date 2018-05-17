defmodule SnowplowTracker.Events.PageViewTest do
  use ExUnit.Case

  alias SnowplowTracker.{Events, Errors, Payload}

  setup_all do
    {:ok, event: Events.PageView.new(%{page_url: "test.com"})}
  end

  describe "new/1" do
    test "returns a struct containing the appropriate fields", context do
      event = context[:event]
      assert event.page_url == "test.com"
    end

    test "raises an error on invalid input parameter" do
      assert_raise Errors.InvalidParam, ~r/^.*expected map.*$/, fn ->
        Events.PageView.new("test")
      end
    end
  end

  describe "validate/1" do
    test "return invalid_param if page_url is nil" do
      assert_raise Errors.InvalidParam, ~r/^.*page_url cannot be blank.*$/, fn ->
        %Events.PageView{page_url: nil}
        |> Events.PageView.validate()
      end

      assert_raise Errors.InvalidParam, ~r/^.*page_url cannot be blank.*$/, fn ->
        %Events.PageView{page_url: ""}
        |> Events.PageView.validate()
      end
    end

    test "returns event if it is valid", context do
      event = context[:event]
      assert event == Events.PageView.validate(event)
    end
  end

  describe "get/1" do
    test "returns payload object with valid attributes", context do
      expected_response = %{
        "e" => "pv",
        "url" => "test.com",
        "page" => nil,
        "refr" => nil
      }

      response =
        Events.PageView.get(context[:event])
        |> Payload.get()

      assert response["e"] == expected_response["e"]
      assert response["url"] == expected_response["url"]
      assert response["page"] == expected_response["page"]
      assert response["refr"] == expected_response["refr"]
    end
  end
end
