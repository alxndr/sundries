defmodule KV.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @manager_name KV.EventManager
  @registry_name KV.Registry
  @bucket_sup_name KV.Bucket.Supervisor
  # names are helpful, not required

  def init(:ok) do
    children = [ # "registry depends on the event manager, start latter before former"
      worker(GenEvent, [[name: @manager_name]]),
      supervisor(KV.Bucket.Supervisor, [[name: @bucket_sup_name]]),
      worker(KV.Registry, [@manager_name, @bucket_sup_name, [name: @registry_name]]),
    ]
    supervise(children, strategy: :one_for_one)
  end

end
