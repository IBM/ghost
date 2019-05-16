defmodule Ghost.Kafka do
  @behaviour Ghost.Queue

  @impl true
  def produce(client, topic, partition_selection_function, key, message) do
    :brod.produce(
      client,
      topic,
      partition_selection_function,
      key,
      message
    )
  end

  @impl true
  def produce(client, topic, key, message) do
    :brod.produce(
      client,
      topic,
      &partition_selection_function/4,
      key,
      message
    )
  end

  @impl true
  def produce_sync(client, topic, partition_selection_function, key, message) do
    :brod.produce_sync(
      client,
      topic,
      partition_selection_function,
      key,
      message
    )
  end

  @impl true
  def produce_sync(client, topic, key, message) do
    :brod.produce_sync(
      client,
      topic,
      &partition_selection_function/4,
      key,
      message
    )
  end

  @spec partition_selection_function(String.t(), integer(), binary(), binary()) ::
          {:ok, integer()}
  def partition_selection_function(_topic, partition_count, key, _value) do
    {:ok, :erlang.phash2(key, partition_count)}
  end

  @impl true
  def fetch(_, _) do
    raise "Fetch is not supported in the Kafka Adapter"
  end
end
