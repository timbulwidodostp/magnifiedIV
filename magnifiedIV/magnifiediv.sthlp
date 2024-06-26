{smcl}
{* *! version 1.2.2  15may2018}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Author" "examplehelpfile##author"}{...}
{viewerjumpto "References" "examplehelpfile##references"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:magnifiedIV}

{phang}
{bf:magnifiedIV} {hline 2} magnifiedIV to run a group or weight-based magnified instrumental variables estimator


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:magnifiedIV} {it:estimator} {help depvar} [{help varlist:varlist1}] ({help varlist:varlist2} = {help varlist: varlist_iv}) [{help if}] [{help in}] [{help weight}], grouping({help string}) [{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt grouping(string)}} {cmd: groupsearch}, {cmd: groupCF}, or a {help varlist} with one grouping variable for each instrument in {help varlist: varlist_iv}, indicating the method to be used to create grouping variables to interact with the instrument(s), or those variables themselves if already created. {p_end}
{synopt:{opt est(string)}} either {cmd:group}, {cmd:weight}, or {cmd:both} to indicate whether the grouped, weighted, or group-weighted version of the estimator should be used. Defaults to {cmd:est(group)}.{p_end}
{synopt:{opt groupformula(string)}} is for use with {cmd:grouping(groupsearch)} or {cmd:grouping(groupCF)}. A set of {help varlist}s, one for each instruments (in order) in {help varlist: varlist_iv}, separated by commas. These {help varlist}s are the covariates for use in {help groupsearch} or {help groupCF}. By default, uses {help varlist: varlist1} for each instrument. {p_end}
{synopt:{opt ivfor(varlist)}} specifies, in the same order as {help varlist: varlist_iv}, which endogenous variable each excluded instrument is "for" and so will be used when creating groupings for that instrument. Has no effect with only one endogenous variable, but is necessary if the model is overidentified. If there are multiple endogenous variables and the model is just-identified, this will default to the same order as {help varlist: varlist2}. {p_end}
{synopt:{opt ngroups(integer)}} if using {cmd:grouping(groupsearch)} or {cmd:grouping(groupCF)}, the number of groups to split the data into. Defaults to 4.{p_end}
{synopt:{opt p(.25)}} if using {cmd:est(weight)} or {cmd:est(both)}, the power to raise the individualized F-statistic generated by {help ownpersonalssesus} to for use as a weight. Defaults to .25 to get a similar weighting scheme as {cmd:est(group)} does. Set to -.25 to recover the average treatment effect among compliers (under monotonicity and very good estimates of first-stage treatment effect heterogeneity). {p_end}
{synopt:{opt silent}} Suppress progress reports from {cmd:grouping(groupsearch)} or {cmd:grouping(groupCF)}.{p_end}
{synopt:{opt groupsearchopts}} Options to pass to {help groupsearch}. Note that {cmd:g} cannot be specified if there is more than one instrument.{p_end}
{synopt:{opt groupCFopts}} Options to pass to {help groupCF}. Note that {cmd:g} cannot be specified if there is more than one instrument.{p_end}
{synopt:{opt ivregressopts}} Options to pass to {help ivregress}, which is the command used to run IV after the groups/weights are created.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
The regression formula syntax {it:estimator} {help depvar} [{help varlist:varlist1}] ({help varlist:varlist2} = {help varlist: varlist_iv}) matches that of {help ivregress}. See {help ivregress: help ivregress}. The only difference is that {help varlist: varlist_iv} does not support factor variables, time series, or interactions ({cmd: .} or {cmd: #}) and so these must be made manually ahead of time.
{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed but only with {cmd:est(group)}, and some may not be combined with some {cmd:ivregressopts} settings; see {help weight} and {help ivregress}.


{marker description}{...}
{title:Description}

{pstd}
This command runs the magnified instrumental variables estimator as in Huntington-Klein (2019) "Instruments with Heterogeneous Effects: Monotonicity, Bias, and Localness", of either the group-based or weighted variety.

{pstd}
This function will: (1) Use {help groupsearch}, {help groupCF}, or a supplied grouping variable, as requested, to find appropriate groupings over which the effects of the instruments vary. (2) If the weighted version of Magnified IV is requested ({cmd: est(weight)} or {cmd: est(both)}), uses {help factorpull} to estimate effects within each group and calculate sample weights for each observation, which are the first-stage F statistic that would be achieved if all observations in the sample had the same instrument effect as that observation, to the power {cmd:p}, then runs {help ivregress} with those weights. (3) If the grouped version of Magnified IV is requested ({cmd: est(group)} or {cmd: est(both)}), runs {help ivregress} with those groups included as controls and interacted with the instrument.

{pstd}
You can get more control over the estimation process (say, using a different command than {help ivregress} or using a different weighting scheme) by making use of the constituent parts to get groups or weights and then setting the interaction or weights yourself.

{pstd}
One instance in which you may want to get more control over the estimation process is if you have multiple endogenous variables. With multiple endogenous variables and multiple instruments, there are lots of different ways to determine groupings. The {cmd: magnifiedIV} function will only allow one grouping per instrument, and if you want {help groupsearch} or {help groupCF} to determine that grouping for you, it requires that each instrument be "for" only one of the endogenous variables and make groupings on that basis. So with multiple excluded instruments that are each "for" multiple endogenous variables, you will want to do something by hand.

{pstd}
It is recommended that you read Huntington-Klein (2019) before using this command to understand which versions appear to work well, and what the Super-Local Average Treatment Effect (SLATE) is.

{marker author}{...}
{title:Author}

Nick Huntington-Klein
nhuntington-klein@fullerton.edu

{marker references}{...}
{title:References}

{phang} Huntington-Klein, N. (2019) Instruments with Heterogeneous Effects: Bias, Monotonicity, and Localness. CSU Fullerton Economics Working Paper 2019/006. {browse "https://business.fullerton.edu/department/economics/assets/CSUF_WP_6-19.pdf?_=0.4520744169447609":PDF}.


{marker examples}{...}
{title:Examples}

{phang} First, repeat the ivregress standard example.

{phang}{cmd:. use http://www.stata-press.com/data/r9/hsng2.dta, clear}

{phang}{cmd:. ivregress 2sls rent pcturban (hsngval = faminc i.region), small first}

{phang} Now do it with {cmd: magnifiedIV}, using {help groupsearch} to make groups. Note that currently there is not support for {cmd i.} in the instruments list, so they must be made into dummies by hand.

{phang}{cmd:. xi i.region, pre(r_)}

{phang}{cmd:. magnifiedIV 2sls rent pcturban (hsngval = faminc r_*), grouping(groupsearch) ivregressopts(small first)}

