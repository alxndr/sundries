defmodule Flac2mp3 do

  # assumes you have flac and lame available via $PATH

  def convert_flac(flacfile) do
    IO.inspect "CONVERTING!"
    IO.inspect flacfile
    wavfile = String.replace(flacfile, ~r/\.flac$/, ".wav")
    mp3file = String.replace(flacfile, ~r/\.flac$/, ".mp3")
    convert_to_wav = Task.async(fn -> System.cmd("flac", ["-d", "-o", wavfile, flacfile]) end)
    Task.await(convert_to_wav)
    convert_to_mp3 = Task.async(fn -> System.cmd "lame", ["--abr", "320", wavfile, mp3file] end)
    Task.await(convert_to_mp3)
    clean_up = Task.async(fn -> System.cmd "rm", [wavfile] end)
    Task.await(clean_up)
    # ...now we're done
  end

  def convert_dir(dir\\".") do
    dir |>
    Path.expand |>
    Path.join("**/*.flac") |>
    Path.wildcard |>
    IO.inspect |>
    Enum.map(&convert_flac/1) |>
    IO.inspect
  end

end

