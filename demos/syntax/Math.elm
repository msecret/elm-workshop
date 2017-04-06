
module Math exposing (add)

add: Int -> Int -> Int
add x y =
  x + y

list : List Int
list =
  List.range 1 10

double : Int -> Int
double n =
  n * 2

dog =
  { name = "Tucker",
    age = 11
  }

output : String
output =
  list
    |> List.map double
    |> List.map (add 2)
    |> toString
