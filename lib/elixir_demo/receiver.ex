defmodule ElixirDemo.Receiver do
  use GenServer

  def init(receiver_id) do
   {:ok, receiver_id}
  end

  def start_link(receiver_id) do
    IO.puts("Starting receiver #{receiver_id}")
    GenServer.start_link(__MODULE__, receiver_id, name: via_tuple(receiver_id))
  end

  def process(receiver_id, message) do
    GenServer.cast(via_tuple(receiver_id), {:put, message})
  end

  def handle_cast({:put, message}, receiver_id) do
    IO.puts("Receiver #{receiver_id} got #{message}")
    {:noreply, receiver_id}
  end

  defp via_tuple(receiver_id) do
    ElixirDemo.Registry.via_tuple({__MODULE__, receiver_id})
  end
end
