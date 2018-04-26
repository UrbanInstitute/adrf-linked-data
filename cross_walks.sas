/*****************************************************
PUMA 2000 is valid from 2005 through 2011 ACS Data
PUMA 2010 is valid for 2012, 2013, 2014 and 2015 ACS Data
Census Tract
*****************************************************/
libname hmda "K:\Housefin3\Monthly\HMDA New Census Tract";
libname hmdaorg "K:\Housefin3\Monthly\HMDA New Census Tract\originated\";
libname pj1 "J:\housefin2\sloan";
libname databuf "K:\Housefin3\Monthly\databuffet\Median Family Income";
libname acspums "K:\Housefin3\Monthly\Census\ACSPUMS\";
libname cross "K:\Housefin3\Monthly\cross-walks";
filename pjport 'J:\housefin2\interest rate\haicc';

/***************************************

Import census 2000 to PUMA 2010 data



**************************************/

  data cross.census2000Topuma2000   ;
 infile 'K:\Housefin3\One_Time\cross-walks\Census 2000 to PUMA 2000.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=3 ;
informat county $8. ;
 informat tract $19. ;
informat state $12. ;
 informat puma5 $7. ;
 informat stab $19. ;
 informat cntyname $12. ;
  informat pop2k $24. ;
 informat afact $29. ;
   format county $8. ;
 format tract $19. ;
  format state $12. ;
 format puma5 $7. ;
  format stab $19. ;
 format cntyname $12. ;
     format pop2k $24. ;
     format afact $29. ;
  input
          county $
          tract $
          state $
          puma5 $
           stab $
           cntyname $
           pop2k $
           afact $;
run;

/***************************************

Import census 2010 to cbsa 2013 data


**************************************/

  data cross.census2010Tocbsa2013     ;
  infile 'K:\Housefin3\One_Time\cross-walks\Census 2010 to CBSA 2013.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=3 ;
 informat county $8. ;
 informat tract $12. ;
 informat cbsa $7. ;
 informat cntyname $12. ;
 informat cbsaname $27. ;
 informat pop10 $24. ;
  informat afact $28. ;
  format county $8. ;
  format tract $12. ;
  format cbsa $7. ;
  format cntyname $12. ;
 format cbsaname $27. ;
 format pop10 $24. ;
 format afact $28. ;
 input
               county $
              tract $
             cbsa $
          cntyname $
            cbsaname $
           pop10 $
           afact $
    ;
run;


/***************************************

Import puma 2000 to cbsa 2013 data


**************************************/
 data cross.puma2000Tocbsa2013     ;
 infile 'K:\Housefin3\One_Time\cross-walks\puma 2000 to CBSA 2013.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=3;
 informat state $12. ;
informat puma2k $8. ;
informat cbsa $7. ;
 informat stab $19. ;
 informat cbsaname $28. ;
 informat PUMA2kName $14. ;
 informat pop10 $24. ;
  informat afact $29. ;
 format state $12. ;
 format puma2k $8. ;
 format cbsa $7. ;
  format stab $19. ;
  format cbsaname $28. ;
  format PUMA2kName $14. ;
  format pop10 $24. ;
   format afact $29. ;
  input
          state $
             puma2k $
           cbsa $
         stab $
          cbsaname $
          PUMA2kName $
          pop10 $
           afact $
   ;
run;


/***************************************

Import puma 2010 to cbsa 2013 data

**************************************/
    data cross.puma2010Tocbsa2013     ;
  infile 'K:\Housefin3\One_Time\cross-walks\PUMA 2010 to CBSA2013.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=3 ;
  informat state $12. ;
 informat puma12 $8. ;
  informat cbsa $7. ;
  informat stab $19. ;
  informat cbsaname $34. ;
  informat PUMAname $78. ;
   informat pop10 $24. ;
  informat afact $29. ;
  format state $12. ;
  format puma12 $8. ;
   format cbsa $7. ;
    format stab $19. ;
   format cbsaname $34. ;
      format PUMAname $78. ;
    format pop10 $24. ;
    format afact $29. ;
   input
          state $
           puma12 $
            cbsa $
            stab $
           cbsaname $
           PUMAname $
            pop10 $
             afact $
    ;
run;


   data cross.census2010Topuma2010    ;
    %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
     infile 'K:\Housefin3\One_Time\cross-walks\Census 2010 to puma2010.csv'  delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=3 ;
       informat county $8. ;
       informat tract $12. ;
       informat state $12. ;
       informat puma12 $8. ;
       informat stab $19. ;
        informat cntyname $12. ;
       informat PUMAname $56. ;
        informat pop10 $24. ;
        informat afact $30. ;
       format county $8. ;
       format tract $12. ;
        format state $12. ;
      format puma12 $8. ;
       format stab $19. ;
        format cntyname $12. ;
       format PUMAname $56. ;
        format pop10 $24. ;
       format afact $30. ;
    input
                county $
                 tract $
               state $
                 puma12 $
                stab $
                cntyname $
                PUMAname $
                pop10 $
                afact $
     ;
     if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
     run;






     
proc sql;
create table tt as
select a.county
      ,a.tract
	  ,a.state
	  ,a.puma5
	  ,a.stab
	  ,a.cntyname
	  ,a.pop2K
	  ,a.afact as factor_c2Ktop2K
      ,b.cbsa as cbsa2013
	  ,b.cbsaname as cbsa2013_name
	  ,b.pop10
	  ,b.afact as factor_p2Ktom13

from cross.census2000topuma2000 as a
inner join     cross.puma2000tocbsa2013  as b
on a.puma5=b.puma2K and a.state=b.state and a.county = b.;

quit;

data cross.census2000tocbsa2013;
   set tt;
   if cbsa2013 NE "";
   afact = factor_c2Ktop2K * factor_p2Ktom13;
run;



proc sql;

create table aa as
select 
   a.county 
  ,a.tract
  ,a.state
  ,a.puma5 as puma00
  ,a.afact as afact1
  ,b.puma12
  ,b.afact as afact2

from              cross.census2000topuma2000 a 
inner join          cross.puma2000topuma2010 b
on (a.state =b.state and a.puma5 = b.puma2K)
;

quit;





data cross.census2000topuma2010;
   set aa;
   afact=afact1*afact2;
   drop afact1 afact2;
run;

/*********/


proc sql;

create table aa as
select 
   a.county 
  ,a.tract
  ,a.state
  ,a.puma12 as puma12
  ,a.afact as afact1
  ,b.county14
  ,b.afact as afact2



from                cross.census2000topuma2010 a 
inner join          cross.puma2012tocounty2014 b
on (a.state =b.state and a.puma12 = b.puma12)
;

quit;

data cross.census2000tocounty2014 ;
   set  aa;
   afact=afact1*afact2;
   drop afact1 afact2;
run;


/********************************/


proc sql;

create table aa as
select 
   a.county 
  ,a.tract
  ,a.state
  ,a.puma12 as puma12
  ,a.afact as afact1
  ,b.county14
  ,b.afact as afact2



from                cross.census2010topuma2010 a 
inner join          cross.puma2012tocounty2014 b
on (a.state =b.state and a.puma12 = b.puma12)
;

quit;

data cross.census2010tocounty2014 ;
   set  aa;
   afact=afact1*afact2;
   drop afact1 afact2;
run;


/*******************************/



proc sql;

create table aa as
select 
   a.state 
  ,a.puma2K
  ,a.puma12
  ,a.afact as afact1
  ,b.cbsa
  ,b.afact as afact2



from                cross.puma2000topuma2012 a 
inner join          cross.puma2010tocbsa2013 b
on (a.state =b.state and a.puma12 = b.puma12)
;

quit;

data cross.puma2000tocbsa2013 ;
   set  aa;
   afact=afact1*afact2;
   drop afact1 afact2;
run;


/****************************************/


proc sql;

create table aa as
select 
   a.state 
  ,a.puma2K
  ,a.puma12
  ,a.afact as afact1
  ,b.county14
  ,b.afact as afact2



from                cross.puma2000topuma2012     a 
inner join          cross.puma2012tocounty2014 b
on (a.state =b.state and a.puma12 = b.puma12)
;

quit;

data cross.puma2000tocounty2014 ;
   set  aa;
   afact=afact1*afact2;
   drop afact1 afact2;
run;


/************
census 2000 to census 2010 data is from Chris 

by Geolytics for the NCDB
********/



%let dirname1 = K:\Housefin3\One_Time\cross-walks\Weight;

filename dirlist pipe "dir /B &dirname1\*.csv";



data dirlist1;
  length fname $256;
  infile dirlist length=reclen;
  input fname $varying256. reclen;
  run;

***************************************************;

/* Import data */
data aa (drop=fname);
  set dirlist1;
  filepath = "&dirname1\"||fname;
infile s filevar = filepath length=reclen  delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2  end=done;

  do while(not done);
   
      
     informat AREAKEY0 best32.  AREAKEY1 best32.  AREA0 best32. WEIGHT best32. ;
     format AREAKEY0 best12.  AREAKEY1 best12.  AREA0 best12.  WEIGHT best12. ;
     input
                  AREAKEY0  AREAKEY1 AREA0  WEIGHT
;


    output;
  end;
run;

data dd1;
  set aa;

	 if int(areakey0 /10000000000) >0 then county2k =  put(int(areakey0 /1000000),$5.);
	else  county2k = cat('0', put(int(areakey0 /1000000),$4.));
   tracta= put(mod(areakey0 ,1000000),$6.);
   tract2K=cats( substr(put(input(tracta,best6.),z6.), 1, 4),'.', substr(put(input(tracta,best6.),z6.), 5, 6));

   	 if int(areakey1 /10000000000) >0 then county10 =  put(int(areakey1 /1000000),$5.);
	else  county10 = cat('0', put(int(areakey1 /1000000),$4.));
   tracta= put(mod(areakey1 ,1000000),$6.);
   tract10=cats( substr(put(input(tracta,best6.),z6.), 1, 4),'.', substr(put(input(tracta,best6.),z6.), 5, 6));
   drop tracta;
run;


data cross.census2000tocensus2010 ;
   set  dd1;
   afact=weight*1;
run;

    data cross.census2010tozip2010    ;
    %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
     infile 'K:\Housefin3\One_Time\cross-walks\Census2010tozip2010.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=3;
      informat county $8. ;
         informat tract $12. ;
         informat zcta5 $28. ;
         informat cntyname $12. ;
         informat zipname $17. ;
         informat pop10 $24. ;
         informat afact $29. ;
         format county $8. ;
         format tract $12. ;
         format zcta5 $28. ;
         format cntyname $12. ;
         format zipname $17. ;
         format pop10 $24. ;
         format afact $29. ;
      input
                  county $
                  tract $
                  zcta5 $
                  cntyname $
                  zipname $
                  pop10 $
                  afact $
      ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;



     data cross.puma2012tocensus2010    ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
    infile 'K:\Housefin3\One_Time\cross-walks\puma2010tocensus2010.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=3 ;
        informat state $12. ;
      informat puma12 $8. ;
       informat county $8. ;
      informat tract $12. ;
      informat stab $19. ;
      informat cntyname $13. ;
       informat PUMAname $61. ;
        informat pop10 $24. ;
        informat afact $30. ;
        format state $12. ;
      format puma12 $8. ;
       format county $8. ;
       format tract $12. ;
       format stab $19. ;
       format cntyname $13. ;
      format PUMAname $61. ;
       format pop10 $24. ;
       format afact $30. ;
    input
                state $
               puma12 $
                county $
               tract $
               stab $
               cntyname $
              PUMAname $
               pop10 $
                afact $
    ;
    if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
     run;


    data cross.puma2000tozip2010    ;
     %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile 'K:\Housefin3\One_Time\cross-walks\puma2000tozip2010.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=3 ;
      informat state $12. ;
       informat puma2k $8. ;
       informat zcta5 $28. ;
        informat stab $19. ;
        informat zipname $19. ;
        informat PUMA2kName $14. ;
       informat pop10 $24. ;
       informat afact $30. ;
       format state $12. ;
      format puma2k $8. ;
       format zcta5 $28. ;
       format stab $19. ;
      format zipname $19. ;
       format PUMA2kName $14. ;
       format pop10 $24. ;
       format afact $30. ;
    input
               state $
               puma2k $
               zcta5 $
              stab $
               zipname $
              PUMA2kName $
                pop10 $
                afact $
    ;
   if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
    run;



   data cross.puma2000tocensus2010    ;
     %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
    infile 'K:\Housefin3\One_Time\cross-walks\puma 2000 to census2010.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=3 ;
      informat state $12. ;
       informat puma2k $8. ;
     informat county $8. ;
      informat tract $12. ;
      informat stab $19. ;
     informat cntyname $15. ;
     informat PUMA2kName $14. ;
    informat pop10 $24. ;
     informat afact $30. ;
    format state $12. ;
    format puma2k $8. ;
   format county $8. ;
    format tract $12. ;
   format stab $19. ;
    format cntyname $15. ;
    format PUMA2kName $14. ;
    format pop10 $24. ;
      format afact $30. ;
    input
             state $
           puma2k $
           county $
           tract $
            stab $
          cntyname $
           PUMA2kName $
          pop10 $
         afact $
 ;
   if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
    run;

/*********************************/

	proc sql;

create table aa as
select 

  a.county2K
  ,a.tract2K
  ,a.afact as afact1
  ,b.zcta5 as zip10
  ,b.afact as afact2



from                cross.census2000tocensus2010     a 
inner join          cross.census2010tozip2010         b
on (a.county10 =b.county and a.tract10 = b.tract)
;

quit;

data cross.census2000tozip10 ;
   set  aa;
   afact=afact1*afact2;
   drop afact1 afact2;
run;


/***************/

data cross.puma2010tozip2010    ;
  %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
  infile 'K:\Housefin3\One_Time\cross-walks\puma2010tozip2010.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=3 ;
    informat state $12. ;
     informat puma12 $8. ;
      informat zcta5 $28. ;
       informat stab $19. ;
     informat zipname $19. ;
       informat PUMAname $61. ;
      informat pop10 $24. ;
   informat afact $30. ;
      format state $12. ;
      format puma12 $8. ;
     format zcta5 $28. ;
      format stab $19. ;
      format zipname $19. ;
        format PUMAname $61. ;
     format pop10 $24. ;
     format afact $30. ;
    input
                 state $
               puma12 $
               zcta5 $
                stab $
                zipname $
                PUMAname $
                pop10 $
                 afact $
;
     if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
 run;
