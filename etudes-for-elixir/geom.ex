defmodule Geom do

  @spec area(atom(), number(), number()) :: number()

  def area(tuple) do
    { atom, a, b } = tuple
    area(atom, a, b)
  end

  defp area(:rectangle, a, b) when a >= 0 and b >= 0 do
    a * b
  end

  defp area(:triangle, a, b) when a >= 0 and b >= 0 do
    a * b / 2
  end

  defp area(:ellipse, a, b) when a >= 0 and b >= 0 do
    :math.pi * a * b
  end

  defp area(_atom, _a, _b), do: 0

end
