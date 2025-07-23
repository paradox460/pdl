# Pdl

Pdl is a rather simple set of tools that enables something similar to the "dataloader" pattern, using Erlang process dictionaries.

In short, you can use it to batch up actions across a process (i.e. a single Phoenix request) and resolve them later (towards the end of the process)

This toolset is relatively minimal, leaving most of the implementation details up to the user.

## Installation

This package can be installed
by adding `pdl` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pdl, "~> 0.1.1"}
  ]
end
```

## Basic Usage

```elixir

# Somewhere in your process, where you want to add things to a batch

Pdl.add(:posts, post.id)
# => :ok

# Later, i.e. right before the end of the request

Pdl.run_all(:posts, fn post_ids ->
  Posts.get_many(post_ids)
end)
# => result of `Posts.get_many(post_ids)`

```

Documentation can be found at <https://hexdocs.pm/pdl>.
