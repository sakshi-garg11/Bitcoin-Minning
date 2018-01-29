defmodule Project1.Manager do
    use Agent
    def start_link() do
        Agent.start_link(fn -> %{} end)
    end
    def get(bucket, key) do
        Agent.get(bucket, &Map.get(&1, key))
    end
    def put(bucket, key, value) do
        Agent.update(bucket, &Map.put(&1, key, value))
      end
    def log(data) do
      IO.puts(data)
   end
end