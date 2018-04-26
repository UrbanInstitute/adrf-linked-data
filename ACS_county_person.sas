/***************************************************
  This script create variables for the sloan project

household at state level 


By Jun Zhu
*****************************************************/

libname IPUMS "K:\Housefin3\Monthly\ACS";
libname sloan "J:\housefin2\sloan";
libname cross "K:\Housefin3\Monthly\cross-walks";


/*****************************************************
PUMA 2000 is valid from 2005 through 2011 ACS Data
PUMA 2010 is valid for 2012, 2013, 2014 and 2015 ACS Data

*****************************************************/


/*****change the geo level here *****/

%let geo_level = year state county14;
%let geolist ="year", "state", "county14";
%let lastgeo= county14;
%let datas=person;
%let dset1=puma2000tocounty2014;
%let dset2=puma2010tocounty2014;



/***************************************/



%macro ss_cross_a;

data aa; 
  set cross.&dset1.;
  afact1 = afact*1;
  state1=state*1;
  puma1=puma2K*1;
run;


%do year=2005 %to 2011;

proc sql;

create table h&datas._&year. as
select 
   a.*
  ,b.county14  as county14
  ,b.afact1 as afact1

from &datas.a_&year. a 
inner join  aa b
on (a.State =b.state1 and a.puma = b.puma1)
;

quit;

data &datas._&year.;
    set h&datas._&year.;
	  afact= afact1*perwt;
run;

%end;

%mend ;


/***********************/

%macro ss_cross_b;

data aa; 
  set cross.&dset2.;
  afact1 = afact*1;
  state1=state*1;
  puma1=puma12*1;
run;


%do year=2012 %to 2015;

proc sql;

create table h&datas._&year. as
select 
   a.*
  ,b.county14  as county14
  ,b.afact1 as afact1

from &datas.A_&year. a 
inner join  aa b
on (a.State =b.state1 and a.puma = b.puma1)
;



quit;

data &datas._&year.;
    set h&datas._&year.;
	  afact= afact1*perwt;
run;



%end;


%mend ;


/***cat. variables ***/

/***variables ends with 1 or 2 are created by urban
    vacancy rate provided

****/


/*******************************************/


%LET CAT_PERSON=SEX AGE1 RACE1 ABSENT AVAILBLE BPL1 CARPOOL CLASSWKR CITIZEN COMMUSE 
                DIFFCARE  DIFFMOB DIFFPHYS  DIFFREM    
                EDUC EMPSTAT  FERTYR  GCHOUSE GCMONTHS GCRESPON 
                GRADEATT  HISPAN LABFORCE
                LANGUAGE LOOKING  
                MARST MIGRATE1 MOVEDIN MULTGEN 
                 RACE RELATE RIDERS SCHLTYPE SCHOOL SPEAKENG TRANWORK
				VETSTAT WKSWORK2 WORKEDYR WRKLSTWK
 
;

%LET NUME_PERSON=AGE FTOTINC INCEARN INCINVST INCOTHER INCBUS00 INCRETIR INCSS INCSUPP
                 INCTOT INCWAGE INCWELFR TRANTIME UHRSWORK YRSUSA1


;


%LET CROSS_CAT_PERSON = SEX AGE2 RACE1 AVAILBLE BPL1 CARPOOL CLASSWKR CITIZEN COMMUSE 
                DIFFCARE   
                EDUC1  EMPSTAT  
                GRADEATT SCHLTYPE1 SPEAKENG1 TRANWORK1
				VETSTAT ;


%LET CROSS_NUM_PERSON=AGE FTOTINC INCEARN INCINVST INCOTHER INCBUS00 INCRETIR INCSS INCSUPP
                 INCTOT INCWAGE INCWELFR TRANTIME UHRSWORK YRSUSA1 ;



%LET CAT_CROSS_PERSON1=SEX AGE2 RACE1 AVAILBLE BPL1 CARPOOL CLASSWKR CITIZEN COMMUSE 
                DIFFCARE   
                EDUC1  EMPSTAT  
                GRADEATT SCHLTYPE1 SPEAKENG1 TRANWORK1
				VETSTAT   ;


/**********************************
categories for numeric variables
**********************************/

proc format;

  value age_f  
                low -4 ="Low_4"
                5-9 = "5_24"
                10-14 = "10_14"
                15-19 = "15_19"
                20-24 = "20_24"
                25-29 = "25_29"
                30-34 = "30_34"
                35-39 = "35_39"
                40-44 = "40_44"
                45-49 = "45_49"
                50-54 = "50_54"
                55-59 = "55_59"
                60-64 = "60_64"
                65-69 = "65_69"              
				70-74 = "70_74"
                75-79 = "75_79"
                80-84 = "80_84"
                85-high ="85_High" ;

  value age_ff  
                low -19 = "Low_19"
                20-39 = "20_39"
                40-59 = "40_59"
                60-high ="60_High" ;

  value family_f  
                low -1 ="Low_1"
                2 = "2"
                3 = "3"
                4-high ="4_High" ;
  


value educ_f


Low-0	=	"Low-No"
1-2	=	"1_8"
3-6	=	"9_12"
7-9	=	"C1_C3"
10-high	="C4_High"
;



value SCHLTYPE_f
  0 - 1 = "No_NA"
  2 = "Public"
  3-high ="Private"
;

value SPEAKENG_f
  0,7,8 = "NA"
  1 = "No"
  2 -6 = "Yes"

;
value TRANWORK_f
  00 = "NA"
  10,11,12,13,14,15,35 = "Auto"
  30,31 = "Bus"
  33="Subway"
  32,60,34,36,40,20="Other"
  70 = "WFH"
;


run;






/** PERSON type variables **************/

%macro dyear;

%do i=2001 %to 2015;
 data &datas.a_&i.;
    set ipums.full_2001_2015(  where=(year=&i.));

	/*******create categories *****/

   	if hispan = 0 then his=0; **not hispanic**;
    else his=1; **hispanic**;
    if race = 2  and his=0 then race1="B"; **black**;
    else if race = 1 and his=0 then race1="W"; **white**;
    else if his=1 then race1="H";
    else race1="O";

	age1=put(age, age_f.);
    age2=put(age, age_ff.);
    BPL1=BPL;
	if BPL>57 then BPL1=57;

	EDUC1 =put(EDUC, educ_f.);
	SCHLTYPE1=put(SCHLTYPE, SCHLTYPE_f.);
	SPEAKENG1=put(SPEAKENG,SPEAKENG_f.);
	TRANWORK1=put(TRANWORK,TRANWORK_f.);
   

	   /***clear numerical variables ****/
 


if INCBUS00 <3 or INCBUS00 >999990 then INCBUS00=.;
if INCEARN <3 or INCEARN >9999990 then INCEARN=.;
if INCINVST  <3 or INCINVST  >999990 then INCINVST =.;
if INCOTHER <3  or INCOTHER >999990 then INCOTHER=.;
if INCRETIR  <3 or INCRETIR  >999990 then INCRETIR =.;
if INCSS <3  or INCSS >999990 then INCSS=.;
if INCSUPP <3  or INCSUPP >999990 then INCSUPP=.;
if INCTOT <3  or INCTOT >9999990 then INCTOT=.;
if INCWAGE <3  or INCWAGE >999990 then INCWAGE=.;
if INCWELFR <3  or INCWELFR >99990 then INCWELFR=.;
if TRANTIME <3 then TRANTIME=.;
if UHRSWORK<1 then UHRSWORK=.;
if YRSUSA1<1 then YRSUSA1=.;


state = statefip;
	
keep year STATE puma perwt &cat_PERSON. &nume_PERSON. &CROSS_CAT_PERSON.
;

run;

%end;

%mend;
%dyear;


/**************************
crosswalk tables here 
************************/

%ss_cross_a;

%ss_cross_b;



/**************************************
 &datas.:  get stsate level results -----cat. variables 
**************************************/


/*****macro for calculation ******/



%macro m1 (varlist);
%local i next ;
%let i=1;
%do i=1 %to %sysfunc(countw(&varlist));
  %let next=%scan(&varlist,&i);
         proc freq data=&datas._&year. noprint ;
         by &geo_level.;
         weight afact;
         tables  &next./ out = &next._num;
run;

data &next._num_1;
    set &next._num;
	   keep &geo_level.  &next. count;
run;



proc transpose data=&next._num_1 out=&next._wide prefix=&next._;
         by &geo_level.;
id &next.;
var count;
run;


data &next._&year.;
   set &next._wide;
    keep &geo_level.  &next._:;
run;


proc sort data=&next._&year.; by &geo_level.; run;

%if &i=1 %then %do;
   data bb_cat_&year._&datas.;
      set &next._&year.;
	run;
%end;
  %else %do;
    data bb_cat_&year._&datas.;
      merge bb_cat_&year._&datas.(in=a) &next._&year.(in=b);
	  by &geo_level.;
	run;
%end;

/*****variable list *****/
proc freq data=&datas._&year. noprint ;
         tables  &next./ out = &next._list;
		 by year;
run;

data &next._list1;
   set &next._list ( rename = ( &next. = code));
     code1 = strip( put(code, $10.));
   variable_name = cats ("&next.",'_',code1);
       variable1 = cats ("&next.");
   keep year variable_name variable1 code1;
   
run;

proc append base = var_list_&year.
            data = &next._list1
			force;
run;


;

   
%end;
%mend m1;



%macro dcal;

%do year=2005 %to 2015;
proc delete data =var_list_&year.; run;

proc sort data= &datas._&year.;
	  by &geo_level.;
run;

 
%m1(&cat_&datas..);

proc sort data= bb_cat_&year._&datas.;
by &geo_level.;
run;


data var_list_&year.;
   set var_list_&year.;
     y&year._code ="X";
   keep year variable_name  variable1 code1 y&year._code;
  ;

run;

proc sort data=var_list_&year.;
    by variable_name ;
run;

%end;

%mend;
%dcal;






data aa_var_list_&datas.;
  merge var_list_2005 - var_list_2015;
  by variable_name;
run;






/*****macro for cross-tab calculation ******/

%macro twoway(varlist);
%local i j;
%do i=1 %to %sysfunc(countw(&varlist,%str( )))-1;
     %do j=&i+1 %to %sysfunc(countw(&varlist,%str( )));
          %let next1=%scan(&varlist,&i);
		  %let next2=%scan(&varlist,&j);
		proc sort data = &datas._&year.;
	  by &geo_level.;
	   run;



         proc freq data=&datas._&year. noprint;
         by &geo_level.;
         weight afact;
         tables  &next1.*&next2./ out = numa;
run;

data num_1;
    set numa;
	 code1 = strip( put(&next1., $10.));
	 code2 = strip( put(&next2., $10.));
       cat_name = cats ("&next1.",'_',code1,'_', "&next2.",'_',code2);
	   keep &geo_level. cat_name count;
run;



proc transpose data=num_1 out=wide ;
by &geo_level.;
id cat_name;
var count;
run;


data &next1._&next2._&year.;
   set wide;
    drop _name_ _label_;
run;


proc sort data=&next1._&next2._&year.; 	  by &geo_level.; run;

%if &i=1 %then %do;
   data bb_cat_cross_&year._&datas.;
      set &next1._&next2._&year.;
	run;
%end;
  %else %do;
    data bb_cat_cross_&year._&datas.;
      merge bb_cat_cross_&year._&datas.(in=a) &next1._&next2._&year.(in=b);
	  by &geo_level.;
	run;
%end;

/*****variable list *****/
proc freq data=&datas._&year. noprint ;
         tables  &next1.*&next2./ out = list;
		 by year;
run;

data list1;
   set list;
     variable1 = cats ("&next1.");
	 code1 = strip( put(&next1., $10.));
     variable2 = cats ("&next2.");
	 code2 = strip( put(&next2., $10.));
     variable_name = cats ("&next1.",'_',code1,'_', "&next2.",'_',code2);
   keep year variable_name code1 code2 variable1 variable2;
   
run;

proc append base = var_cross_list_&year.
            data = list1
			force;
run;



%end;
%end;

%mend;





%macro dcal;

%do year=2005 %to 2015;
proc delete data= var_cross_list_&year.; run;
 

%twoway(&cat_cross_&datas.1.);


data var_cross_list_&year.;
   set var_cross_list_&year.;
     y&year._code = "X";
run;

proc sort data=var_cross_list_&year.;
    by variable_name ;
run;

%end;

%mend;
%dcal;

data aa_var_cross_list_&datas.;
  merge var_cross_list_2005 - var_cross_list_2015;
  by variable_name;
  drop year;
run;




                                                                                                                                                                                                                          

/**************************************
 &datas.:  get stsate level results -----numeric variables 

above p99 as missing, and below p1 as missing 
 
**************************************/




%macro dcal(varlist);

%do year=2005 %to 2015;
				  proc sort data = &datas._&year.;
                  by &geo_level.;
				  run;



         proc means  data=&datas._&year. noprint ;
         by &geo_level.;
         weight afact;
		 var &varlist.;
         output out = num_sum  
                    mean (&varlist.)= p1(&varlist.)= p10(&varlist.)= p25(&varlist.)= 
					p50(&varlist.)=   p75(&varlist.)=  p90(&varlist.)=  stddev(&varlist.)= /autoname  
		;



	    run;
data bb_num_sum1_&year.;
     set num_sum;
	   drop _type_ _freq_;
run;

proc sort data= bb_num_sum1_&year.;
	  by &geo_level.;
	run;

proc contents data=bb_num_sum1_&year. out=num_sum2 noprint;


run;
data var_&year;
    set num_sum2;
	   variable_name = name;
	   variable1=  scan(variable_name, 1, '_');
          a=index(variable_name, '_')+1;
     	   code1= substr(variable_name, a);
	   y&year._code = "X";
	   if variable_name in( &geolist.) then delete; 

   keep variable_name y&year._code  variable1 code1;
run;

proc sort data=var_&year; by variable_name;
run;



%end;


%mend;
%dcal(&nume_&datas..);

data aa_var_num_list_&datas.;
  merge var_2005 - var_2015;
  by variable_name;
run;







/**************************************
 &datas.:  numeric variables * cat. variables  

**************************************/




%macro dd(varlist1, varlist2);

%local i j next1 next2;

%do i=1 %to %sysfunc(countw(&varlist1));
                  %let next1=%scan(&varlist1,&i);


    %do j=1 %to %sysfunc(countw(&varlist2));

		  %let next2=%scan(&varlist2.,&j);

				  proc sort data = &datas._&year.;
                  by &geo_level.  &next1.;
				  run;

                 proc means  data=&datas._&year. noprint ;
                 by &geo_level.  &next1.;
                 weight afact;
		         var &next2.;
                 output out = num_sum_&next1._&next2.  
                 mean (&next2.)= &next2.;
	             run;

                proc transpose data=num_sum_&next1._&next2.  out=wide  
                prefix=&next2._&next1._;
                by &geo_level.;
                id &next1.;
                var &next2.;
                run;


data &next1._&next2._&year.;
   set wide;
    drop _name_  _label_;
run;


proc sort data=&next1._&next2._&year.; 	  by &geo_level.; run;

%if &i=1 %then %do;
   data bb_cross_num_&year._&datas.;
      set &next1._&next2._&year.;
	run;
%end;
  %else %do;
    data bb_cross_num_&year._&datas.;
      merge bb_cross_num_&year._&datas.(in=a) &next1._&next2._&year.(in=b);
	  by &geo_level.;
	run;
%end;

proc sort data=bb_cross_num_&year._&datas.;
	  by &geo_level.;
	run;






/*****variable list *****/
                 proc sort data = &datas._&year.;
                 by year &next1.;
				 run;

                 proc means  data=&datas._&year. noprint ;
                 by year &next1.;
                 weight afact;
		         var &next2.;
                 output out = list  
                 mean (&next2.)= &next2.;
	             run;

data list1;
   set list;
     variable1 = cats ("&next1.");
	 code1 = strip( put(&next1., $10.));
     variable2 = cats ("&next2.");
     variable_name = cats ("&next2.",'_',"&next1.",'_',code1);
	 code2="Mean";

   keep year variable_name code1  variable1 variable2 code2;
   
run;

proc append base = cross_num_list_&year.
            data = list1
			force;
run;



%end;
   
%end;
%mend ;



%macro dcal;


%do year=2005 %to 2015;
proc delete data= cross_num_list_&year.; run;

%dd(&CAT_CROSS_&datas.1., &cross_num_&datas..);



data cross_num_list_&year.;
   set cross_num_list_&year.;
     y&year._code ="X";
	keep variable_name y&year._code code1 variable2 variable1 code2;
run;

proc sort data=cross_num_list_&year.;
    by variable_name ;
run;
%end;







%mend;
%dcal;

data aa_var_cross_num_list_&datas.;
  merge cross_num_list_2005 - cross_num_list_2015;
  by variable_name;
run;







%macro dcal;
proc delete data =sloan.&datas._&lastgeo._f; run;
proc delete data=sloan.&datas._&lastgeo._var; run;


data sloan.&datas._&lastgeo._f;
    merge bb_:;
	by &geo_level.;
run;


proc append data=Aa_var_cross_list_&datas.
            base=sloan.&datas._&lastgeo._var
			force;
run;

proc append data=Aa_var_cross_num_list_&datas.
            base=sloan.&datas._&lastgeo._var
			force;
run;
proc append data=Aa_var_list_&datas.
            base=sloan.&datas._&lastgeo._var
			force;
run;
proc append data=Aa_var_num_list_&datas.
            base=sloan.&datas._&lastgeo._var
			force;
run;


%mend;
%dcal;
