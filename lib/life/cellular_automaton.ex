defmodule Life.CellularAutomaton do
  @moduledoc false

  require Logger

  defmodule CellularAutomatonError do
    defexception [:message]
  end

  alias Life.CellularAutomaton.{State, Cell}

  def process(first_generation, timeout \\ 1000) do
    {:ok, pid} = State.start_link([])
    current_state = Cell.to_state(first_generation)
    spawn(fn -> do_process(pid, current_state, timeout) end)
    {:ok, pid}
  end

  def stop(pid), do: State.stop(pid)

  defp do_process(pid, current_state, timeout) do
    current_state
    |> Task.async_stream(fn(item) ->
      process_cell_with_neighbours(pid, item, current_state)
    end)
    |> Enum.each(fn
      {:ok, _} -> :ok
      {:error, reason} -> raise CellularAutomatonError, reason
    end)

    next_state = State.get_state(pid)
    Logger.info(inspect(next_state))

    if state_changed?(current_state, next_state) do
      Process.sleep(timeout)
      do_process(pid, next_state, timeout)
    else
      State.stop(pid)
    end
  end

  defp process_cell_with_neighbours(pid, item, current_state) do
    item
    |> Cell.get_all_neighbours(current_state)
    |> List.insert_at(-1, item)
    |> Enum.each(&process_cell(pid, &1, current_state))
  end

  defp process_cell(pid, {coords, %Cell{age: age} = cell} = item, field) do
    if Cell.alive?(item, field) do
      State.add(pid, {coords, %{cell | age: age + 1}})
    end
  end

  defp process_cell(pid, {coords, nil} = item, field) do
    if Cell.alive?(item, field) do
      State.add(pid, {coords, %Cell{age: 0}})
    end
  end

  defp state_changed?(current_state, next_state) do
    ((Map.keys(current_state) -- Map.keys(next_state)) ++
      (Map.keys(next_state) -- Map.keys(current_state))) != []
  end
end
