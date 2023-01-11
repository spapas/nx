defmodule Nx.Defn.Einsum.Index do
  @moduledoc false
  # Provides a struct that indexes a given dimension inside the
  # Nx.Defn.einsum context.

  # An Index can be:
  # %Index{type: :batch, name: reference(), axis: non_neg_integer()} -> indicates a batch axis.
  # %Index{type: :contract, name: reference(), axis: non_neg_integer()} -> indicates a contraction axis.
  # %Index{type: :noop, name: nil, axis: non_neg_integer()} -> can be used to leave an axis when indexing (i.e. it'll neither be batched nor contracted)

  defstruct [:type, :name, :axis]

  def batch, do: %__MODULE__{type: :batch, name: make_ref()}
  def contract, do: %__MODULE__{type: :contract, name: make_ref()}
  def noop, do: %__MODULE__{type: :noop, name: make_ref()}
end
