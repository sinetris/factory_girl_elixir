defmodule FactoryGirlElixir.Factory do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)

      def attributes_for(factory, override_attributes \\ []) do
        FactoryGirlElixir.Worker.get(factory, override_attributes)
      end

      def parametrize(factory) do
        Enum.map(factory, &parametrized/1)
        |> Enum.into(%{})
      end

      defp parametrized({key, val})
      when is_atom(key) do
        {Atom.to_string(key), val}
      end
      defp parametrized(attr), do: attr
    end
  end

  defmacro field(name, value) do
    quote do
      factory = Module.get_attribute(__MODULE__, :factory)
      FactoryGirlElixir.Worker.put(factory, {unquote(name), unquote(value)})
    end
  end

  defmacro factory(name, opts \\ [], block)
  defmacro factory(name, _opts, [do: block]) do
    quote do
      @factory unquote(name)

      unquote(block)
    end
  end
end
