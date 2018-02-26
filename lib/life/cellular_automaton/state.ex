defmodule Life.CellularAutomaton.State do
  use GenServer

  require Logger

  alias Life.CellularAutomaton.Cell

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def init(args) do
    {:ok, args}
  end

  def stop(pid) do
    Logger.info("stop")
    GenServer.stop(pid)
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def add(pid, item) do
    GenServer.cast(pid, {:add, item})
  end

  def handle_cast({:add, {coords, %Cell{} = cell}}, next_state) do
    next_state =
      if is_nil(next_state[coords]) do
        Map.put(next_state, coords,  cell)
      else
        next_state
      end
    {:noreply, next_state}
  end

  def handle_call(:get_state, _from,  next_state) do
    {:reply, next_state, next_state}
  end
end