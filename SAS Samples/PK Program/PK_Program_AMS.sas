libname pk_xpt xport ""; /* change file path */
libname pc_xpt xport ""; /* change file path */
data pk_raw;
	set pk_xpt.sas;
run;

data pc_raw;
	set pc_xpt.sas;
run;

/* proc template for customizing RTF*/
proc template;
	define style styles.out_style;
		parent = styles.journal;
		style fonts from fonts /
			'TitleFont' = ("Times New Roman",10pt,Bold)
			'TitleFont2' = ("Times New Roman",10pt,Bold)
			'StrongFont' = ("Times New Roman",10pt,Bold)
			'EmphasisFont' = ("Times New Roman",10pt,Italic)
			'FixedEmphasisFont' = ("Times New Roman",10pt,Italic)
			'FixedStrongFont' = ("Times New Roman",10pt,Bold)
			'FixedHeadingFont' = ("Times New Roman",10pt,Bold)
			'BatchFixedFont' = ("Times New Roman",10pt)
			'FixedFont' = ("Times New Roman",10pt)
			'headingEmphasisFont' = ("Times New Roman",10pt,Bold)
			'headingFont' = ("Times New Roman",10pt,Bold)
			'docFont' = ("Times New Roman",10pt);
		style table from table /
			frame=box
			rules=all
			cellpadding=3pt
			cellspacing=0.5pt
			borderwidth=1pt;

		/* header */
		style header from header /
			font_weight=bold
			font_size=10pt
			just=center
			backgroundcolor=white
			borderwidth=1pt
			protectspecialchars=off;
		style data from data /
			font_size=10pt
			borderwidth=1pt
			just=center;

		/* graph */
		style graphfonts from graphfonts /
			'GraphDataFont'=("Times New Roman",10pt)
			'GraphUnicodeFont'=("Times New Roman",10pt)
			'GraphValueFont'=("Times New Roman",10pt)
			'GraphLabelFont'=("Times New Roman",10pt,Bold)
			'GraphTitleFont'=("Times New Roman",10pt,Bold)
			'GraphFootnoteFont'=("Times New Roman",10pt);
	end;
run;

/* macro dose_prop to output RTF style table and log-log regression graph, and linear
plot of each param
macro takes in dataset name, param to be analyzed, alpha level, and output file path*/
%macro dose_prop(dataset, param, alpha, outp);
	/*clean param name*/
	%let clean_param = %sysfunc(compress(&param, , 'kad'));

	/* make rtf path*/
	%let rtf_f = &outp.\TLF_&clean_param..rtf;

	/* clean data, char vs. num */
	data pk_ft;
		set &dataset;
		where PARAM="&param";
		subj=USUBJID;
		dose_num = input(AMT, best.);
		result_num = input(ESTIMATE, best.);
		log_dose= log(dose_num);
		log_result = log(result_num);
	run;

	ods select none;
	ods results off;

	proc mixed data=pk_ft;
		class subj;
		model log_result = log_dose/ddfm=kr;
		random intercept log_dose/subject=subj type=UN gcorr s;
		estimate "Slope of log_dose for &param" log_dose 1/cl alpha=&alpha;
		ods output estimates=est_&clean_param;
		ods output solution=sol_&clean_param;
	run;

	ods select all;
	ods results on;
	ods rtf file="&rtf_f" style=out_style startpage=no;
	title1 "Table: Dose Proportionality Analysis for &param";

	proc print data=est_&clean_param label noobs;
		label
			estimate="slope (B)"
			lower = "Lower 95% CI"
			upper = "Upper 95% CI";
	run;

	proc sgplot data=pk_ft noautolegend;
		inset "Figure: Log-Log Regression of Dose vs. &param";
		scatter x=log_dose y=log_result /group=subj markerattrs=(symbol=circlefilled size=
			8);
		reg x=log_dose y=log_result / clm lineattrs=(thickness=2 color=blue);
		xaxis label="Log Dose";
		yaxis label="Log (&param)";
	run;

	proc sgplot data=pk_ft noautolegend;
		inset "Figure: Linear Plot Dose vs. &param";
		scatter x= dose_num y=result_num / group=subj markerattrs=(symbol=circlefilled
			size=8);
		reg x=dose_num y=result_num / clm lineattrs=(thickness=2 color=blue);
		xaxis label="Dose";
		yaxis label="(&param)";
	run;

	ods rtf close;
%mend dose_prop;

%let outdir = "" /* change file path */

%dose_prop(pk_raw, Cmax, 0.05, &outdir);

/*macro table_pk outputs the summary of pk parameters, macro takes in dataset name,
and output path*/
%macro table_pk(dataset, outp);
	/* make rtf path*/
	%let rtf_f = &outp.\summary_pk.rtf;

	data pk_clean;
		set &dataset;
		subj= USUBJID;
		dose_num = input(AMT, best.);
		result_num = input(ESTIMATE, best.);
		log_dose= log(dose_num);
		log_result = log(result_num);
	run;

	/* calculate summary stats */
	proc means data=pk_clean noprint;
		class Param COHORT;
		var result_num;
		output out=summary_stats
			mean=mean_val
			std=sd_val
			n=n_val;
	run;

	/* build the summary stats table*/
	data pk_table;
		set summary_stats;
		where _TYPE_=3;
		length summary $50;
		summary=cats(put(mean_val, 8.1), "(", put(sd_val, 8.1),") [",n_val,"]");
	run;

	proc sort data=pk_table;
		by Param COHORT;
	run;

	proc transpose data=pk_table out=pk_summary_table(drop=_NAME_);
		by Param;
		id COHORT;
		var summary;
	run;

	/* get unique cohort names*/
	proc sql noprint;
		select distinct COHORT into :cohort_ls separated by ' ' from pk_clean;
	quit;

	%let n_coh = %sysfunc(countw(&cohort_ls, ' '));

	/* make legend for below table */
	ods escapechar='^';
	%let legend_text=;

	%do i=1 %to &n_coh;
		%let cohort_nm=%scan(&cohort_ls, &i, ' ');

		%if &i=1 %then
			%let legend_text=Treatment &cohort_nm:<Label for &cohort_nm>;
		%else %let legend_text=&legend_text ^{newline} Treatment &cohort_nm:<Label for &cohort_nm>;
	%end;

	/* make report */
	options orientation=landscape;
	ods rtf file="&rtf_f" style=out_style;
	title1 "Table: Summary of Pharmacokinetic Parameters";

	proc report data=pk_summary_table;
		columns Param &cohort_ls;
		define Param / "Pharmacokinetic Parameter";

		%do i=1 %to &n_coh;
			%let cohort_nm=%scan(&cohort_ls, &i, ' ');
			define &cohort_nm / "&cohort_nm";
		%end;
	run;

	ods text="&legend_text";
	ods text="Source: Table PK";
	ods rtf close;
%mend table_pk;

%let outdir = "" /* change file path */

%table_pk(pk_raw, &outdir);