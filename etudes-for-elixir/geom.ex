defmodule Geom do

  @spec area(atom(), number(), number()) :: number()

  def area(:rectangle, a, b) when a >= 0 and b >= 0 do
    a * b
  end

  def area(:triangle, a, b) when a >= 0 and b >= 0 do
    a * b / 2
  end

  def area(:ellipse, a, b) when a >= 0 and b >= 0 do
    :math.pi * a * b
  end

  def area(_atom, _a, _b), do: 0

end
