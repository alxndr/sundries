defmodule Geom do

  def area(shape, a, b//1) do
    case shape do
      :triangle -> a * b / 2
      :rectangle -> a * b
      :ellipse -> :math.pi() * a * b
      _ -> 'you done fucked up'
    end
  end

end
