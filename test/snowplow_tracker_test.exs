defmodule SnowplowTrackerTest do
  use ExUnit.Case

  import Mock

  alias SnowplowTracker.{
    Request,
    Tracker,
    Events,
    SelfDescribingJson,
    RequestMock
  }

  defmacro with_request_mock(block) do
    quote do
      with_mock Request, get: fn url, headers, opts -> RequestMock.get(url, headers, opts) end do
        unquote(block)
      end
    end
  end

  setup_all do
    {:ok, tracker: %Tracker{}}
  end

  describe "track_page_view/1" do
    test "checks if the validate and get methods are called", context do
      payload = Events.PageView.new(%{page_url: "test.com"})

      with_request_mock do
        SnowplowTracker.track_page_view(
          payload,
          context[:tracker],
          Events.EventMock
        )

        assert_received {:ok, "validated"}
        assert_received {:ok, "successful"}
      end
    end
  end

  describe "track_structured_event/1" do
    test "checks if the validate and get methods are called", context do
      payload = Events.Structured.new(%{category: "pv", action: "click"})

      with_request_mock do
        SnowplowTracker.track_struct_event(
          payload,
          context[:tracker],
          Events.EventMock
        )

        assert_received {:ok, "validated"}
        assert_received {:ok, "successful"}
      end
    end
  end

  describe "track_self_describing_event/1" do
    test "checks if the validate and get methods are called", context do
      payload = Events.SelfDescribing.new(%{event: %SelfDescribingJson{}})

      with_request_mock do
        SnowplowTracker.track_self_describing_event(
          payload,
          context[:tracker],
          Events.EventMock
        )

        assert_received {:ok, "validated"}
        assert_received {:ok, "successful"}
      end
    end
  end

  describe "track_screen_view/1" do
    test "checks if the validate and get methods are called", context do
      payload = Events.ScreenView.new(%{})

      with_request_mock do
        SnowplowTracker.track_screen_view(
          payload,
          context[:tracker],
          Events.EventMock
        )

        assert_received {:ok, "validated"}
        assert_received {:ok, "successful"}
      end
    end
  end

  describe "track_timing/1" do
    test "checks if the validate and get methods are called", context do
      payload = Events.Timing.new(%{category: "pv", variable: "click", timing: 10})

      with_request_mock do
        SnowplowTracker.track_timing(
          payload,
          context[:tracker],
          Events.EventMock
        )

        assert_received {:ok, "validated"}
        assert_received {:ok, "successful"}
      end
    end
  end

  describe "track_ecommerce_transaction/1" do
    test "checks if the validate and get methods are called", context do
      payload = Events.EcommerceTransaction.new(%{order_id: "1E501", total_value: 300.0})

      with_request_mock do
        SnowplowTracker.track_ecommerce_transaction(
          payload,
          context[:tracker],
          Events.EventMock
        )

        assert_received {:ok, "validated"}
        assert_received {:ok, "successful"}
      end
    end
  end

  describe "track_ecommerce_transaction_item/1" do
    test "checks if the validate and get methods are called", context do
      payload = Events.EcommerceTransactionItem.new(%{sku: "phone", price: 300.0, quantity: 1})

      with_request_mock do
        SnowplowTracker.track_ecommerce_transaction_item(
          payload,
          context[:tracker],
          Events.EventMock
        )

        assert_received {:ok, "validated"}
        assert_received {:ok, "successful"}
      end
    end
  end
end
