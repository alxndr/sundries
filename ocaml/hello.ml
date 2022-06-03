let get_celsius = (fun () -> print_endline "input degrees celsius..."; read_float ())
let c_to_k = (fun c -> c +. 273.15)
let c_to_f = (fun c -> (c *. 9. /. 5.) +. 32.)

let celsius = get_celsius ()
let kelvin = c_to_k celsius
let fahrenheit = c_to_f celsius
let () =
  print_float celsius ;
  print_endline (" C") ;
  print_float kelvin ;
  print_endline (" K") ;
  print_float fahrenheit ;
  print_endline (" F")
