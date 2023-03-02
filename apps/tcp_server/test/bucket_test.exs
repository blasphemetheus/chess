defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    # bucket = start_supervised!(KV.Bucket)
    {:ok, bucket} = KV.Bucket.start_link([])
    %{bucket: bucket}
  end

  @tag :skip
  test "stores values by key" do
    {:ok, bckt} = KV.Bucket.start_link([])
    assert KV.Bucket.get(bckt, "milk") == nil

    KV.Bucket.put(bckt, "milk", 3)
    assert KV.Bucket.get(bckt, "milk") == 3
  end

  @tag :skip
  test "stores values with key : callbacks!", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  @tag :skip
  test "delete key from bucket", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 5)
    assert KV.Bucket.get(bucket, "milk") == 5
    assert KV.Bucket.delete(bucket, "milk") == 5
    assert KV.Bucket.get(bucket, "milk") == nil
  end

  @tag :skip
  test "are temporary workers" do
    assert Supervisor.child_spec(KV.Bucket, []).restart == :temporary
  end
end
