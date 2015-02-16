defmodule KV.Bucket do

  def start_link do
    #IO.puts "Bucket process, #{inspect self}"
    Agent.start_link(fn -> HashDict.new end)
  end

  def delete(bucket, key) do
    bucket
    |> Agent.get_and_update(fn (dict) ->
      #IO.puts "in the agent process, #{inspect self}"
      HashDict.pop(dict, key)
    end)
  end

  def get(bucket, key) do
    bucket
    |> Agent.get(&HashDict.get(&1, key))
  end

  def put(bucket, key, value) do
    bucket
    |> Agent.update(&HashDict.put(&1, key, value))
  end

end
