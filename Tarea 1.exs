defmodule Shop do
   def calc_total(nil, amount) do: amount
   def calc_total(tax, amount), do: amount + amount * tax

   def apply_taxes(taxes, orders) do 
      Enum.map(orders, fn x ->
               Map.put(x, :total_amount, calc_total(taxes[x.ship_to], x.net_amount)) end)
   end
end
