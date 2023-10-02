% Summle solver
include "summle.dzn";
include "alldifferent.mzn";

1..999: total; 
array[1..6] of 1..100: initial_numbers; 

% The summle solution sheet
array[1..5, 1..3] of var 1..1000000: numbers;
% The operation for each row of the sheet
array[1..5] of var 1..4: operations;

% Numbers available to pick from for the first 2 numbers of each row (initial numbers + 3rd numbers of each line)
array[1..11] of var 1..1000000: to_pick_from = initial_numbers ++ [ numbers[i, 3] | i in index_set_1of2(numbers)];
% Keep track of picked numbers
array[1..11] of var 1..11: mapping;

% Each number can only be picked once
constraint alldifferent(mapping);

% The first 2 numbers of each row are numbers picked from the available initial numbers or results. A result cannot be picked before it was obtained.
constraint forall (i in index_set_1of2(numbers)) (is_valid_number_or_result(numbers[i,1], 2*(i-1)+1) /\ is_valid_number_or_result(numbers[i,2], 2*(i-1)+2));
function var bool: is_valid_number_or_result(var int: n, int:i) = (to_pick_from[mapping[i]] = n) /\ (mapping[i] <= ((i-1) div 2) + 6);

% For each row the 3rd number is the result of the operation of the first 2 numbers
constraint forall (i in index_set_1of2(numbers)) (numbers[i, 3] = apply_operation(numbers[i,1], numbers[i,2], operations[i]));
% 1 is "+", 2 is "-", 3 is "*" and 4 is "/"
function var 1..1000000: apply_operation(var 1..1000000: a, var 1..1000000: b, var 1..4: o) = if o = 1 then a + b elseif o = 2 then a - b elseif o = 3 then a * b elseif a mod b = 0 then a div b else 0 endif;

% One of the results must be the solution
var 1..5:steps;
constraint to_pick_from[steps+6] = total;
solve minimize steps;

output ["\(initial_numbers)\n\(total)\npick from=\(to_pick_from)\nmapping=\(mapping)\nnumbers=\(numbers)\nop=\(operations)\nsteps: \(steps)"];
