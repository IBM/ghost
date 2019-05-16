defmodule Ghost.Queue do
  @doc """
  The `produce_sync/5` function will add a value to the topic and partition syncronously.
  """
  @callback produce_sync(
              atom() | pid(),
              String.t(),
              (String.t(), integer(), binary(), binary() -> {:ok, integer()}),
              binary(),
              binary()
            ) :: {:ok, integer()} | {:error, any()}

  @doc """
  Same as `produce_sync/4`, but uses a predefined partition selection function.
  """
  @callback produce_sync(atom() | pid(), String.t(), binary(), binary()) :: {:ok, integer()} | {:error, any()}

  @doc """
  This is an asyncrounous produce to the queue. This function will send a message to the caller
  of a format specified by the specific implenation of `Queue`.
  """
  @callback produce(
              atom() | pid(),
              String.t(),
              (String.t(), integer(), binary(), binary() -> {:ok, integer()}),
              binary(),
              binary()
            ) :: {:ok, any()} | {:error, any()}

  @doc """
  Same as `produce/5`, but uses a predefined partition selection function.
  """
  @callback produce(
              atom() | pid(),
              String.t(),
              binary(),
              binary()
            ) :: {:ok, any()} | {:error, any()}

  @doc """
  Returns a list of messages produced by a pid to a topic in the order that they were produced in.
  """
  @callback fetch(pid(), String.t()) :: [binary()]
end
