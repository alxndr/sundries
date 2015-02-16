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
    {:ok, manager} = GenEvent.start_link
    {:ok, registry} = KV.Registry.start_link(manager)

    GenEvent.add_mon_handler(manager, Forwarder, self())

    {:ok, r: registry}
  end

  test "spawns buckets", %{r: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{r: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    Agent.stop bucket
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "sends events on create and crash", %{r: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    assert_receive {:create, "shopping", ^bucket} # ^ means match with the value of bucket

    Agent.stop(bucket)
    assert_receive {:exit, "shopping", ^bucket}
  end

  test "removes a bucket on crash", %{r: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # kill bucket
    Process.exit(bucket, :shutdown)
    assert_receive {:exit, "shopping", ^bucket}

    # blocks for notification...
    assert KV.Registry.lookup(registry, "shopping") == :error
  end
end
