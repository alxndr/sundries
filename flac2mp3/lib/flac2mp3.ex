defmodule Flac2mp3 do

  # assumes you have flac and lame available via $PATH

  def convert_flac(flacfile) do
    IO.puts "starting on #{flacfile}"

    dirname = Path.dirname(flacfile)
    basename = Path.basename(flacfile, ".flac")
    wavfile = Path.join(dirname, "#{basename}.wav")
    mp3file = Path.join(dirname, "#{basename}.mp3")

    Task.async(fn ->
      System.cmd("flac", [ "--silent", "--force", "--decode", "--output-name", wavfile, flacfile], stderr_to_stdout: false)
    end)
    |> Task.await 10_000

    Task.async(fn ->
      System.cmd "lame", [ "--silent", "--abr", "320", wavfile, mp3file], stderr_to_stdout: false
    end)
    |> Task.await 30_000

    IO.puts "done: #{mp3file}"
    Task.async(fn ->
      System.cmd "rm", [wavfile]
    end) |>
    Task.await 1_000
  end

  def convert_dir(dir\\".") do
    check_dependencies
    Path.expand(dir) |>
    Path.join("**/*.flac") |>
    Path.wildcard |>
    Enum.each(&(convert_flac(&1)))
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

