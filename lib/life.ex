defmodule Life do
  @moduledoc """
  Life keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Life.CellularAutomaton
  alias Life.Cell

  def calculate(current_state, timeout \\ 1000) do
    CellularAutomaton.reset()
    calculate(0, Enum.count(current_state), current_state, timeout)
  end

  def calculate(count, count, current_state, timeout) do
    next_state = CellularAutomaton.get_state()
    IO.inspect(next_state)
    if state_changed?(current_state, next_state) do
      Process.sleep(timeout)
      calculate(next_state, timeout)
    else
      current_state
    end
  end

  def calculate(number_processed, count, current_state, timeout) do
    {item, _} = List.pop_at(current_state, number_processed)
    process_with_neighbours(item, current_state)
    calculate(number_processed + 1, count, current_state, timeout)
  end


  def process_with_neighbours(item, field) do
    item
    |> Cell.get_all_neighbours(field)
    |> List.insert_at(-1, item)
    |> Enum.each(&process(&1, field))
  end

  defp process({coords, %Cell{age: age} = cell} = item, field) do
    if Cell.alive?(item, field) do
      CellularAutomaton.add({coords, %{cell | age: age + 1}})
    end
  end

  defp process({coords, nil} = item, field) do
    if Cell.alive?(item, field) do
      CellularAutomaton.add({coords, %Cell{age: 0}})
    end
  end

  defp state_changed?([], []), do: false
  defp state_changed?([], _), do: true
  defp state_changed?(_, []), do: true
  defp state_changed?([{coords, _} | tl], next_state) do
    next_state =
      if List.keymember?(next_state, coords, 0) do
        List.keydelete(next_state, coords, 0)
      else
        next_state
      end
    state_changed?(tl, next_state)
  end
end
