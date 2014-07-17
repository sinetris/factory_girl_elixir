defmodule FactoryGirlElixir.Worker do
  use GenServer

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, [name: :factory_girl])
  end

  ## Server callbacks
  def init(_options) do
    state = [counters: [], attributes: []]
    {:ok, state}
  end

  def put(factory, attribute) do
    GenServer.call(:factory_girl, {:put, {factory, attribute}})
  end

  def get(factory) do
    GenServer.call(:factory_girl, {:get, factory})
  end

  def reset do
    GenServer.call(:factory_girl, :reset)
  end

  def handle_call(:reset, _from, state) do
    attributes = state[:attributes] || []

    new_state = [counters: [], attributes: attributes]
    {:reply, :ok, new_state}
  end

  def handle_call({:put, {factory, assign}}, _from, state) do
    attributes = Keyword.get(state[:attributes], factory) || []

    new_state = Keyword.put(state, :attributes, Keyword.put(state[:attributes], factory, [assign|attributes]))
    {:reply, :ok, new_state}
  end

  def handle_call({:get, factory}, _from, state) do
    attributes = Keyword.get(state[:attributes], factory) || []

    counters = state[:counters][factory] || []
    {counters, reply} = expand_functions(attributes, counters)

    new_state = Keyword.put(state, :counters, Keyword.put(state[:counters], factory, counters))
    {:reply, reply, new_state}
  end

  defp expand_functions(attributes, counters) do
    expand_functions(attributes, counters, %{})
  end

  defp expand_functions([], counters, acc), do: {counters, acc}
  defp expand_functions([{key, val}|tail], counters, acc)
  when is_function(val) do
    seq_next = (Keyword.get(counters, key) || 0) + 1
    counters = Keyword.put(counters, key, seq_next)
    acc = Dict.put(acc, key, val.(seq_next))
    expand_functions(tail, counters, acc)
  end
  defp expand_functions([{key, val}|tail], counters, acc) do
    acc = Dict.put(acc, key, val)
    expand_functions(tail, counters, acc)
  end
end
