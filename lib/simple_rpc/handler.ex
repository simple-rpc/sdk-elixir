defmodule SimpleRpc.Handler do
  @moduledoc """
  Behaviour to implement the server.
  """

  @doc """
  Handles SimpleRpc commmand and params.
  """
  @callback handle_message(command :: SimpleRpc.command(), params :: SimpleRpc.params()) ::
              {:ok, SimpleRpc.result()}
              | {:error, SimpleRpc.error()}

  def handle_unknown_message,
    do: {:error, {:bad_request, "command and params are not recognized"}}
end
