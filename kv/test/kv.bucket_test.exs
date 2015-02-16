defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "values are initially nil", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil
  end

  test "stores values by key", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 2)
    assert KV.Bucket.get(bucket, "milk") == 2
  end

  test "overwrites values", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
    KV.Bucket.put(bucket, "milk", 4)
    assert KV.Bucket.get(bucket, "milk") == 4
  end

  test "deletes values", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 5)
    assert KV.Bucket.get(bucket, "milk") == 5
    assert KV.Bucket.delete(bucket, "milk") == 5
    assert KV.Bucket.get(bucket, "milk") == nil
  end

end
