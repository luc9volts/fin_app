# FinApp

Creates bank accounts and enables funds transfer between them.

## Design/Architecture

Event Sourcing and CQRS

## Prerequisites

- Elixir 1.8.1
- psql (PostgreSQL) 9.5.16

## Setup

Resolving project dependencies:

    $ mix do deps.get, compile

Create and initialize the event store:

    $ mix do event_store.create, event_store.init

## Running

    $ cd apps/web
    $ mix run --no-halt

## Tests

    $ cd apps/accounts/
    $ mix test test/accounts_test.exs

## Features

###_"New account" :_

    POST /create HTTP/1.1
    Host: localhost:4004
    Content-Type: application/json
    Cache-Control: no-cache
    {
        "account_number":"acc001"
    }

###_"Send funds" :_

    POST /send HTTP/1.1
    Host: localhost:4004
    Content-Type: application/json
    Cache-Control: no-cache
    {
        "debit_account":"acc001",
        "credit_account":"acc002",
        "amount":999
    }

###_"Withdraw" :_

    POST /withdraw HTTP/1.1
    Host: localhost:4004
    Content-Type: application/json
    Cache-Control: no-cache
    {
        "account_number":"acc001",
        "amount":100
    }