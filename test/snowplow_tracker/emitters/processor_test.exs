defmodule SnowplowTracker.ProcessorTest do
  use ExUnit.Case

  import Mock

  alias SnowplowTracker.Emitters.{Processor, Cache}
  alias SnowplowTracker.{Payload, Request, RequestMock}

  @table :snowplow_test_events

  setup do
    payload = Payload.add(%Payload{}, "eid", "test")
    {:ok, payload: payload}
  end

  defmacro with_request_mock_post(block) do
    quote do
      with_mock Request,
        post: fn url, body, headers, opts -> RequestMock.post(url, body, headers, opts) end do
        unquote(block)
      end
    end
  end

  describe "send/0" do
    test "sends POST request with the data in the ETS table", context do
      with_request_mock_post do
        Cache.init(@table)
        :ets.insert(@table, {"eid", context[:payload], "test.com"})
        response = Processor.send(@table)
        assert response == {:ok, :success}
        assert_receive "POST request sent"
        Cache.delete_table(@table)
      end
    end
  end
end
