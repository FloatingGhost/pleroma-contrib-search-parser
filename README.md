# SearchParser

A little NimbleParsec language for pulling data out of a search query

```elixir
iex(1)> SearchParser.parse!("instance:myinstance.net search terms")
[{:filter, ["instance", "myinstance.net"]}, "search", "terms"]
```

Supports filters:
- instance
- user
- hashtag

Also supports quoting terms to group them - for example:

```elixir
iex(2)> SearchParser.parse!(~S("match this exactly"))              
[quoted: "match this exactly"]
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `search_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:search_parser, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/search_parser>.

