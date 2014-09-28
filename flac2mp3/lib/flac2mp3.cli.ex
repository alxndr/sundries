defmodule Flac2mp3.CLI do

  def main(args) do
    args
    |> parse_args
    |> Flac2mp3.convert_dir
  end

  defp parse_args(args) do
    {config, _, _} = OptionParser.parse(args, strict: [dir: :string])
    cond do # ugh
      Keyword.has_key?(config, :help) -> help
      Keyword.has_key?(config, :dir)  -> Keyword.fetch!(config, :dir)
      true                            -> help
    end
  end

  defp help do
    IO.puts """
    usage: flac2mp3 --dir=<directory>

    optional flags:

    --help:    you're looking at it

    requirements (in $PATH):

    * `flac`
    * `lame` 
    """
    System.halt(0)
  end

end
