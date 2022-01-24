(* ---- Example of use of ClassDef:  ---- *)

Needs["Date`"];  (* import the Date package defined in Date.m *)

date1=create$Date[24,10,1993];  (* create a date object for 1993/10/24 *)

day[date1]   (* get the value of the "day" field *)
(* 24 *)

day@date1   (* Alternate notation using Mathematica '@' to mean 'of' *)
(* 24 *)

day$of$week[date1]  (* ask what day of the week that date is *)
(* Sunday *)

set$day[date1,25];  (* change the day number from 24 to 25 *)
day$of$week[date1]
(* Monday *)

print$data[date1];  (* ask for a printout of all data fields *)
(*
  day= 25
  month= 10
  year= 1993
*)

(*
add$data$member[date1,"calendar"];
set$calendar[date1,"Gregorian"];
calendar[date1]
*)
