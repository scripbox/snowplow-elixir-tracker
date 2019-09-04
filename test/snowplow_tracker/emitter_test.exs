defmodule SnowplowTracker.EmitterTest do
  use ExUnit.Case

  import Mock

  alias SnowplowTracker.{Errors, Request, Payload, Emitter, RequestMock}
  alias SnowplowTracker.Emitters.Server

  defmacro with_request_mock_get(block) do
    quote do
      with_mock Request, get: fn url, headers, opts -> RequestMock.get(url, headers, opts) end do
        unquote(block)
      end
    end
  end

  defmacro with_request_mock_post(block) do
    quote do
      with_mock Request, post: fn url, headers, opts -> RequestMock.post(url, headers, opts) end do
        unquote(block)
      end
    end
  end

  setup_all do
    start_supervised(Server)

    {
      :ok,
      emitter: %Emitter{}
    }
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
      with_request_mock_get do
        Payload.add(%Payload{}, :test, "value")
        |> Emitter.input(context[:emitter])

        assert_receive "GET request sent"
      end
    end

    test "fails if the collector is not reachable", context do
      payload = Payload.add(%Payload{}, :test, "value")

      assert_raise Errors.ApiError, fn ->
        Emitter.input(payload, context[:emitter])
      end
    end

    test "sends a POST request to the collector with the parameters", context do
      with_request_mock_post do
        emitter = Map.put(context[:emitter], :request_type, "POST")

        response =
          %Payload{}
          |> Payload.add("eid", "value")
          |> Emitter.input(emitter)

        assert response == {:ok, :success}
      end
    end
  end
end
