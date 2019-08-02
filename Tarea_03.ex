defmodule Calcu do

   def start do
      spawn(fn-> loop(0) end)
   end
   
   defp print_res do
      receive do
         {:ok, res}-> res
      end
   end
      
   def value(pid) do
      send(pid, {:run_op, self(), 0, :val})
      print_res()
   end
   
   def sum(pid, num) do
      send(pid, {:run_op, self(), num, :sum})
      print_res()
   end
   
   def sub(pid, num) do
      send(pid, {:run_op, self(), num, :sub})
      print_res()
   end
   
   def div(pid, num) do
      send(pid, {:run_op, self(), num, :div})
      print_res()
   end
   
   def mul(pid, num) do
      send(pid, {:run_op, self(), num, :mul})
      print_res()
   end
   
   defp loop(curr) do
      n_num= receive do
         {:run_op, caller, num, op} ->
            res= 
               case op do
                  :val-> curr
                  :sum-> curr + num
                  :sub-> curr - num
                  :div-> curr / num
                  :mul-> curr * num
               end
            send(caller, {:ok, res})
            res
      end
      loop(n_num)
  end
end
