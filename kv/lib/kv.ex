defmodule KV do
  use Application

  def start(_type, _args) do
    KV.Supervisor.start_link # run on app init
  end

end
