defmodule Wcount do
    def count([], map) do
      map
      |> Enum.each(fn({k, v})-> IO.puts("#{k}-> #{v}") end) 
    end
    def count([head|tail], map) do
        map= Map.update(map, head, 1, &(&1 + 1))
        count(tail, map)
    end

    def file_to_list(path) do
        File.stream!(path)
        |> Stream.map(&String.downcase(&1))
        |> Stream.map(&String.replace(&1, ~r/[[:punct:]]/, ""))
        |> Stream.map(&String.split(&1, "\n", trim: true))
        |> Stream.map(fn([x])-> String.split(x, " ") end)
        |> Enum.to_list
    end

    def mk_nodes(n) do
        1..n
        |> Stream.map(fn x -> "n" <> Integer.to_string(x) <> "@localhost" end)
        |> Stream.map(fn(x)-> String.to_atom(x) end)
    end

    def connect_nodes(stream) do
        Enum.each(Enum.to_list(stream), fn(x)-> Node.connect(x) end)
    end

    def disconnect_nodes(stream) do
        Enum.each(Enum.to_list(stream), fn(x)-> Node.disconnect(x) end)
    end

    def spawn_nodes(stream, text) do
        Enum.map(Enum.zip(stream, text), 
                  fn({n, t})-> Node.spawn(n, Wcount, :count, [t, %{}]) end)
    end

    def main(path) do
        txt= file_to_list(path)
        nodes= mk_nodes(length(txt))
        connect_nodes(nodes)
        spawn_nodes(nodes, txt)
        #disconnect_nodes(nodes)
    end
end

