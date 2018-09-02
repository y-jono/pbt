defmodule PbtTest do
  use ExUnit.Case
  use PropCheck

  #Properties
  property "description of what the property does" do
    forall type <- my_types() do
      boolean(type)
    end
  end

  property "finds biggest element" do
    forall x <- non_empty(list(integer())) do
      Pbt.biggest(x) == model_biggest(x)
    end
  end

  def model_biggest(list) do
    List.last(Enum.sort(list))
  end

  # helpers
  def boolean(_) do
    true
  end

  # generators
  def my_types() do
    term()
  end

  property "picks the last number" do
    forall {list, known_last} <- {list(number()), number()} do
      known_list = list ++ [known_last]
      known_last == List.last(known_list)
    end
  end

  property "a sorted list has ordered pairs" do
    forall list <- list(term()) do
      is_ordered(Enum.sort(list))
    end
  end

  def is_ordered([a, b | t]) do
    a <= b and is_ordered([b | t])
  end

  def is_ordered(_) do
    true
  end
end
