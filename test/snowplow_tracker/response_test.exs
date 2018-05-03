defmodule SnowplowTracker.ResponseTest do
  use ExUnit.Case

  alias HTTPoison.Response

  describe "parse/1" do
    test "returns the body if the response is successful" do
      body = "<html>Test</html>"
      response = %Response{status_code: 200, body: body}
      assert {:ok, response_body} = SnowplowTracker.Response.parse(response)
      assert response_body == body
    end

    test "returns error if the response is unsuccessful" do
      body = "<html>Failed Request</html>"
      response = %Response{status_code: 404, body: body}
      assert {:error, response_body} = SnowplowTracker.Response.parse(response)
      assert Regex.match?(~r/^404 - #{body}$/, response_body)
    end

    test "returns error if the response is invalid" do
      response = SnowplowTracker.Response.parse("failed_response")
      assert {:error, "Invalid response"} == response
    end
  end
end
