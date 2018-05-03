defmodule SnowplowTracker.Helper do
  @moduledoc """
  Module containing helper function for SnowplowTracker
  """

  alias SnowplowTracker.{Payload, Constants, SelfDescribingJson}

  defp add_standard_pairs(payload, tracker) do
    %{
      Constants.t_version() => Constants.tracker_version(),
      Constants.platform() => tracker.platform,
      Constants.app_id() => tracker.app_id,
      Constants.namespace() => tracker.namespace
    }
    |> (&Payload.add_map(payload, &1)).()
  end

  defp add_subject_pairs(payload, subject) do
    subject.payload
    |> Payload.get()
    |> (&Payload.add_map(payload, &1)).()
  end

  defp add_contexts(payload, contexts, _) when length(contexts) == 0 do
    payload
  end

  defp add_contexts(payload, contexts, encode) do
    json_contexts = for context <- contexts, do: SelfDescribingJson.get(context)

    sdj = %SelfDescribingJson{
      schema: Constants.schema_contexts(),
      data: json_contexts
    }

    Payload.add_json(
      payload,
      SelfDescribingJson.get(sdj),
      Constants.context_encoded(),
      Constants.context(),
      encode
    )
  end

  def add_data(payload, tracker, contexts) do
    payload
    |> add_standard_pairs(tracker)
    |> add_subject_pairs(tracker.subject)
    |> add_contexts(contexts, tracker.base64_encode)
  end
end
