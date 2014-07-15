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

  def put(key, value) do
    GenServer.call(:factory_girl, {:put, {key, value}})
  end

  def get(key) do
    GenServer.call(:factory_girl, {:get, key})
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
    {counters1, reply} = expand_functions(attributes, counters)

    new_state = Keyword.put(state, :counters, Keyword.put(state[:counters], factory, counters1))
    {:reply, reply, new_state}
  end

  defp expand_functions(attrs, counters) do
    expand_functions(attrs, counters, [])
  end

  defp expand_functions([], counters, acc), do: {counters, acc}
  defp expand_functions([{attr, fun}|tail], counters, acc)
  when is_function(fun) do
    seq_next = (Keyword.get(counters, attr) || 0) + 1
    counters1 = Keyword.put(counters, attr, seq_next)
    expand_functions(tail, counters1, [{attr, fun.(seq_next)}|acc])
  end
  defp expand_functions([{_k, _v} = h|t], counters, acc) do
    expand_functions(t, counters, [h|acc])
  end
end
