defmodule Nx.Defn.Einsum do
  @moduledoc false

  alias Nx.Defn.Einsum.Index

  def fetch(_tensor, %Index{type: :noop}) do
    raise ArgumentError,
          "Einsum noop indices are not allowed in cascading indices. Use [[..., noop, ...]] notation instead."
  end

  def fetch(tensor, %Index{} = index) do
    # Clause for indexing the first available dimension

    first_available_axis =
      Enum.find_index(tensor.names, fn name -> not is_struct(name, Index) end)

    if first_available_axis do
      {:ok,
       %{
         tensor
         | names:
             List.replace_at(tensor.names, first_available_axis, %{
               index
               | axis: first_available_axis
             })
       }}
    else
      raise ArgumentError, "no available axis found for Einsum-indexing"
    end
  end

  def fetch(tensor, [%Index{} | _] = indices) do
    # Clause for indexing all dimensions at once.

    rank = tuple_size(tensor.shape)
    num_indices = length(indices)

    if num_indices != rank do
      raise ArgumentError, "Expected #{rank} Einsum-indices, got: #{num_indices}"
    else
      {:ok,
       %{
         tensor
         | names:
             Enum.with_index(indices, fn
               %Index{type: :noop}, _ -> nil
               index, axis -> %{index | axis: axis}
             end)
       }}
    end
  end

  def contract_axes(n) when n >= 1, do: Enum.map(1..n//1, fn _ -> Index.contract() end)
  def batch_axes(n) when n >= 1, do: Enum.map(1..n//1, fn _ -> Index.batch() end)
  defdelegate noop, to: Index
end
