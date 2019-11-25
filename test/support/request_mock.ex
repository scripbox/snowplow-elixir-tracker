defmodule SnowplowTracker.RequestMock do
  require HTTPoison

  def get(_url, _headers, _options) do
    send(self(), "GET request sent")
    {:ok, %HTTPoison.Response{status_code: 200, body: "response"}}
  end

  def post(_url, _body, _headers, _options) do
    send(self(), "POST request sent")
    {:ok, %HTTPoison.Response{status_code: 200, body: "response"}}
  end
end
