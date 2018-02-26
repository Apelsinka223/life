defmodule Life.CellularAutomaton.Cell do
  alias __MODULE__

  defstruct [:age]

  def get_all_neighbours({{x, y}, _cell}, field) do
    neighbours = map_neighbours({x, y}, fn(field_x, field_y) ->
      item = field[{field_x, field_y}]

      if not is_nil(item) do
        {{field_x, field_y}, item}
      else
        {{field_x, field_y}, nil}
      end
    end)

    List.flatten(neighbours)
  end

  def get_alive_neighbours({{x, y}, _cell}, field) do
    neighbours = map_neighbours({x, y}, fn(field_x, field_y) ->
      item = field[{field_x, field_y}]

      if not is_nil(item) do
        {{field_x, field_y}, item}
      else
        []
      end
    end)

    List.flatten(neighbours)
  end

  def map_neighbours({x, y}, fun) do
    Enum.map(x - 1 .. x + 1, fn (field_x) ->
      Enum.map(y - 1 .. y + 1, fn (field_y) ->
        if {x, y} != {field_x, field_y} do
          fun.(field_x, field_y)
        else
          []
        end
      end)
    end)
  end

  def alive?({_, %Cell{}} = item, field) do
    (item |> get_alive_neighbours(field) |> Enum.count())  in [2, 3]
  end

  def alive?(item, field) do
    (item |> get_alive_neighbours(field) |> Enum.count()) == 3
  end

  def to_state(first_generation) do
    to_state(first_generation, %{})
  end

  def to_state([], state) do
    state
  end

  def to_state([coords | tl], state) do
    to_state(tl, Map.put(state, coords, %Cell{age: 0}))
  end
end