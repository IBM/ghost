defmodule Ghost.VirtualQueue do
  @behaviour Ghost.Queue
  import Ghost.Kafka.Brod

  @impl true
  def produce_sync(client, topic, key, message) do
    produce_sync(client, topic, nil, key, message)
  end

  @impl true
  def produce_sync(_client, topic, _partition_selection_function, _key, message) do
    queue = get_agent(topic)
    put_message_in_queue(queue, message)
    {:ok, :erlang.unique_integer([:monotonic, :positive])}
  end

  @impl true
  def produce(client, topic, key, message) do
    produce(client, topic, nil, key, message)
  end

  @impl true
  def produce(_client, topic, _partition_selection_function, _key, message) do
    queue = get_agent(topic)
    put_message_in_queue(queue, message)

    queue_length = fetch(queue, topic) |> Enum.count()

    caller_ref = brod_call_ref(caller: self(), callee: queue, ref: make_ref())

    send(
      self(),
      brod_produce_reply(
        call_ref: caller_ref,
        base_offset: queue_length,
        result: :brod_produce_req_acked
      )
    )

    {:ok, caller_ref}
  end

  @impl true
  def fetch(pid, topic) do
    case :global.whereis_name({pid, topic}) do
      :undefined ->
        []

      agent_pid ->
        Agent.get(agent_pid, fn queue -> :queue.to_list(queue) end)
    end
  end

  def get_agent(topic) do
    case :global.whereis_name({self(), topic}) do
      :undefined ->
        {:ok, pid} = Agent.start_link(fn -> :queue.new() end, name: {:global, {self(), topic}})
        pid

      pid ->
        pid
    end
  end

  defp put_message_in_queue(pid, message) do
    Agent.update(pid, fn queue -> :queue.in(message, queue) end)
  end
end
