defmodule Geom do

  @spec area(atom(), number(), number()) :: number()

  def area(shape, a, b//1) when a >= 0 and b >= 0 do
    case shape do
      :triangle -> a * b / 2
      :rectangle -> a * b
      :ellipse -> :math.pi() * a * b
      _ -> 'you done fucked up'
    end
  end

end
