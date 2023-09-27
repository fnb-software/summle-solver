% Summle solver
include "summle.dzn";
include "alldifferent.mzn";

1..999: total; 
array[1..6] of 1..100: initial_numbers; 

array[1..5, 1..3] of var int: numbers;
array[1..5] of var int: operations;

function var 1..999: apply_operation(var 1..999: a, var 1..999: b, var 1..3: o) = if o = 1 then a + b elseif o = 2 then a - b elseif o = 3 then a * b else 0 endif;

constraint forall (i in index_set_1of2(numbers)) (numbers[i, 3] = apply_operation(numbers[i,1], numbers[i,2], operations[i]));

array[1..11] of var 1..999: to_pick_from = initial_numbers ++ [ numbers[i, 3] | i in index_set_1of2(numbers)];

constraint to_pick_from[11] = total;

constraint forall (i in index_set_1of2(numbers)) (is_valid_number_or_result(numbers[i,1], 2*(i-1)+1) /\ is_valid_number_or_result(numbers[i,2], 2*(i-1)+2));

array[1..11] of var 1..11: mapping;

function var bool: is_valid_number_or_result(var int: n, int:i) = (to_pick_from[mapping[i]] = n) /\ (mapping[i] <= ((i-1) div 2) + 6);

constraint alldifferent(mapping);


output ["\(initial_numbers)\n\(total)\npick from=\(to_pick_from)\nmapping=\(mapping)\nnumbers=\(numbers)\nop=\(operations)"];
