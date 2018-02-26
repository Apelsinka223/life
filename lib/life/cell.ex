defmodule Life.Cell do
  alias __MODULE__

  defstruct [:age]

  def get_all_neighbours({{x, y}, _cell}, field) do
    neighbours =
      Enum.map(x - 1 .. x + 1, fn (field_x) ->
        Enum.map(y - 1 .. y + 1, fn (field_y) ->
          if field_x != x or field_y != y do
            item = List.keyfind(field, {field_x, field_y}, 0)
            if not is_nil(item) do
              item
            else
              {{field_x, field_y}, nil}
            end
          else
            []
          end
        end)
      end)

    List.flatten(neighbours)
  end

  def get_alive_neighbours({{x, y}, _cell}, field) do
    neighbours =
      Enum.map(x - 1 .. x + 1, fn (field_x) ->
        Enum.map(y - 1 .. y + 1, fn (field_y) ->
          if field_x != x or field_y != y do
            item = List.keyfind(field, {field_x, field_y}, 0)
            if not is_nil(item) do
              item
            else
              []
            end
          else
            []
          end
        end)
      end)

    List.flatten(neighbours)
  end

  def alive?({_, %Cell{}} = item, field) do
    (item |> get_alive_neighbours(field) |> Enum.count())  in [2, 3]
  end

  def alive?(item, field) do
    (item |> get_alive_neighbours(field) |> Enum.count()) == 3
  end
end