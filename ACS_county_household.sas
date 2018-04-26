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
%let datas=household;




%macro ss_cross_a;

data aa; 
  set cross.puma2000tocounty2014;
  afact1 = afact*1;
  state1=state*1;
  puma1=puma2K*1;
run;


%do year=2005 %to 2011;

proc sql;

create table hhousehold_&year. as
select 
   a.*
  ,b.county14  as county14
  ,b.afact1 as afact1

from householda_&year. a 
inner join  aa b
on (a.State =b.state1 and a.puma = b.puma1)
;

quit;

data household_&year.;
    set hhousehold_&year.;
	  afact= afact1*hhwt;
run;

%end;

%mend ;


/***********************/

%macro ss_cross_b;

data aa; 
  set cross.puma2010tocounty2014;
  afact1 = afact*1;
  state1=state*1;
  puma1=puma12*1;
run;


%do year=2012 %to 2015;

proc sql;

create table hhousehold_&year. as
select 
   a.*
  ,b.county14  as county14
  ,b.afact1 as afact1

from householdA_&year. a 
inner join  aa b
on (a.State =b.state1 and a.puma = b.puma1)
;



quit;

data household_&year.;
    set hhousehold_&year.;
	  afact= afact1*hhwt;
run;



%end;


%mend ;


/***cat. variables ***/

/***variables ends with 1 or 2 are created by urban
    vacancy rate provided

****/


/*******************************************/


%LET CAT_HOUSEHOLD=SEX_HH AGE1_HH RACE1_HH CITIZEN_HH EDUC_HH  EMPSTAT_HH
                        COMMUSE  OWNERSHP MULTGEN NCHILD NCHLT5 NFAMS1 NCOUPLES1  NSUBFAM1;

%LET NUME_HOUSEHOLD=AGE_HH HHINCOME FAMSIZE ;


; 
%LET CROSS_CAT_HOUSEHOLD = SEX_HH AGE2_HH RACE1_HH CITIZEN_HH EDUC1_HH  EMPSTAT_HH 
                           COMMUSE  OWNERSHP  MULTGEN 
						NFAMS1 NCHILD1 NCOUPLES1  NSUBFAM1;


%LET CROSS_NUM_HOUSEHOLD=AGE_HH HHINCOME FAMSIZE  ;



%LET CAT_CROSS_HOUSEHOLD1= SEX_HH AGE2_HH RACE1_HH CITIZEN_HH EDUC1_HH  EMPSTAT_HH 
                           COMMUSE  OWNERSHP MULTGEN
						   NFAMS1 NCOUPLES1 ;


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

  value subfamily_f  
                low -1 ="Low_1"
                2 -high ="2_High" ;

  value couple_f  
                low -0 ="Low_0"
                1 ="1" 
                2= "2"
                3 -high ="3_High" ;
  

  value builtyr_f  
                low -1 ="Low_39"
                2 ="40_49" 
                3= "50_59"
                4 = "60_69"
                5 ="70_79" 
                6= "80_89"
                7,8 = "90_99"
                9 ="00_04" 
                10,11,12,13,14= "05_09"
                15-high = "10_High"
;
value proptx_f

Low-11	=	"Low-499"
12-21	=	"500-999"
22-31	=	"1000-1999"
32-41	=	"2000-2999"
42-51	=	"3000-3999"
52-62	=	"4000-4999"
63-high	=	"5000-high"
;

value educ_f


Low-0	=	"Low-No"
1-2	=	"1_8"
3-6	=	"9_12"
7-9	=	"C1_C3"
10-high	="C4_High"
;

value VEHICLES_f

low -0 = "Low_0"
1="1"
2="2"
3="3"
4-high="4_High"
;



value bedrooms_f

low-0 = "Low_0"
1="1"
2="2"
3="3"
4="4"
5-high="5_high"
;





value ROOMS_f
  Low-0 = "Low_0"
  1 = "1"
  2 = "2"
  03 = "3"
  04 = "4"
  05 = "5"
  06 = "6"
  07 = "7"
  08 = "8"
  9-high = "9-High"
  
;



value NCHILD_f
  Low-0 = "Low_0"
  1 = "1"
  2 = "2"
  3 = "3"
  4 = "4"
  5-high = "5_High"
;
 
 
run;



/** Household type variables **************/

%macro dyear;

%do i=2005 %to 2015;
 data householda_&i.;
    set ipums.full_2001_2015(where=(pernum=1 and year=&i.));

    if gq  = 1 or gq=2;

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
	nfams1=put(nfams, family_f.);
	NCHILD1=put(NCHILD, NCHILD_f.);

	ncouples1=put(ncouples, couple_f.);
    NSUBFAM1= put(NSUBFAM, subfamily_f.);
    proptx1= put(proptx99, proptx_f.);	
	EDUC1 =put(EDUC, educ_f.);
    VEHICLES1=put(VEHICLES,VEHICLES_f.);
    BUILTYR1 = put(BUILTYR2, builtyr_f.);
    BEDROOMS1 = put(BEDROOMS, BEDROOMS_f.);
    ROOMS1 = put(ROOMS, ROOMS_f.);
	sex_HH = sex;
	age1_HH = age1;
	race1_HH = race1;
	citizen_HH = citizen ;
    EDUC_HH = EDUC;
    EDUC1_HH = EDUC1;
    EMPSTAT_HH = EMPSTAT;
       age2_HH =age2;
	   age_HH= age;

	   /***clear numerical variables ****/

if CONDOFEE <3  then  CONDOFEE = .; 
if COSTELEC <3 or COSTELEC >9990 then COSTELEC=.;
if COSTGAS <3 or COSTGAS >9990 then COSTGAS=.;
if COSTWATR <3 or COSTWATR >9990 then COSTWATR=.;
if MORTAMT1 <3  then MORTAMT1=.;
if MORTAMT2 <3  then MORTAMT2=.;
if OWNCOST <3 or OWNCOST >9990 then OWNCOST=.;
if PROPINSR <3  then PROPINSR=.;
if RENT <3 or RENT >9990 then RENT=.;
if RENTGRS <3 or RENTGRS >9990 then RENTGRS=.;
if VALUEH <3 or VALUEH >9999990 then VALUEH=.;


state = statefip;



keep year STATE PUMA hhwt &cat_household. &nume_household. 

&CROSS_CAT_HOUSEHOLD.  
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
