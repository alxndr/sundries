defmodule Flac2mp3 do

  # assumes you have flac and lame available via $PATH

  def convert_flac(flacfile) do
    IO.inspect flacfile
    wavfile = String.replace(flacfile, ~r/\.flac$/, ".wav")
    mp3file = String.replace(flacfile, ~r/\.flac$/, ".mp3")
    # spawn a process and do this...
    System.cmd "flac", ["-d", "-o", wavfile, flacfile]
    # ...when that is done spawn a process and do this...
    System.cmd "lame", ["--abr", "320", wavfile, mp3file]
    # ...when that is done spawn a process and do this...
    System.cmd "rm", [wavfile]
    # ...now we're done
  end

  def convert_dir(dir\\".") do
    dir |>
    Path.expand |>
    Path.join "**/*.flac" |>
    Path.wildcard |>
    IO.inspect |>
    Enum.map &convert_flac/1
  end

end

