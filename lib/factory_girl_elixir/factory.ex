defmodule FactoryGirlElixir.Factory do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)

      def attributes_for(field) do
        FactoryGirlElixir.Worker.get(field)
      end
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
