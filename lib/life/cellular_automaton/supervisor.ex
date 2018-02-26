defmodule Life.CellularAutomaton.Supervisor do
  use Supervisor

  alias Life.CellularAutomaton.State

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      State
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
