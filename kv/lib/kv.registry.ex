defmodule KV.Registry do
  use GenServer

  # client API

  def start_link(event_manager, buckets, opts\\[]) do
    # "preferrable to pass the event manager pid/name to start_link, decoupling the start of the event manager from the registry"
    GenServer.start_link(__MODULE__, {event_manager, buckets}, opts)
    # module where server callbacks are, init param, options
  end

  def lookup(server, name) do
    server
    |> GenServer.call({:lookup, name})
  end

  def create(server, name) do
    server
    |> GenServer.cast({:create, name})
  end

  # server callbacks
  # ...more: http://elixir-lang.org/docs/stable/elixir/GenServer.html

  def init({events, buckets}) do
    names = HashDict.new # name    -> pid
    refs = HashDict.new  # pid ref -> name
    # shown in handle_cast/2's else

    {:ok, %{names: names, refs: refs, events: events, buckets: buckets}}
  end

  def handle_call({:lookup, name}, _from, state) do
    # synchronous requests
    {:reply, HashDict.fetch(state.names, name), state}
  end

  def handle_cast({:create, name}, state) do
    # asynchronous requests; "create/2 should have used call/2"
    if HashDict.get(state.names, name) do
      {:noreply, state}
    else
      # start bucket w/its supervisor
      {:ok, pid} = KV.Bucket.Supervisor.start_bucket(state.buckets)
      ref = Process.monitor(pid)
      refs = HashDict.put(state.refs, ref, name)
      names = HashDict.put(state.names, name, pid)
      GenEvent.sync_notify(state.events, {:create, name, pid}) # push notification to server on create
      {:noreply, %{state | names: names, refs: refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, pid, _reason}, state) do
    # all other messages
    # (e.g. stopped)
    {name, refs} = HashDict.pop(state.refs, ref)
    names = HashDict.delete(state.names, name)
    GenEvent.sync_notify(state.events, {:exit, name, pid}) # push notification to server on exit
    {:noreply, %{state | names: names, refs: refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

end
