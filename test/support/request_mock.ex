defmodule SnowplowTracker.RequestMock do
  require HTTPoison

  def get(_url, _headers, _options) do
    send(self(), "request sent")
    {:ok, %HTTPoison.Response{status_code: 200, body: "response"}}
  end
end
