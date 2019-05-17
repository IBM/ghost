# 👻Ghost

## Installation

If [available in Hex](https://hexdocs.pm/ghost), the package can be installed
by adding `ghost` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ghost, "~> 0.1.0"},
    {:brod, "~> 3.7"}
  ]
end
```

## Introduction

At IBM many of our internal cloud services connect via a kafka based service bus. While this allows our developers to easily exchange information, it makes testing these services extremely difficult as Kafka is neither transactional nor synchronous. Your service may publish a message to kafka, but it can take an indeterminate amount of time to read that message back. Which is why we developed Ghost.

Ghost aims to offer the same kind testing as Ecto provides for databases via the `Ecto.Adapter.Sandbox`.

## How does it work?

