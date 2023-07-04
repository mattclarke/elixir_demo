defmodule ElixirDemo.ReceiverSupervisor do
  @pool_size 3

  def init(_) do
    {:ok, %{}}
  end

  def start_link do
    IO.puts("Starting receiver supervisor")
    children = Enum.map(1..@pool_size, &receiver_spec/1)
    Supervisor.start_link(children, strategy: :one_for_one, name: :receiver_supervisor)
  end

  defp receiver_spec(receiver_id) do
    default_spec = {ElixirDemo.Receiver, receiver_id}
    Supervisor.child_spec(default_spec, id: receiver_id)
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def process(message) do
    receiver = choose_receiver(message)
    ElixirDemo.Receiver.process(receiver, message)
  end

  defp choose_receiver(key) do
    :erlang.phash2(key, @pool_size) + 1
  end
end
