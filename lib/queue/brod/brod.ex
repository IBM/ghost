defmodule Ghost.Kafka.Brod do
  import Record

  defrecord :brod_call_ref, extract(:brod_call_ref, from_lib: "brod/include/brod.hrl")
  defrecord :brod_produce_reply, extract(:brod_produce_reply, from_lib: "brod/include/brod.hrl")
end
