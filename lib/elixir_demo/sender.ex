defmodule ElixirDemo.Sender do
  use GenServer

  def start_link(_) do
    IO.puts("Starting sender")
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    ElixirDemo.ReceiverSupervisor.process(:os.system_time(:second))
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 2000)
  end
end
