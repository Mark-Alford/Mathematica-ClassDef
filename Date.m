(* ---- Example of use of ClassDef:  ---- *)

(* Create a class called "Date",
  which needs the Mathematica Package "Calendar`"
  and has data members "day","month","year"
  and has member function "day$of$week"
*)

Needs["ClassDef`"];

ClassDef`BeginClass["Date",    (* name of class *)

 {"Calendar`"},                (* Packages that are needed *)

 {"day","month","year"},       (* list of member data field names *)

 {"day$of$week"}               (* list of member function names *)
];

(* At this point the following functions exist:
 create$Date[]    default constructor
 is$Date[x]       tester
 Get/Set methods:
 day[date]    set$day[date,value]
 month[date]  set$month[date,value]
 year[date]   set$year[date,value]
*)

(* Now let us define a constructor that populates the data fields when the object is created: *)

create$Date[dval_?IntegerQ,mval_?IntegerQ,yval_?IntegerQ]:=Module[{self},
 self=create$Date[]; (* create a bare-bones Date object, 
   using the default constructor already defined by BeginClass"; *)
 set$day[self,dval];
 set$month[self,mval];
 set$year[self,yval];
 self
];

(* Define the previously declared member function: *)

day$of$week[self_?is$Date]:=Module[{},
 DayName[{year[self],month[self],day[self]}]  (* DayName comes from Calendar` *)
];

ClassDef`EndClass[];   "Note that you need the explicit ClassDef` context";

(* For usage, see the file Date_example.m *)


