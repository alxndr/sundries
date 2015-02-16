defmodule KV.Bucket.Supervisor do
  use Supervisor

  def start_link(opts\\[]) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def start_bucket(supervisor) do
    # "instead of calling KV.Bucket.start_link directly in the registry"
    Supervisor.start_child(supervisor, [])
  end

  def init(:ok) do
    children = [
      worker(KV.Bucket, [], restart: :temporary) # don't restart; "creation of buckets pass[es] through the registry"
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
