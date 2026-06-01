data sc1980;
	input Group events total;
	label Group  = 'Dose group (score)'
		events = 'Survivors'
		total  = 'Animals per group';
	datalines;
0 11 18
1 27 42
2 42 58
3 53 66
4 11 12
;
run;

title1 'Verification Cochran-Armitage Trend Test';
footnote 'Username: &SYSUSERID | Run Date: &SYSDATE9 | &SYSPROCESSID';

%macro analyze(dsn, group, events, total, side);
	title2 "Variable: &events | Side: &side";

	%if &side = 2 %then
		%do;
			%let trend_label = Two-Sided;
		%end;
	%else %if &side = L %then
		%do;
			%let trend_label = One-Sided (Lower);
		%end;
	%else %if &side = U %then
		%do;
			%let trend_label = One-Sided (Upper);
		%end;

	/* Reshape per-animal counts to binary outcome format*/
	data _freq;
		set &dsn;
		outcome = 1;
		count = &events;
		output;
		outcome = 0;
		count = &total - &events;
		output;
		keep &group outcome count;
	run;

	ods exclude CrossTabFreqs;
	ods output TrendTest = _ca_parms;

	proc freq data = _freq;
		tables &group * outcome / trend;
		weight count;
	run;

	ods select all;

	/* Extract Z statistic and p-values by name */
	proc sql noprint;
		select nValue1 into :CA_Z    from _ca_parms where upcase(Name1) = '_TREND_';
		select nValue1 into :CA_PONE from _ca_parms where upcase(Name1) = 'PL_TREND';
		select nValue1 into :CA_PTWO from _ca_parms where upcase(Name1) = 'P2_TREND';
	quit;

	/* Build clean results row with selected p-value */
	data ca_results;
		length variable $32 direction $20;
		variable  = "&events";
		direction = "&trend_label";
		z         = input(symget('CA_Z'),    best.);
		p_one     = input(symget('CA_PONE'), best.);
		p_two     = input(symget('CA_PTWO'), best.);

		%if &side = 2 %then
			%do;
				selected_p = p_two;
			%end;
		%else %if &side = L %then
			%do;
				selected_p = p_one;
			%end;
		%else %if &side = U %then
			%do;
				selected_p = 1 - p_one;
			%end;

		label variable   = 'Variable'
			direction  = 'Test Direction'
			z          = 'Z Statistic'
			selected_p = 'P-Value';
		keep variable direction z selected_p;
	run;

	ods select all;
	ods results;

	proc print data = ca_results noobs label;
	run;

%mend analyze;

%analyze(sc1980, Group, events, total, U);