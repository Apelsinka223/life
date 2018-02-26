defmodule Life.CellularAutomaton do
  use GenServer

  alias Life.Cell

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: NextState)
  end

  def reset do
    GenServer.cast(NextState, :reset_state)
  end

  def get_state do
    GenServer.call(NextState, :get_state)
  end

  def init(state) do
    {:ok, state}
  end

  def add(item) do
    GenServer.cast(NextState, {:add, item})
  end

  def handle_cast(:reset_state, _) do
    {:noreply, []}
  end

  def handle_cast({:add, {coords, %Cell{}} = item}, next_state) do
    next_state =
      if not List.keymember?(next_state, coords, 0) do
        [item | next_state]
      else
        next_state
      end

    {:noreply, next_state}
  end

  def handle_call(:get_state, _from,  next_state) do
    {:reply, next_state, next_state}
  end
end