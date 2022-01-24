
(* ----
Package that automatically builds a simple class
M. Alford, Sept 2011, Mar 2021

See example at end of file.

---- *)

BeginPackage["ClassDef`"];

(* Declare externally visible functions: *)
{exec,BeginClass,EndClass,add$data$member,print$data};

Begin["`Private`"];

exec[s_]:=( (*Print[s];*) ToExpression[s] ); (* uncomment Print for debugging *)

BeginClass[classname_?StringQ,
 needclass$list_?ListQ,var$list_?ListQ,fn$list_?ListQ]:=Module[
 {i,varname,str,contexts},
 (* Check arguments: *)
 For[i=1, i<=Length[needclass$list], i++,
  str=needclass$list[[i]];
  If[ ! (StringQ[str] && StringPosition[str,"`"][[1]]==StringLength[str]),
   Print["BeginClass: needed classes must be strings ending with \"`\"."];
   Abort[];
  ];
 ];  
 For[i=1, i<=Length[var$list], i++,
  str=var$list[[i]];
  If[ ! StringQ[str],
   Print["BeginClass: variable names must be strings."];
   Abort[];
  ];
 ];  
 For[i=1, i<=Length[fn$list], i++,
  str=fn$list[[i]];
  If[ ! StringQ[str],
   Print["BeginClass: member function names must be strings."];
   Abort[];
  ];
 ];  
 (* Now start making the math code to build the package: *)
 str="BeginPackage[\""<>classname<>"`\"";
 If[Length[needclass$list]>0,
  str=str<>","<>ToString[InputForm[needclass$list]]
 ];
 str=str<>"];";
 exec[str];
 (* Declare 'member$data$list' and  'obj' in the Classname`Private` context: *)
 exec["Begin[\"`Private`\"];"];
 exec["member$data$list="<>ToString[InputForm[var$list]]];
 exec["obj;"]; 
 exec["End[];"];
 (* Now declare the member functions and constructor in the
    Classname` context. They will be defined later. *)
 exec[ ToString[fn$list]<>";"]; 
 exec["create$"<>classname<>";"];
 exec["is$"<>classname<>";"];

 (* Go in to the Classname`Private context: *)
 exec["Begin[\"`Private`\"];"];  

 (* Now define the get/set member functions *)  
 For[i=1, i<=Length[var$list], i++,
  varname=var$list[[i]];
  str=classname<>"`"<>varname<>"[obj_?is$"<>classname<>"] = obj[\""<>varname<>"\"];" ;
  exec[str];
  str= classname<>"`"<>"set$"<>varname<>"[obj_?is$"<>classname<>",value_] := ( obj[\""<>varname<>"\"] = value; )" ;
  exec[str];
 ];


 (* Create default constructor: *)
 exec["create$"<>classname<>"[]:=Module[{self}, "
  <>"self[\"class_name\"]=\""<>classname<>"\";"
  <>"self[\"data_members\"]="<>classname<>"`Private`member$data$list;"
  <>"self ];" ];

 (* Create the tester: *)
 exec["is$"<>classname<>"[obj_] := (StringQ[obj[\"class_name\"]] "
   <> "&& obj[\"class_name\"]==\""<>classname<>"\");"];
];

EndClass[]:=(
 End[];EndPackage[];
);

add$data$member[object_,varname_?StringQ]:=Module[{str,classname},
 (* this function add data members to an individual object *)
 classname=object["class_name"];
 str=classname<>"`"<>varname<>"[obj_?is$"<>classname<>"] := obj[\""<>varname<>"\"];\n" ;
 exec[str];
 str= classname<>"`"<>"set$"<>varname<>"[obj_?is$"<>classname<>",value_] := ( obj[\""<>varname<>"\"] = value; )" ;
 exec[str];
 object["data_members"]=Append[object["data_members"],varname];
 object[varname]=Null;
];

print$data[object_]:=Module[{classname,i,data$name$list,data$name},
 classname=object["class_name"];
 data$name$list=ToExpression[classname<>"`Private`member$data$list"];
 Table[ 
  Print[data$name<>"= ",object[data$name]] , 
  {data$name,data$name$list} 
 ];
];

End[];  "end of ClassDef`Private`";

EndPackage[];  "End of ClassDef`";


(* ---- Example of use of ClassDef:

Needs["ClassDef`"];

ClassDef`BeginClass["Date",
 {"Calendar`"},
 {"day","month","year"},
 {"day$of$week"}
];

"The default constructor 'create$Date[]' and the tester 'is$Date' have now
 been defined, along with get/set member fns for the data";

"Now let us define a more substantial constructor:";

create$Date[dval_,mval_,yval_]:=Module[{self},
 self=create$Date[]; "default constructor, already defined by BeginClass";
 set$day[self,dval];
 set$month[self,mval];
 set$year[self,yval];
 self
];

"and a member function:";

day$of$week[self_?is$Date]:=Module[{},
 DayOfWeek[{year[self],month[self],day[self]}]
];

ClassDef`EndClass[];   "Note that you need the explicit ClassDef` context";



"Now try it out:";

date1=create$Date[24,10,1993];
day[date1]
day$of$week[date1]

set$day[date1,25];
day$of$week[date1]

add$data$member[date1,"calendar"];
set$calendar[date1,"Gregorian"];
calendar[date1]


*)
