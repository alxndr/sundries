defmodule KV.RegistryTest do

  use ExUnit.Case, async: true

  defmodule Forwarder do
    use GenEvent

    def handle_event(event, parent) do
      send parent, event
      {:ok, parent}
    end
  end

  setup do
    ets = :ets.new(:registry_table, [:set, :public])
    registry = start_registry(ets)
    {:ok, r: registry, ets: ets}
  end

  defp start_registry(ets) do
    {:ok, sup} = KV.Bucket.Supervisor.start_link
    {:ok, manager} = GenEvent.start_link
    {:ok, registry} = KV.Registry.start_link(ets, manager, sup)

    GenEvent.add_mon_handler(manager, Forwarder, self())
    registry
  end

  test "spawns buckets", %{r: registry, ets: ets} do
    assert KV.Registry.lookup(ets, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(ets, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{r: registry, ets: ets} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(ets, "shopping")
    Agent.stop bucket
    assert_receive {:exit, "shopping", ^bucket} # wait for it...
    assert KV.Registry.lookup(ets, "shopping") == :error
  end

  test "sends events on create and crash", %{r: registry, ets: ets} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(ets, "shopping")
    assert_receive {:create, "shopping", ^bucket} # ^ means match with the value of bucket

    Agent.stop(bucket)
    assert_receive {:exit, "shopping", ^bucket}
  end

  test "removes a bucket on crash", %{r: registry, ets: ets} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(ets, "shopping")

    # kill bucket
    Process.exit(bucket, :shutdown)
    assert_receive {:exit, "shopping", ^bucket} # wait for it...
    assert KV.Registry.lookup(ets, "shopping") == :error
  end

  test "monitors existing buckets on startup", %{r: registry, ets: ets} do
    bucket = KV.Registry.create(registry, "shopping")

    # (unlink then) kill registry process
    Process.unlink(registry)
    Process.exit(registry, :shutdown)

    # start new registry using existing ets
    start_registry(ets)

    # assert that contents are same as before
    assert KV.Registry.lookup(ets, "shopping") == {:ok, bucket}

    # kill bucket process
    Process.exit(bucket, :shutdown)

    # ..we should get notification
    assert_receive {:exit, "shopping", ^bucket}
    assert KV.Registry.lookup(ets, "shopping") == :error
  end

end
