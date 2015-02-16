defmodule KV.Registry do
  use GenServer

  # client API

  def start_link(table, event_manager, buckets, opts\\[]) do
    # "preferrable to pass the event manager pid/name to start_link, decoupling the start of the event manager from the registry"
    GenServer.start_link(__MODULE__, {table, event_manager, buckets}, opts)
    # module where server callbacks are, init param, options
  end

  def lookup(table, name) do
    case :ets.lookup(table, name) do # no longer calling lookup on a server
      [{^name, bucket}] -> {:ok, bucket}
      [] -> :error
    end
  end

  def create(server, name) do
    server
    |> GenServer.call({:create, name})
  end

  # server callbacks
  # ...more: http://elixir-lang.org/docs/stable/elixir/GenServer.html

  def init({table, events, buckets}) do
    refs = :ets.foldl(&update_with_monitors/2, HashDict.new, table)
    {:ok, %{names: table, refs: refs, events: events, buckets: buckets}}
  end

  def handle_call({:create, name}, _from, state) do
    case lookup(state.names, name) do
      {:ok, pid} -> {:noreply, pid, state}
      :error ->
        {:ok, pid} = KV.Bucket.Supervisor.start_bucket(state.buckets)
        ref = Process.monitor(pid)
        refs = HashDict.put(state.refs, ref, name)
        :ets.insert(state.names, {name, pid})
        GenEvent.sync_notify(state.events, {:create, name, pid}) # push notification to server on create
        {:reply, pid, %{state | refs: refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, pid, _reason}, state) do
    # all other messages
    # (e.g. stopped)
    {name, refs} = HashDict.pop(state.refs, ref)
    :ets.delete(state.names, name)
    GenEvent.sync_notify(state.events, {:exit, name, pid}) # push notification to server on exit
    {:noreply, %{state | refs: refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  # ...

  defp update_with_monitors({name, pid}, acc) do
    HashDict.put(acc, Process.monitor(pid), name)
  end

end
