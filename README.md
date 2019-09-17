# Elixir, Ecto and Database Transactions: Sample app

This is a companion app for our [How database transactions work in Ecto and why Elixir makes it awesome?](https://curiosum.dev/blog/elixir-ecto-database-transactions) article. The application has a `TransactApp.Bank` context with two schemas (`Account` associated with many `Activity` records). Included are a few scripts illustrating different ways to approach transactions in Elixir and Ecto, along with examples of organizing `Ecto.Multi` batches in modules.

## Prerequisities

Elixir and Erlang must be installed in your system. We recommend using the latest versions of both platforms. Check out [Elixir's website](https://elixir-lang.org/install.html) for tips on installation. We recommend using the awesome, cross-platform [asdf-vm](https://asdf-vm.com/) tool for installing and managing versions of Erlang and Elixir on your system.

As well as Elixir and Erlang, a PostgreSQL database is assumed to be installed.

## Installation

Copy `config/dev.exs.sample` to `config/dev.exs` and configure your database settings (see [Ecto docs](https://hexdocs.pm/ecto/Ecto.html) for more details). Then, execute:
```
mix deps.get
mix ecto.create
mix ecto.migrate
```
It's good to seed the database with some sample data:
```
mix run priv/repo/seeds.exs
```

## Usage

You can enter the Elixir shell in this app's context using:
```
iex -S mix
```
There are a few sample scripts in `priv/` that correspond to snippets from the [article](https://curiosum.dev/blog/elixir-ecto-database-transactions) - refer to the post for more details. They can be run similarly to the database seed script, albeit with `iex -S` so that it's possible to inspect results with `IEx.pry`:
```
iex -S mix run priv/script1.exs
iex -S mix run priv/script2.exs
iex -S mix run priv/script3.exs
iex -S mix run priv/script4.exs
```