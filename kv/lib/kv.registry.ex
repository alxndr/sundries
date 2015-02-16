defmodule KV.Registry do
  use GenServer

  # client API

  def start_link(opts\\[]) do
    GenServer.start_link(__MODULE__, :ok, opts)
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

  def init(:ok) do
    names = HashDict.new # name    -> pid
    refs = HashDict.new  # pid ref -> name
    # shown in handle_cast/2's else
    {:ok, {names, refs}}
  end

  def handle_call({:lookup, name}, _from, {names, _} = state) do
    # synchronous requests
    {:reply, HashDict.fetch(names, name), state}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_cast({:create, name}, {names, refs}) do
    # asynchronous requests; "create/2 should have used call/2"
    if HashDict.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, pid} = KV.Bucket.start_link
      ref = Process.monitor(pid)
      refs = HashDict.put(refs, ref, name)
      names = HashDict.put(names, name, pid)
      {:noreply, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    # all other messages
    # (e.g. stopped)
    {name, refs} = HashDict.pop(refs, ref)
    names = HashDict.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

end
