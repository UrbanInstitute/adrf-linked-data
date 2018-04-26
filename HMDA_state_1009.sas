/***************************************************
  This script create variables for the sloan project--HMDA 



Basic notes: Lien info and rtspread are not included


*****************************************************/

libname IPUMS "K:\Housefin3\Monthly\ACS";
libname sloan "J:\housefin2\sloan";
libname hmda "K:\Housefin3\Monthly\HMDA\HMDA Originated Loans";
libname cross "K:\Housefin3\Monthly\cross-walks";
libname hmda_1 "K:\Housefin3\Monthly\HMDA";

/*****************************************************
  Variables List: add variables in  

*****************************************************/

/***variables ends with 1 or 2 are created by urban
    vacancy rate provided

****/

%LET CAT_HMDA=lien AGENCY APPRAC appethn APPRAC1 APPSEX COAPRAC coapethn COAPSEX LOANTYPE OCCUPANC PRCH_TYP PRCH_TYP1 PURPOSE;


%LET NUME_HMDA=AMOUNT INCOME;


%LET CROSS_CAT_HMDA = APPRAC1 APPSEX LOANTYPE OCCUPANC PRCH_TYP1 PURPOSE;


%LET CROSS_NUM_HMDA=AMOUNT INCOME;


%LET CAT_CROSS_HMDA1= APPRAC1 APPSEX LOANTYPE OCCUPANC PRCH_TYP1 PURPOSE;



/*****change the geo level here *****/

%let geo_level = year state ;
%let geolist ="year", "state";
%let lastgeo= state;



/**********************************
urban's categories for numeric variables
**********************************/


proc format;

  value race_f  
				 1 = "B"
                 2 = "H"
				 3 = "W"
				 4 = "AS"
				5-high= "O"
;

  value $TYP_f  
				 '1' = "FNMA"
                 '2' = "GNMA"
				 '3' = "FHLMC"
				 OTHER = "OTHER"
;


run;

/** HMDA type variables 
 transfer old version variables into new version variables
**************/



%macro dyearr;

%do i=2001 %to 2003;
 data HMDA_&i.;
    set hmda.HMDA&i.(rename = (
										AMOUNT =AMOUNT1 
                                        INCOME =INCOME1
										PRCH_TYP=PRCH_TYP2
										apprac=apprac2

                                        ));


	/*******create categories to incorporate the version change *****/

   if apprac2 = '1' then do; appethn='2' ;apprac = '1'  ; end;
else    if apprac2 = '2' then do; appethn='2'; apprac = '2' ;  end;
else    if apprac2 = '3' then do; appethn='2'; apprac = '3' ;  end;
else    if apprac2 = '4' then do; appethn='1'; apprac = '7' ;  end;
else    if apprac2 = '5' then do; appethn='2' ;apprac = '5' ;  end;
else    if apprac2 = '6' then do; appethn='2' ;apprac = '7' ;  end;
else    if apprac2 = '7' then do; appethn='3' ;apprac = '6'  ; end;
else    if apprac2 = '8' then do; appethn='4' ;apprac = '7' ;  end;

   if coapprac2 = '1' then do; coapethn='2'; coapprac = '1' ;  end;
else    if coapprac2 = '2' then do; coapethn='2'; coapprac = '2'  ; end;
else    if coapprac2 = '3' then do; coapethn='2'; coapprac = '3' ;  end;
else    if coapprac2 = '4' then do; coapethn='1' ;coapprac = '7' ;  end;
else    if coapprac2 = '5' then do; coapethn='2'; coapprac = '5' ;  end;
else    if coapprac2 = '6' then do; coapethn='2'; coapprac = '7' ;  end;
else    if coapprac2 = '7' then do; coapethn='3'; coapprac = '6'  ; end;
else    if coapprac2 = '8' then do; coapethn='4' ;coapprac = '7'  ; end;


    PRCH_TYP=PRCH_TYP2;
    if PRCH_TYP2 ='5' then PRCH_TYP='6';
	PRCH_TYP1=put(PRCH_TYP, $TYP_f.);  
	AMOUNT =AMOUNT1 *1;
    INCOME =INCOME1 *1;

length county_state $5.0;
county_state = cat(state,county);
  afact =1;
                if apprac2='3' then raceeth=1;
                else if apprac2='4' then raceeth=2;
                else if apprac2='5' then raceeth=3;
                else if apprac2='2' then raceeth=4;
                else if apprac2='1' then raceeth=5;
                else  raceeth=9;
	            apprac1=put(raceeth, race_f.);  

Lien = "1"; 

run;

%end;

%mend;
%dyearr;


%macro dyear;

%do i=2004 %to 2015;

 data HMDA_&i.;
    set hmda.HMDA&i.( rename = (
										AMOUNT =AMOUNT1 
                                        INCOME =INCOME1
                                        ));
    

	/*******create categories *****/
	PRCH_TYP1=put(PRCH_TYP, $TYP_f.);


	AMOUNT =AMOUNT1 *1;
    INCOME =INCOME1  *1;

length county_state $5.0;
county_state = cat(state,county);


                if appethn='2' and (apprac = "3" or apprac2 = "3" or apprac3 = "3" or apprac4 = "3" or apprac5 = "3") then raceeth = 1;    

                else if appethn = "1" then raceeth = 2; 

                else if 
                (apprac notin ("1","2","3","4") and apprac2 notin ("1","2","3","4") 
                and apprac3 notin ("1","2","3","4") and apprac4 notin ("1","2","3","4") 
                and apprac5 notin ("1","2","3","4") and appethn = "2") and
                (apprac="5" or 
                apprac2="5" or 
                apprac3="5" or 
                apprac4="5" or 
                apprac5="5")
                then raceeth = 3; 

                else if (apprac in ("2","4") or 
                apprac2 in ("2","4") or 
                apprac3 in ("2","4") or 
                apprac4 in ("2","4") or 
                apprac5 in ("2","4"))
                then raceeth=4; 

                else if (apprac="1" or 
                apprac2="1" or 
                apprac3="1" or 
                apprac4="1" or 
                apprac5="1")
                then raceeth=5; 

                else raceeth=9; 

	            apprac1=put(raceeth, race_f.);   

  afact =1;

run;
  


%end;

%mend;
%dyear;




/*************clear up the cat******/


%macro dyear;

%do i=2001 %to 2015;

 data HMDA_&i.;
    set HMDA_&i.;
    if agency in (" ","8") then delete;
    if apprac in (" ","0") then delete;
    if appsex in (" ","0") then delete;
	if coaprac in (" ","0")then delete;
 	if coapsex in (" ","0","6")then delete;
	if loantype in (" ","0")then delete;
	if occupanc in (" ")then delete;
    if prch_typ in (" ")then delete;
	if coaprac in (" ")then delete; 
	if purpose in (" ","0")then delete;


run;
  


%end;

%mend;
%dyear;
/**************************************
 HMDA:  get stsate level results -----cat. variables 
**************************************/


/*****macro for calculation ******/



%macro m1 (varlist);
%local i next ;
%let i=1;
%do i=1 %to %sysfunc(countw(&varlist));
  %let next=%scan(&varlist,&i);
         proc freq data=HMDA_&year. noprint ;
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
   data bb_cat_&year._HMDA;
      set &next._&year.;
	run;
%end;
  %else %do;
    data bb_cat_&year._HMDA;
      merge bb_cat_&year._HMDA(in=a) &next._&year.(in=b);
	  by &geo_level.;
	run;
%end;

/*****variable list *****/
proc freq data=HMDA_&year. noprint ;
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

%do year=2001 %to 2015;
proc delete data =var_list_&year.; run;

proc sort data= HMDA_&year.;
	  by &geo_level.;
run;

 
%m1(&cat_HMDA.);

proc sort data= bb_cat_&year._HMDA;
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






data aa_var_list_HMDA;
  merge var_list_2001 - var_list_2015;
  by variable_name;
run;






/*****macro for cross-tab calculation ******/

%macro twoway(varlist);
%local i j;
%do i=1 %to %sysfunc(countw(&varlist,%str( )))-1;
     %do j=&i+1 %to %sysfunc(countw(&varlist,%str( )));
          %let next1=%scan(&varlist,&i);
		  %let next2=%scan(&varlist,&j);
		proc sort data = HMDA_&year.;
	  by &geo_level.;
	   run;



         proc freq data=HMDA_&year. noprint;
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
   data bb_cat_cross_&year._HMDA;
      set &next1._&next2._&year.;
	run;
%end;
  %else %do;
    data bb_cat_cross_&year._HMDA;
      merge bb_cat_cross_&year._HMDA(in=a) &next1._&next2._&year.(in=b);
	  by &geo_level.;
	run;
%end;

/*****variable list *****/
proc freq data=HMDA_&year. noprint ;
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

%do year=2001 %to 2015;
proc delete data= var_cross_list_&year.; run;
 

%twoway(&cat_cross_HMDA1.);


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

data aa_var_cross_list_HMDA;
  merge var_cross_list_2001 - var_cross_list_2015;
  by variable_name;
  drop year;
run;




                                                                                                                                                                                                                          

/**************************************
 HMDA:  get state level results -----numeric variables 

**************************************/




%macro dcal;

%do year=2001 %to 2015;
				  proc sort data = HMDA_&year.;
                  by &geo_level.;
				  run;



         proc means  data=HMDA_&year. noprint ;
         by &geo_level.;
         weight afact;
		 var &nume_HMDA;
         output out = num_sum  
                    mean (&nume_HMDA.)= p10(&nume_HMDA.)= p25(&nume_HMDA.)= 
					p50(&nume_HMDA.)=   p75(&nume_HMDA.)=  p90(&nume_HMDA.)=  stddev(&nume_HMDA.)= /autoname  
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
%dcal;

data aa_var_num_list_HMDA;
  merge var_2001 - var_2015;
  by variable_name;
run;







/**************************************
 HMDA:  numeric variables * cat. variables  

**************************************/




%macro dd(varlist, cross_num_HMDA);

%local i j next1 next2;

%do i=1 %to %sysfunc(countw(&varlist));
                  %let next1=%scan(&varlist,&i);


    %do j=1 %to %sysfunc(countw(&cross_num_HMDA));

		  %let next2=%scan(&cross_num_HMDA,&j);

				  proc sort data = HMDA_&year.;
                  by &geo_level.  &next1.;
				  run;

                 proc means  data=HMDA_&year. noprint ;
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
   data bb_cross_num_&year._HMDA;
      set &next1._&next2._&year.;
	run;
%end;
  %else %do;
    data bb_cross_num_&year._HMDA;
      merge bb_cross_num_&year._HMDA(in=a) &next1._&next2._&year.(in=b);
	  by &geo_level.;
	run;
%end;

proc sort data=bb_cross_num_&year._HMDA;
	  by &geo_level.;
	run;






/*****variable list *****/
                 proc sort data = HMDA_&year.;
                 by year &next1.;
				 run;

                 proc means  data=HMDA_&year. noprint ;
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


%do year=2001 %to 2015;
proc delete data= cross_num_list_&year.; run;

%dd(&CAT_CROSS_HMDA1., &cross_num_HMDA.);



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

data aa_var_cross_num_list_HMDA;
  merge cross_num_list_2001 - cross_num_list_2015;
  by variable_name;
run;







%macro dcal;
proc delete data =sloan.HMDA_&lastgeo._f; run;
proc delete data=sloan.HMDA_&lastgeo._var; run;


data sloan.HMDA_&lastgeo._f;
    merge bb_:;
	by &geo_level.;
run;


proc append data=Aa_var_cross_list_HMDA
            base=sloan.HMDA_&lastgeo._var
			force;
run;

proc append data=Aa_var_cross_num_list_HMDA
            base=sloan.HMDA_&lastgeo._var
			force;
run;
proc append data=Aa_var_list_HMDA
            base=sloan.HMDA_&lastgeo._var
			force;
run;
proc append data=Aa_var_num_list_HMDA
            base=sloan.HMDA_&lastgeo._var
			force;
run;


%mend;
%dcal;





