
module Syntax exposing (..)


greet : String -> String
greet name =
  "Hello, " ++ name


-- A type alias, for alisasing a record type.
type alias Dog =
  { name : String,
    age : Int,
    breed: Breed
  }

-- A union type, used as a enum here.
type Breed =
  Bishon |
  Poodle |
  Sheltie |
  Mix Breed Breed

dog : Dog
dog =
  Dog "Nemo" 8 Poodle

output : String
output =
  dog
    |> toString
