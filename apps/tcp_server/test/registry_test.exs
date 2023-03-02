defmodule MyRegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(MyRegistry)
    %{registry: registry}
  end

  @tag :skip
  test "spawns buckets", %{registry: registry} do
    assert MyRegistry.lookup(registry, "shopping") == :error

    MyRegistry.create(registry, "shopping")
    assert {:ok, bucket} = MyRegistry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  @tag :skip
  test "removes buckets on exit", %{registry: registry} do
    MyRegistry.create(registry, "shopping")
    {:ok, bucket} = MyRegistry.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert MyRegistry.lookup(registry, "shopping") == :error
  end

  @tag :skip
  test "removes buckets on crash", %{registry: registry} do
    MyRegistry.create(registry, "shopping")
    {:ok, bucket} = MyRegistry.lookup(registry, "shopping")

    # stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)
    assert MyRegistry.lookup(registry, "shopping") == :error
  end
end
