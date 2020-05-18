if Code.ensure_loaded?(Plug) do
  defmodule SimpleRpc.Http.Plug do
    @moduledoc """
    Plug to serve SimpleRpc.
    """

    @behaviour Plug

    @default_client_error_codes [
      :bad_request,
      :unauthorized,
      :forbidden,
      :not_found,
      :not_acceptable,
      :conflict,
      :gone,
      :unprocessable_entity
    ]
    @default_server_error_codes [:internal_error, :not_implemented, :service_unavailable]

    alias Plug.Conn

    def init(opts) do
      %{
        handler: Keyword.fetch!(opts, :handler),
        client_error_codes:
          opts |> Keyword.get(:client_error_codes, @default_client_error_codes) |> MapSet.new(),
        server_error_codes:
          opts |> Keyword.get(:server_error_codes, @default_server_error_codes) |> MapSet.new()
      }
    end

    def call(%Conn{path_info: [command]} = conn, opts) do
      %{
        handler: handler,
        client_error_codes: client_error_codes,
        server_error_codes: server_error_codes
      } = opts

      %Conn{body_params: params} = conn

      case apply(handler, :handle_message, [command, params]) do
        {:ok, result} ->
          conn |> send_json_resp(200, format_ok(result))

        {:error, {error_code, error_message}} ->
          http_status =
            cond do
              MapSet.member?(client_error_codes, error_code) -> 400
              MapSet.member?(server_error_codes, error_code) -> 500
              true -> 400
            end

          conn |> send_json_resp(http_status, format_error(error_code, error_message))
      end
    end

    def call(%Conn{path_info: _} = conn, _) do
      conn |> send_json_resp(500, format_error(:bad_request, "Bad RPC request"))
    end

    defp format_ok(result), do: %{result: result}

    defp format_error(error_code, error_message),
      do: %{errors: [%{code: error_code, message: error_message}]}

    defp send_json_resp(conn, status_code, body) do
      conn
      |> Conn.put_resp_header("content-type", "application/json; charset=utf-8")
      |> Conn.send_resp(status_code, Jason.encode!(body))
    end
  end
end
