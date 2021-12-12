defmodule SearchParser do
  @moduledoc """
  Documentation for `SearchParser`.
  """

  def parse!(s) do
    SearchParser.Language.parse(s)
    |> elem(1)
  end 
end
