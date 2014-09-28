defmodule Flac2mp3.CLI do

  def main(args) do
    check_dependencies
    args
    |> OptionParser.parse(switches: [help: :boolean])
    |> process_args
    |> Flac2mp3.convert_dir
  end

  defp process_args(options_parsed) do
    # doesn't handle empty dir...
    case options_parsed do
      {[help: true], _, _} -> help
      {_, dir, _}          -> dir
    end
  end

  defp help do
    IO.puts """
    usage: flac2mp3 [dir]
    """
    System.halt(0)
  end

  defp check_dependencies do
    case System.cmd("which", ["flac"]) do
      {_, 0} -> true
      _ ->
        IO.puts "need flac in $PATH"
        System.halt(1)
      _ -> true
    end
    case System.cmd("which", ["lame"]) do
      {_, 0} -> true
      _ ->
        IO.puts "need lame in $PATH"
        System.halt(1)
    end
  end

end
