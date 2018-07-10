defmodule SnowplowTracker.EmitterTest do
  use ExUnit.Case

  import Mock

  alias SnowplowTracker.{Errors, Request, Payload, Emitter, RequestMock}

  defmacro with_request_mock(block) do
    quote do
      with_mock Request, get: fn (url, opts) -> RequestMock.get(url, opts) end do
        unquote(block)
      end
    end
  end

  setup_all do
    {:ok, emitter: %Emitter{}}
  end

  describe "new/1" do
    test "returns emitter with specified url for collector" do
      url = "localhost"
      emitter = Emitter.new("localhost")
      assert is_map(emitter)
      assert url, Map.get(emitter, :collector_uri)
    end
  end

  describe "input/2" do
    test "sends a GET request to the collector with the parameters", context do
      with_request_mock do
        Payload.add(%Payload{}, :test, "value")
        |> Emitter.input(context[:emitter])

        assert_receive "request sent"
      end
    end

    test "fails if the collector is not reachable", context do
      payload = Payload.add(%Payload{}, :test, "value")

      assert_raise Errors.ApiError, fn ->
        Emitter.input(payload, context[:emitter])
      end
    end
  end
end
