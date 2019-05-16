defmodule Ghost do
  @config Application.get_env(:ghost, __MODULE__)

  def produce_sync(topic, key, message) do
    client  = Keyword.get(@config, :client)
    adapter = Keyword.get(@config, :adapter)
    adapter.produce_sync(client, topic, key, message)
  end

  def produce(topic, key, message) do
    client  = Keyword.get(@config, :client)
    adapter = Keyword.get(@config, :adapter)
    adapter.produce(client, topic, key, message)
  end
end
