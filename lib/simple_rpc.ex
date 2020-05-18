defmodule SimpleRpc do
  @moduledoc """
  Documentation for `SimpleRpc`.
  """

  @type command :: String.t()
  @type params :: map
  @type result :: map
  @type error_code :: atom | String.t()
  @type error_message :: String.t()
  @type error :: {error_code, error_message}
end
