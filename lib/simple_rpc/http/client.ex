defmodule SimpleRpc.Http.Client do
  @moduledoc """
  Behaviour to call SimpleRpc over HTTP.
  """

  @type context :: any
  @type options :: keyword()

  @callback call(context, command :: SimpleRpc.command(), params :: SimpleRpc.params(), options) ::
              {:ok, SimpleRpc.result()}
              | {:error, [SimpleRpc.error()] | {:invalid_response, term} | term}
end

if Code.ensure_loaded?(Tesla) do
  defmodule SimpleRpc.Http.Client.Tesla do
    @moduledoc """
    SimpleRPC over HTTP with `Tesla`.
    """

    @behaviour SimpleRpc.Http.Client

    def build(url, headers \\ [], adapter \\ nil) do
      Tesla.client(
        [
          {Tesla.Middleware.BaseUrl, url},
          Tesla.Middleware.JSON,
          {Tesla.Middleware.Headers, headers}
        ],
        adapter
      )
    end

    @impl SimpleRpc.Http.Client
    def call(client, command, params, opts) do
      case Tesla.post(client, command, params, opts) do
        {:ok, %{status: 200, body: %{"result" => result}}} -> {:ok, result}
        {:ok, %{status: 400, body: %{"errors" => errors}}} -> {:error, errors}
        {:ok, %{status: 500, body: %{"errors" => errors}}} -> {:error, errors}
        {:ok, %{status: _, body: body}} -> {:error, {:invalid_response, body}}
        {:error, error} -> {:error, error}
      end
    end
  end
end
