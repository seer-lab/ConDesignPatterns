% Scheduler Pattern (a Concurrency Design Pattern) Finder for Java Concurrent Software
% Martin Mwebesa
% UOIT, April 26, 2011

include "Java.Grm"
% include "JavaCommentOverrides.Grm"

define labelM
	'MUTATED
end define

redefine annotation
	[annotation2]
end redefine

define annotation2
   [SPOFF] '@ [reference] [opt '@] [SPON] [opt annotation_value_spec] [NL]
end define

redefine interface_declaration
	[interface_declaration2]
    | [attr labelM] [interface_header] [interface_body]
    | [attr labelM] [NL] /* [stringlit] */ [NL] [interface_header] [interface_body]
end redefine

define interface_declaration2
    [interface_header] [interface_body]
end define

redefine class_declaration
	[class_declaration2]
    | [attr labelM] [class_header] [class_body]
    | [attr labelM] [NL] /* [stringlit] */ [NL] [class_header] [class_body]
end redefine

define class_declaration2
    [class_header] [class_body]
end define

redefine method_declaration
	[method_declaration2]
	| [attr labelM] [method_declaration2]
	| [attr labelM] [NL] /* [stringlit] */ [NL] [method_declaration2]
end redefine

define method_declaration2
    [repeat modifier] [type_specifier] [method_declarator] [opt throws] [method_body]
end define

redefine variable_declaration
	[variable_declaration2]
    | [attr labelM] [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
	| [attr labelM] [NL] /* [stringlit] */ [NL] [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
end redefine

define variable_declaration2
    [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
end define

redefine if_statement
	[if_statement2]
    | 'if '( [expression] ') 
		[statement]
    [opt else_clause]      [NL]
	| [attr labelM]
	'if '( [expression] ') 
		[statement]
    [opt else_clause]      [NL] 
	| [attr labelM] [NL] /* [stringlit] */ [NL]
	'if '( [expression] ') 
		[statement]
    [opt else_clause]      [NL]
end redefine

define if_statement2
    'if '( [expression] ')     
        [statement]
    [opt else_clause]      [NL]
end define

redefine else_clause
	[else_clause2]
    | 'else
 	'{
       [statement]
	'}
end redefine

define else_clause2
    'else
        [statement]
end define

redefine while_statement
	[while_statement2]
    | 'while '( [expression] ') 
	'{
        [statement]     
	'}
 	| [attr labelM] 
	'while '( [expression] ') 
	'{
        [statement]     
	'}
 	| [attr labelM] [NL] /* [stringlit] */ [NL] 
	'while '( [expression] ') 
	'{
		[statement]     
	'}
 	| [attr labelM] [NL] /* [stringlit] */ [NL] 
	'while '( [expression] ') 
	'{
		[NL] /* [stringlit] */ [NL]
		[statement]     
	'}
end redefine

define while_statement2
    'while '( [expression] ') 
        [statement]     
end define

redefine do_statement
	[do_statement2]
    | 'do
	'{
        [statement]
	'}
    'while '( [expression] ') ';  
 	| [attr labelM] 
    'do
	'{
        [statement]
	'}
    'while '( [expression] ') ';  
 	| [attr labelM] [NL] /* [stringlit] */ [NL] 
    'do
	'{
        [statement]
	'}
    'while '( [expression] ') ';  
 	| [attr labelM] [NL] /* [stringlit] */ [NL] 
    'do
	'{
		[NL] /* [stringlit] */ [NL]
        [statement]
	'}
    'while '( [expression] ') ';  
end redefine

define do_statement2
    'do
        [statement]
    'while '( [expression] ') ';  
end define

redefine expression_statement
 	[expression_statement2]
	| [attr labelM] 
	[expression] ';
	| [attr labelM] [NL] /* [stringlit] */ [NL] 
	[expression] ';
end redefine

define expression_statement2
    [expression] ';
end define

redefine synchronized_statement
 	[synchronized_statement2]
	| [attr labelM] 
    'synchronized '( [expression] ')
        [statement]                  [NL]
	| [attr labelM] [NL] /* [stringlit] */ [NL] 
    'synchronized '( [expression] ')
        [statement]                  [NL]
end define

define synchronized_statement2
    'synchronized '( [expression] ')
        [statement]                  [NL]
end define

redefine return_statement
 	[return_statement2]
	| [attr labelM] [NL] /* [stringlit] */ [NL] 
    'return [opt expression] ';      [NL]
end redefine

define return_statement2
    'return [opt expression] ';      [NL]
end define

redefine formal_parameter
 	[formal_parameter2]
	| [attr labelM] 
    [repeat annotation] [opt 'final] [type_specifier] [opt var_arg_specifier] [formal_parameter_name]
end redefine

define formal_parameter2
    [repeat annotation] [opt 'final] [type_specifier] [opt var_arg_specifier] [formal_parameter_name]
end define


function main
	export Counter [number]
		0
	export CountSchedulerClasses [number]
		0
	export preCntSchedulerClasses [number]
		0
	export CountRqObjImplSchOrdInts [number]
		0
	export preCntRqObjImplSchOrdInts [number]
		0
	export CountSchOrdInterfaces [number]
		0
	export preCntSchOrdInterfaces [number]
		0
	export CountProcessorObjs [number]
		0
	export preCntProcessorObjs [number]
		0
	export SchedulerClassIDColl [repeat id]
		_
	export RqObjImplSchOrdIntsColl [repeat id]
		_
	export SchOrdInterfacesIDColl [repeat id]
		_
	export ProcessorObjIDColl [repeat id]
		_
	export ThreadIDCollection [repeat id]
		_
	export schEntThreadIDColl [repeat id]
		_
	export ArrListIDCollection [repeat id]
		_			
	export schCntRunThWaitThArWtRqArEntMth [number]
		0		
	export schClEntMethParamsCount [number]
		0		
	export schClEntThObt1st2nd3rdSychStmtPassed [number]
		0		
	export schClRDS3inObt1stSychStmtfromBLPassed [number]
		0		
	export schCgetIfStmtWLifExpSTMTPassed [number]
		0	
	export schClRDS3inObt3rdSychStmtfromBLPassed [number]
		0		
	export schClfindDoneMthOfSchTransfRDS3Passed [number]
		0	
	export schClisChkRunThdNotCurrThdPassed [number]
		0
	export schClisRunThdAssdNullPassed [number]
		0		
	export schClget3rrdIfStmtDoneifExpSTMTPassed [number]
		0
	export schClgetThirdIfStmtDoneTransfOEC [number]
		0		
 	export schClisRunnThdNotifyAllPassed [number]
		0		
	export schRunningThreadColl [repeat id]
		_
	export schWaitThrArrsColl [repeat id]
		_
	% export schWaitReqArrsColl [repeat id]
		% _
	export schEnterMethColl [repeat id]
		_
	export schDoneMethColl [repeat id]
		_
	export schClEntMethParamIDColl [repeat id]
		_
	export tmpSchThreadID [id]
		_
	export tmpSchCurrThreadID [id]
		_
	export tmpSchWaitThrArrID [id]
		_
	export tmpSchWaitReqArrID [id]
		_
	export tmpSchintID [id]
		_		
	export tmpRunningThdID [id]
		_
	export tmpWaitThrArrID [id]
		_
	export tmpWaitCountID [id]
		_
	% export tmpintID [id]
		% _
	% export tmpsoiID [id]
		% _
	% export tmpsoiLocalID [id]
		% _		
	export procClMethUsingSchParamCnt [number]
		0
	export procClMethUsingSchParamIDColl [repeat id]
		_
		
	replace [program]
        P [program]		
	construct TransformedProgram [stringlit]
		"TransformedForSchedulerPatt.java"
	by
		P [FindSchOrdInterface] [FindRqObjImplSchOrdInts] [findSchedulerClass] [findProcessorClass] 
		[printOutput] [printSchedulerClass] [printRqObjImplSchOrdInts] [printSchOrdInterface] [printProcessorObjs]
		[fput TransformedProgram]
		% P [FindSchOrdInterface] [FindRqObjImplSchOrdInts] [findSchedulerClass] [findProcessorClass] 
		% [printPatternNotFound] [printOutput] [printSchedulerClass] [printRqObjImplSchOrdInts] 
		% [printSchOrdInterface] [printProcessorObjs]
		% [fput TransformedProgram]
end function


function printPatternNotFound
	replace [program]
		P [program]
	
	import Counter [number]
	
	where
		Counter [= 0]
	
	construct InstanceFound [stringlit]
		"*** No instances of Scheduler Pattern found. "
	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	
	by 
		P
end function

% Function print out the number of Scheduler design pattern instances found.
function printOutput
	replace [program]
		P [program]	
	import Counter [number]	
	% where
		% Counter [> 0]	
	construct InstanceFound [stringlit]
		"** Complete instances of Scheduler Pattern found = "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]	
	by 
		P
end function


% Function to print out the Scheduler Class IDs.
% The number of these Scheduler Classes should equal the number of instances printed out in the "printOutput" function.
function printSchedulerClass
	replace [program]
		P [program]	
	import SchedulerClassIDColl [repeat id]
	% import Counter [number]	
	% where
		% Counter [> 0]	
	import CountSchedulerClasses [number]	
	where
		CountSchedulerClasses [> 0]	
	construct InstanceFound [stringlit]
		"** ROLE 1:  Scheduler Classes: "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [program]
		_ [thePrintSchClassIDs each SchedulerClassIDColl]
	by 
		P
end function

% Function to aid in the printing of the class names in the function "printSchedulerClass".
function thePrintSchClassIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [program]
		P [program]
	by
		P	
end function


% Function to print out the Request Object Class ID that implement the Schedule Ordering Interface.
% The number of these Classes should equal the number of instances printed out in the "printOutput" function.
function printRqObjImplSchOrdInts
	replace [program]
		P [program]	
	import RqObjImplSchOrdIntsColl [repeat id]
	% import Counter [number]	
	% where
		% Counter [> 0]	
	import CountRqObjImplSchOrdInts [number]	
	where
		CountRqObjImplSchOrdInts [> 0]	
	construct InstanceFound [stringlit]
		"** ROLE 2:  Classes implementing the Schedule Ordering Interface: "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [program]
		_ [thePrintRqObjImplSchOrdIntsIDs each RqObjImplSchOrdIntsColl]
	by 
		P
end function

% Function to aid in the printing of the class names in the function "printRqObjImplSchOrdInts".
function thePrintRqObjImplSchOrdIntsIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [program]
		P [program]
	by
		P	
end function


% Function to print out the Schedule Ordering Interface Class IDs.
% The number of these Classes should equal the number of instances printed out in the "printOutput" function.
function printSchOrdInterface
	replace [program]
		P [program]	
	import SchOrdInterfacesIDColl [repeat id]
	% import Counter [number]	
	% where
		% Counter [> 0]	
	import CountSchOrdInterfaces [number]	
	where
		CountSchOrdInterfaces [> 0]	
	construct InstanceFound [stringlit]
		"** ROLE 3:  Schedule Ordering Interface Classes: "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [program]
		_ [thePrintSchOrdIntIDs each SchOrdInterfacesIDColl]
	by 
		P
end function

% Function to aid in the printing of the class names in the function "printSchOrdInterface".
function thePrintSchOrdIntIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [program]
		P [program]
	by
		P	
end function


% Function to print out the Processor Object Class IDs.
% The number of these Classes should equal the number of instances printed out in the "printOutput" function.
function printProcessorObjs
	replace [program]
		P [program]	
	import ProcessorObjIDColl [repeat id]
	% import Counter [number]	
	% where
		% Counter [> 0]	
	import CountProcessorObjs [number]	
	where
		CountProcessorObjs [> 0]	
	construct InstanceFound [stringlit]
		"** ROLE 4:  Processor Object Classes: "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [program]
		_ [thePrintProcessorClassIDs each ProcessorObjIDColl]
	by 
		P
end function

% Function to aid in the printing of the method names in the function "printProcessorObjs".
function thePrintProcessorClassIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [program]
		P [program]
	by
		P	
end function


% //*************************************************************************************//
% //*** Scheduler pattern:                                                            ***//
% //*** This design pattern allows for the controlling of the order in which threads  ***//
% //*** are scheduled to execute single threaded code through the use of an object    ***// 
% //*** that explicitly sequences the waiting threads.  This pattern basically        ***//
% //*** provides a mechanism to implement a scheduling policy independent of any      ***//
% //*** specific scheduling policy.  The scheduling policy is encapsulated in its     ***//
% //*** own class hence making it reusable.                                           ***//
% //*************************************************************************************//


% //*** SchedulerPattern:  Role = 3(Schedule Ordering interface implemented by the Role 2 Request object); 
rule FindSchOrdInterface
	replace [interface_declaration]
	    IH [interface_header] IB [interface_body]
	construct TransformedIB [interface_body]
		IB [findOrdMethInSchOrdInt IH] 

	construct numZero [number]
		'0
	import CountSchOrdInterfaces [number]
	import preCntSchOrdInterfaces [number]
	where not
		CountSchOrdInterfaces [hasNumber numZero]
	where
		CountSchOrdInterfaces [> preCntSchOrdInterfaces]		
		
	construct SchedulerAnnotation3pt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation3pt2 [stringlit]
		", roleID=3, roleDescription='Schedule Ordering interface implemented by the Role 2 Request object.')"	

	by
		'MUTATED /* SchedulerAnnotation3pt1 [+ CountSchOrdInterfaces] [+ SchedulerAnnotation3pt2] */ IH TransformedIB
end rule

% //*** SchedulerPattern:  Role = 3a(Public boolean method that helps in determining the order in which the request objects will occur.); 
rule findOrdMethInSchOrdInt IH [interface_header]

	import CountSchOrdInterfaces [number]
	import preCntSchOrdInterfaces [number]
	export preCntSchOrdInterfaces
		CountSchOrdInterfaces
	construct PUBLIC [modifier]
		'public		
	construct BOOL [type_specifier]
		'boolean		

	replace [method_declaration] 
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]    
	
	where 
		RM [isMethodModifier PUBLIC]				
	where
		TS [isVarOfType BOOL]

	deconstruct IH
		RM2 [repeat modifier] OAM [opt annot_marker] 'interface IN [interface_name] OEC [opt extends_clause] OIC [opt implements_clause]
	deconstruct IN
		DN2 [declared_name]
	deconstruct DN2
	   classID [id] OGP2 [opt generic_parameter]     
	   
	where 
		LFP [matchesVarID classID]

	construct PlusOne [number]
		1
		
	% import soiOrderingMethIDColl [repeat id]
	% construct newSoiOrdMethIDs [repeat id]
		% soiOrderingMethIDColl [. methodID]
	% export soiOrderingMethIDColl
		% newSoiOrdMethIDs
		
	% import CountSoiOrderingMethIDs [number]
	% construct NewCount [number]
		% CountSoiOrderingMethIDs [+ PlusOne]
	% export CountSoiOrderingMethIDs
		% NewCount		 
		
	import SchOrdInterfacesIDColl [repeat id]
	construct newSchOrdIntIDs [repeat id]
		SchOrdInterfacesIDColl [. classID]
	export SchOrdInterfacesIDColl
		newSchOrdIntIDs
		
	import CountSchOrdInterfaces 
	construct NewCountb [number]
		CountSchOrdInterfaces [+ PlusOne]
	export CountSchOrdInterfaces
		NewCountb		 
		
	construct SchedulerAnnotation3apt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation3apt2 [stringlit]
		", roleID=3a, roleDescription='Public boolean method that helps in determining the order in which the request objects will occur.')"	

	by
		'MUTATED /* SchedulerAnnotation3apt1 [+ CountSchOrdInterfaces] [+ SchedulerAnnotation3apt2] */ RM TS MD OT MB 
end rule


% //*** SchedulerPattern:  Role = 2(Request object - implements the ScheduleOrdering interface Role 3); 
rule FindRqObjImplSchOrdInts
	replace [class_declaration]
	    CH [class_header] CB [class_body]
		
	deconstruct CH
		RM [repeat modifier] 'class CN [class_name] OEC [opt extends_clause] OIC [opt implements_clause]
		
	import SchOrdInterfacesIDColl [repeat id]
	where
		OIC [matchesVarID each SchOrdInterfacesIDColl]
	
	construct TransformedCB [class_body]
		CB [findOrdMethInRqObj CH] 

	construct numZero [number]
		'0
	import CountRqObjImplSchOrdInts [number]
	import preCntRqObjImplSchOrdInts [number]
	where not
		CountRqObjImplSchOrdInts [hasNumber numZero]
	where
		CountRqObjImplSchOrdInts [> preCntRqObjImplSchOrdInts]		
		
	construct SchedulerAnnotation2pt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation2pt2 [stringlit]
		", roleID=2, roleDescription='Request object - implements the ScheduleOrdering interface Role 3.')"	

	by
		'MUTATED /* SchedulerAnnotation2pt1 [+ CountRqObjImplSchOrdInts] [+ SchedulerAnnotation2pt2] */ CH TransformedCB
end rule

% //*** SchedulerPattern:  Role = 2a(Private boolean method that helps in determining the order in which the request objects will occur.);
rule findOrdMethInRqObj CH [class_header]

	import CountRqObjImplSchOrdInts [number]
	import preCntRqObjImplSchOrdInts [number]
	export preCntRqObjImplSchOrdInts 
		CountRqObjImplSchOrdInts

	construct PRIV [modifier]
		'private		
	construct BOOL [type_specifier]
		'boolean		

	replace [method_declaration] 
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]    
	
	where 
		RM [isMethodModifier PRIV]				
	where
		TS [isVarOfType BOOL]
	   
	import SchOrdInterfacesIDColl [repeat id]
	where
		LFP [matchesVarID each SchOrdInterfacesIDColl]

	deconstruct CH
		RM2 [repeat modifier] 'class CN [class_name] OEC [opt extends_clause] OIC [opt implements_clause]
	deconstruct CN
		DN2 [declared_name]
	deconstruct DN2
	   classID [id] OGP2 [opt generic_parameter]     

	construct PlusOne [number]
		1
		
	% import reqOrderingMethIDColl [repeat id]
	% construct newReqOrdMethIDs [repeat id]
		% reqOrderingMethIDColl [. methodID]
	% export reqOrderingMethIDColl
		% newReqOrdMethIDs
		
	% import CountReqOrderingMethIDs [number]
	% construct NewCount [number]
		% CountReqOrderingMethIDs [+ PlusOne]
	% export CountReqOrderingMethIDs
		% NewCount		 
		
	import RqObjImplSchOrdIntsColl [repeat id]
	construct newRqObjIDs [repeat id]
		RqObjImplSchOrdIntsColl [. classID]
	export RqObjImplSchOrdIntsColl
		newRqObjIDs
		
	import CountRqObjImplSchOrdInts 
	construct NewCountb [number]
		CountRqObjImplSchOrdInts [+ PlusOne]
	export CountRqObjImplSchOrdInts
		NewCountb		 
		
	construct SchedulerAnnotation2apt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation2apt2 [stringlit]
		", roleID=2a, roleDescription='Private boolean method that helps in determining the order in which the request objects will occur.')"	

	by
		'MUTATED /* SchedulerAnnotation2apt1 [+ CountRqObjImplSchOrdInts] [+ SchedulerAnnotation2apt2] */ RM TS MD OT MB 
end rule


% //*** SchedulerPattern:  Role = 1(Scheduler object/class.
% //								** Contains Role 1a.  
% //								** Contains Role 1b.);
rule findSchedulerClass
	replace [class_declaration]
	    CH [class_header] CB [class_body]
		
	% construct SchClassRolesFound [class_body]
		% CB [getAllSchClsThdVars] [getAllSchClArrListVars] [findEnterMthOfSch] 
	% construct SchClassRolesFound2 [class_body]
		% CB [findDoneMthOfSch CH] [findDoneMthOfSch2 CH] 
		
	construct TransformedCB [class_body]
		CB [getAllSchClsThdVars] [getAllSchClArrListVars] [findEnterMthOfSch] [findDoneMthOfSch CH] [findDoneMthOfSch2 CH] 

	construct numZero [number]
		'0
	import CountSchedulerClasses [number]
	import preCntSchedulerClasses [number]
	where not
		CountSchedulerClasses [hasNumber numZero]
	where
		CountSchedulerClasses [> preCntSchedulerClasses]		
		
	construct SchedulerAnnotation1pt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1pt2 [stringlit]
		", roleID=1, roleDescription='Scheduler object/class.')"	

	by
		'MUTATED /* SchedulerAnnotation1pt1 [+ CountSchedulerClasses] [+ SchedulerAnnotation1pt2] */ CH TransformedCB
end rule

% //*** Thread creation outside of any methods within Role 1 (will be null when 
%					not busy and when busy will contain a reference to the thread using the resource).
% Rule to find all thread variables in the Scheduler class
rule getAllSchClsThdVars
	construct  VARTYPE [type_specifier]
		'Thread
	construct threadID1 [id]
		'currentThread
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where 
		 TS [isVarOfType VARTYPE]
	where not 
		VDS [matchesVarID threadID1]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		flagID [id] OGP [opt generic_parameter]    
		
	import ThreadIDCollection [repeat id]
	construct newIDCollection [repeat id]
		ThreadIDCollection [. flagID]
	export ThreadIDCollection
		newIDCollection
		
	by
		'MUTATED RM TS VDS ';
end rule

% //*** Arraylist declaration outside of any methods within Role 1 (will contain all requests for the resource). 
% //*** Arraylist declaration outside of any methods within Role 1 (will contain all the waiting threads corresponding to the list of waiting SchedulingOrdering object requests).
% Rule to find all arraylist variables.  This will enable us to locate the Scheduler class
rule getAllSchClArrListVars
	construct  VARTYPE [type_specifier]
		'ArrayList
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where 
		 TS [isVarOfType VARTYPE]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		flagID [id] OGP [opt generic_parameter]    
		
	import ArrListIDCollection [repeat id]
	construct newIDCollection [repeat id]
		ArrListIDCollection [. flagID]
	export ArrListIDCollection
		newIDCollection
		
	by
		'MUTATED RM TS VDS ';
end rule


% //*** SchedulerPattern:  Role = 1a(Method with a parameter that is an instance of ScheduleOrdering object Role 3.
% //							** Contains Role 1aa
% //							** Contains Role 1ab
% //							** Contains Role 1ac
% //							** Contains Role 1ad);
rule findEnterMthOfSch
	import CountSchedulerClasses [number]
	import preCntSchedulerClasses [number]
	export preCntSchedulerClasses 
		CountSchedulerClasses

	replace [method_declaration] 
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]	

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	construct theEnterMethParams [list formal_parameter]
		LFP [getParamsInEnterMeth]	
		
	construct numZero [number]
		'0
	import schClEntMethParamsCount [number]
	where not
		schClEntMethParamsCount [hasNumber numZero]
		
	deconstruct MB
        BL [block]  
	construct TransformedBL [block]
		BL [findCurrentThread] 
		[obtain1stSychStmtfromBL] 
		[obtain2ndSychStmtfromBL] 
		[obtain3rdSychStmtfromBL MD]	
		
	export tmpSchThreadID [id]
		_
	export tmpSchCurrThreadID [id]
		_
	export tmpSchWaitThrArrID [id]
		_
	export tmpSchWaitReqArrID [id]
		_
	export tmpSchintID [id]
		_

	% construct InstanceFound [repeat declaration_or_statement]
		% BL [obtain1stSychStmtfromBL BL MD]	
		
	import schClEntThObt1st2nd3rdSychStmtPassed [number]
	where
		schClEntThObt1st2nd3rdSychStmtPassed [> 0]
	export schClEntThObt1st2nd3rdSychStmtPassed 
		0

	% import schEntThreadIDCollPassed [number]
	% where
		% schEntThreadIDCollPassed [> 0]
	% export schEntThreadIDCollPassed 
		% 0
		
	% import schClobtain1stSychStmtPassed [number]
	% where
		% schClobtain1stSychStmtPassed [> 0]
	% export schClobtain1stSychStmtPassed 
		% 0
		
	% import schClobtain2ndSychStmtPassed [number]
	% where
		% schClobtain2ndSychStmtPassed [> 0]
	% export schClobtain2ndSychStmtPassed 
		% 0
		
	% import schClobtain3rdSychStmtPassed [number]
	% where
		% schClobtain3rdSychStmtPassed [> 0]
	% export schClobtain3rdSychStmtPassed 
		% 0		
		
	construct TransformedMB [method_body]
		TransformedBL

	construct SchedulerAnnotation1apt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1apt2 [stringlit]
		", roleID=1a, roleDescription='Method with a parameter that is an instance of ScheduleOrdering object Role 3.')"	
		
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ 1]

	by
		'MUTATED /* SchedulerAnnotation1apt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1apt2] */ RM TS MD OT TransformedMB 
end rule

% //*** SchedulerPattern:  Role = 1a(Method with a parameter that is an instance of ScheduleOrdering object Role 3.....cont'd
rule getParamsInEnterMeth
	replace [formal_parameter]
		RA [repeat annotation] OF [opt 'final] TS [type_specifier] OV [opt var_arg_specifier] FPN [formal_parameter_name]	 
		
	deconstruct TS
        TN [type_name] 
	deconstruct TN
		QN [qualified_name]
	deconstruct QN
		REF [reference]
	deconstruct REF
		typeSpecID [id] RC [repeat component]  	

	import SchOrdInterfacesIDColl [repeat id]
	where
		 typeSpecID [matchesVarID each SchOrdInterfacesIDColl]
	
	% import tmpTypeSpecIDCollection [repeat id]
	% construct newTypeSpecIDs [repeat id]
		% tmpTypeSpecIDCollection [. typeSpecID]
	% export tmpTypeSpecIDCollection
		% newTypeSpecIDs
	
	deconstruct FPN
		VN [variable_name]
	deconstruct VN
	    DN [declared_name] RD [repeat dimension]
	deconstruct DN
	   paramID [id] OGP [opt generic_parameter]  
	
	import schClEntMethParamIDColl [repeat id]
	construct newParamIDs [repeat id]
		schClEntMethParamIDColl [. paramID]
	export schClEntMethParamIDColl
		newParamIDs  	
		
	construct PlusOne [number]
		1
	import schClEntMethParamsCount [number]
	construct NewCount [number]
		schClEntMethParamsCount [+ PlusOne]
	export schClEntMethParamsCount
		NewCount		 
	
	by
		'MUTATED RA OF TS OV FPN 
end rule

% //*** SchedulerPattern:  Role = 1aa(New thread creation outside of any critical section.);
rule findCurrentThread
	construct  VARTYPE [type_specifier]
		'Thread
	construct threadID1 [id]
		'currentThread
		
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where 
		 TS [isVarOfType VARTYPE]
	where  
		VDS [matchesVarID threadID1]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		flagID [id] OGP [opt generic_parameter]    
		
	import schEntThreadIDColl [repeat id]
	construct newIDCollection [repeat id]
		schEntThreadIDColl [. flagID]
	export schEntThreadIDColl
		newIDCollection
		
	construct PlusOne [number]
		1
	% import schEntThreadIDCollPassed [number]
	% construct NewCount [number]
		% schEntThreadIDCollPassed [+ PlusOne]
	% export schEntThreadIDCollPassed
		% NewCount		
	import schClEntThObt1st2nd3rdSychStmtPassed [number]
	export schClEntThObt1st2nd3rdSychStmtPassed
		0

	construct NewCount [number]
		schClEntThObt1st2nd3rdSychStmtPassed [+ PlusOne]
	export schClEntThObt1st2nd3rdSychStmtPassed
		NewCount		
		
	construct SchedulerAnnotation1aapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1aapt2 [stringlit]
		", roleID=1aa, roleDescription='New thread creation outside of any critical section.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1aapt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1aapt2] */ RM TS VDS ';
end rule

% //*** SchedulerPattern:  Role = 1ab(Critical section creation by synchronization of this Scheduler object Role 1.
% //							** Contains Role 1aba);
% First Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition 
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method to issue a write lock.
rule obtain1stSychStmtfromBL 
	construct  THIS [expression]
		'this		
		
	replace [synchronized_statement]
	    'synchronized '( EX [expression] ')
			BL2 [block] 		
	where 
		EX [isMethodSynchdUsingThis THIS]		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}	
		
	import ArrListIDCollection [repeat id]	
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [getIfStmtWL] 
		[isCurrThrdAddedtoWaitThrArr each ArrListIDCollection]
		[isCurrThrdAddedtoWaitReqArr each ArrListIDCollection]
		 
	import schClRDS3inObt1stSychStmtfromBLPassed [number]
	where
		schClRDS3inObt1stSychStmtfromBLPassed [> 0]
	export schClRDS3inObt1stSychStmtfromBLPassed 
		0
		
	% import schClgetIfStmtWLPassed [number]
	% where
		% schClgetIfStmtWLPassed [> 0]
	% export schClgetIfStmtWLPassed 
		% 0
		 
	% import schClisCurrThrdAddedtoWaitThrArrPassed [number]
	% where
		% schClisCurrThrdAddedtoWaitThrArrPassed [> 0]
	% export schClisCurrThrdAddedtoWaitThrArrPassed 
		% 0
		 
	% import schClisCurrThrdAddedtoWaitReqArrPassed [number]
	% where
		% schClisCurrThrdAddedtoWaitReqArrPassed [> 0]
	% export schClisCurrThrdAddedtoWaitReqArrPassed 
		% 0
		
	construct TransformedBL2 [block]
		'{                                        
			TransformedRDS3   
		'}	
	
	construct PlusOne [number]
		1
	% import schClobtain1stSychStmtPassed [number]
	% construct NewCount [number]
		% schClobtain1stSychStmtPassed [+ PlusOne]
	% export schClobtain1stSychStmtPassed
		% NewCount		 
	import schClEntThObt1st2nd3rdSychStmtPassed [number]
	export schClEntThObt1st2nd3rdSychStmtPassed
		0

	construct NewCount [number]
		schClEntThObt1st2nd3rdSychStmtPassed [+ PlusOne]
	export schClEntThObt1st2nd3rdSychStmtPassed
		NewCount		
		
	construct SchedulerAnnotation1abpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1abpt2 [stringlit]
		", roleID=1ab, roleDescription='Critical section creation by synchronization of this Scheduler object Role 1.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1abpt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1abpt2] */
	    'synchronized '( EX ')
		'{
			TransformedBL2  	
		'}
end rule

% Called from within obtain1stSSfromBL to check if there is an if-statement
% //*** SchedulerPattern:  Role = 1aba(Within Role 1ab a check to whether the designated runningThread is null.  
% //							** If true proceed with Role 1abaa and 1abab.
% //							** If false proceed with Role 1abac and 1abad);
rule getIfStmtWL    
	replace [if_statement]
		'if '( EX2 [expression] ')     
			ifExpSTMT [statement]
		OEC [opt else_clause] 		
		
	import ThreadIDCollection [repeat id]
	construct InstanceFound [expression]
		EX2 [isIfStmtThreadNull EX2 each ThreadIDCollection]
		
	import schEntThreadIDColl [repeat id]		
	construct TransformedifExpSTMT [statement]
		ifExpSTMT [isRunningThrdCurrThrd each schEntThreadIDColl] [isReturnToProcessor ifExpSTMT]
		
	% import schClisRunningThrdCurrThrdPassed [number]
	% where
		% schClisRunningThrdCurrThrdPassed [> 0]
	% export schClisRunningThrdCurrThrdPassed 
		% 0
		
	% import schClisReturnToProcessorPassed [number]
	% where
		% schClisReturnToProcessorPassed [> 0]
	% export schClisReturnToProcessorPassed 
		% 0
	import schCgetIfStmtWLifExpSTMTPassed [number]
	where
		schCgetIfStmtWLifExpSTMTPassed [> 0]
	export schCgetIfStmtWLifExpSTMTPassed 
		0
		
	% construct PlusOne [number]
		% 1
	% import schClgetIfStmtWLPassed [number]
	% construct NewCount [number]
		% schClgetIfStmtWLPassed [+ PlusOne]
	% export schClgetIfStmtWLPassed
		% NewCount		 
	import schClRDS3inObt1stSychStmtfromBLPassed [number]
	export schClRDS3inObt1stSychStmtfromBLPassed
		0

	construct PlusOne [number]
		1
	construct NewCount [number]
		schClRDS3inObt1stSychStmtfromBLPassed [+ PlusOne]
	export schClRDS3inObt1stSychStmtfromBLPassed
		NewCount		 

	construct SchedulerAnnotation1abapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1abapt2 [stringlit]
		", roleID=1aba, roleDescription='Within Role 1ab a check to whether the designated runningThread is null.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1abapt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1abapt2] */
		'if '( EX2 ')     
		'{
			TransformedifExpSTMT 
		'}
		OEC 		
end rule

% //*** SchedulerPattern:  Role = 1aba(Within Role 1ab a check to whether the designated runningThread is null.  
% //							** If true proceed with Role 1abaa and 1abab.
% //							** If false proceed with Role 1abac and 1abad);
function isIfStmtThreadNull EX2 [expression] threadID [id]
	replace [expression]
		EX2
	construct theNull [null_literal]
		'null		
	where all
		EX2 [matchesVarID threadID] [hasNull theNull]		

	import tmpSchThreadID [id]
	export tmpSchThreadID
		threadID
	% import schEntThreadIDColl [repeat id]		
	% construct InstanceFound [statement]
		% ifExpSTMT [isRunningThrdCurrThrd BL RDS3 ifExpSTMT MD threadID each schEntThreadIDColl]	
	by
		EX2
end function

% //*** SchedulerPattern:  Role = 1abaa(Assign thread Role 1aa (current thread) to the designated runningThread.);
rule isRunningThrdCurrThrd currThreadID [id]
	replace [expression_statement]
		EX [expression] '; 
	construct assignOp [assignment_operator]
		'=
	deconstruct EX
		AE [assignment_expression]
		
	import tmpSchThreadID [id]
	where all
		AE [matchesVarID tmpSchThreadID] [matchesVarID currThreadID] [matchesAssignOp assignOp] 

	% import ArrListIDCollection [repeat id]	
	% construct InstanceFound  [repeat declaration_or_statement]
		% RDS3 [isCurrThrdAddedtoWaitThrArr MD BL RDS3 currThreadID threadID each ArrListIDCollection]
	import tmpSchCurrThreadID [id]
	export tmpSchCurrThreadID
		currThreadID
		
	construct PlusOne [number]
		1
	% import schClisRunningThrdCurrThrdPassed [number]
	% construct NewCount [number]
		% schClisRunningThrdCurrThrdPassed [+ PlusOne]
	% export schClisRunningThrdCurrThrdPassed
		% NewCount		 
	import schCgetIfStmtWLifExpSTMTPassed [number]
	export schCgetIfStmtWLifExpSTMTPassed 
		0

	construct NewCount [number]
		schCgetIfStmtWLifExpSTMTPassed [+ PlusOne]
	export schCgetIfStmtWLifExpSTMTPassed
		NewCount		 
 
	construct SchedulerAnnotation1abaapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1abaapt2 [stringlit]
		", roleID=1abaa, roleDescription='Assign thread Role 1aa (current thread) to the designated runningThread.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1abaapt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1abaapt2] */
		EX '; 
end rule

% //*** SchedulerPattern:  Role = 1abab(Return to calling Processor object Role 4.); 
rule isReturnToProcessor ifExpSTMT [statement] 
	replace [return_statement]
		'return OE [opt expression] ';
		
	% replace [expression_statement]
		% EX [expression] '; 
	% construct rtnStmt [statement]
		% 'return;
	% where 
		% ifExpSTMT [hasStmt rtnStmt]
		
	construct PlusOne [number]
		1
		
	% import schClisReturnToProcessorPassed [number]
	% construct NewCount [number]
		% schClisReturnToProcessorPassed [+ PlusOne]
	% export schClisReturnToProcessorPassed
		% NewCount		 
	import schCgetIfStmtWLifExpSTMTPassed [number]
	export schCgetIfStmtWLifExpSTMTPassed 
		0
		
	construct NewCount [number]
		schCgetIfStmtWLifExpSTMTPassed [+ PlusOne]
	export schCgetIfStmtWLifExpSTMTPassed
		NewCount		 

	construct SchedulerAnnotation1ababpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1ababpt2 [stringlit]
		", roleID=1abab, roleDescription='Return to calling Processor object Role 4.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1ababpt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1ababpt2] */
		'return OE ';
		% EX '; 
end rule

% //*** SchedulerPattern:  Role = 1abac(Add thread Role 1aa to the list of waiting threads.);
rule isCurrThrdAddedtoWaitThrArr WaitThrArrID [id]
	replace [expression_statement]
		EX [expression] '; 
		
	construct idAdd [id]
		'add
	deconstruct EX
		AE [assignment_expression]

	import tmpSchCurrThreadID [id]
	where all
		AE [matchesVarID tmpSchCurrThreadID] [matchesVarID WaitThrArrID] [matchesVarID idAdd] 
		
	import tmpSchWaitThrArrID [id]
	export tmpSchWaitThrArrID
		WaitThrArrID
	% import ArrListIDCollection [repeat id]	
	% construct InstanceFound [repeat declaration_or_statement]
		% RDS3 [isCurrThrdAddedtoWaitReqArr WaitThrArrID each ArrListIDCollection]
		
	% construct PlusOne [number]
		% 1
	% import schClisCurrThrdAddedtoWaitThrArrPassed [number]
	% construct NewCount [number]
		% schClisCurrThrdAddedtoWaitThrArrPassed [+ PlusOne]
	% export schClisCurrThrdAddedtoWaitThrArrPassed
		% NewCount		 
	import schClRDS3inObt1stSychStmtfromBLPassed [number]
	export schClRDS3inObt1stSychStmtfromBLPassed
		0

	construct PlusOne [number]
		1
	construct NewCount [number]
		schClRDS3inObt1stSychStmtfromBLPassed [+ PlusOne]
	export schClRDS3inObt1stSychStmtfromBLPassed
		NewCount		 

	construct SchedulerAnnotation1abacpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1abacpt2 [stringlit]
		", roleID=1abac, roleDescription='Add thread Role 1aa to the list of waiting threads.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]
		
	by
		'MUTATED /* SchedulerAnnotation1abacpt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1abacpt2] */
		EX '; 
end rule

% //*** SchedulerPattern:  Role = 1abad(Add instance of ScheduleOrdering object Role 3 (that was passed into method Role 1a) into the list of waiting SchedulingOrdering object requests.); 
rule isCurrThrdAddedtoWaitReqArr WaitReqArrID [id]

	replace [expression_statement]
		EX [expression] '; 
		
	construct idAdd [id]
		'add
	deconstruct EX
		AE [assignment_expression]
	deconstruct AE
		CE [conditional_expression]
	deconstruct CE
		COE [conditional_or_expression]
	deconstruct COE
		CAE [conditional_and_expression]
	deconstruct CAE
		IOE [inclusive_or_expression]
	deconstruct IOE
		EOE [exclusive_or_expression]
	deconstruct EOE
		ANDE [and_expression]
	deconstruct ANDE
		EE [equality_expression]
	deconstruct EE
		RE [relational_expression]
	deconstruct RE
		SE [shift_expression]
	deconstruct SE
		ADDE [additive_expression]
	deconstruct ADDE
		ME [multiplicative_expression]
	deconstruct ME
		UE [unary_expression]
	deconstruct UE
		PE [postfix_expression]
	deconstruct PE
		PRIM [primary]
	deconstruct PRIM
		REF [reference]
	deconstruct REF
		 REFID [id] RC [repeat component]
	
	import tmpSchWaitThrArrID [id]
	where not 
		tmpSchWaitThrArrID [matchesVarID WaitReqArrID]

	where all
		AE [matchesVarID WaitReqArrID] [matchesVarID idAdd] 
		
	import schClEntMethParamIDColl [repeat id]
	where
		RC [matchesVarID each schClEntMethParamIDColl]

	% construct InstanceFound [repeat declaration_or_statement]
		% BL [obtain2ndSychStmtfromBL WaitThrArrID WaitReqArrID currThreadID threadID BL MD]		
	import tmpSchWaitReqArrID [id]
	export tmpSchWaitReqArrID
		WaitReqArrID
		
	% construct PlusOne [number]
		% 1
	% import schClisCurrThrdAddedtoWaitReqArrPassed [number]
	% construct NewCount [number]
		% schClisCurrThrdAddedtoWaitReqArrPassed [+ PlusOne]
	% export schClisCurrThrdAddedtoWaitReqArrPassed
		% NewCount		 
	import schClRDS3inObt1stSychStmtfromBLPassed [number]
	export schClRDS3inObt1stSychStmtfromBLPassed
		0

	construct PlusOne [number]
		1
	construct NewCount [number]
		schClRDS3inObt1stSychStmtfromBLPassed [+ PlusOne]
	export schClRDS3inObt1stSychStmtfromBLPassed
		NewCount		 
	
	construct SchedulerAnnotation1abadpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1abadpt2 [stringlit]
		", roleID=1abad, roleDescription='Add instance of ScheduleOrdering object Role 3 (that was passed into method Role 1a) into the list of waiting SchedulingOrdering object requests.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]
		
	by
		'MUTATED /* SchedulerAnnotation1abadpt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1abadpt2] */
		EX '; 
end rule

% //*** SchedulerPattern:  Role = 1ac(Critical section creation by synchronization of thread Role 1aa.
% //							** Contains Role 1aca);
rule obtain2ndSychStmtfromBL 
	replace [synchronized_statement]
	    'synchronized '( EX [expression] ')
			BL2 [block] 	
			
	import tmpSchCurrThreadID [id]
	where 
		EX [matchesVarID tmpSchCurrThreadID]		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}	
		
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isWhileLpThreadChk] [isDoWhileLpThreadChk]
		
	construct TransformedBL2 [block]
		'{                                        
			TransformedRDS3  
		'}	
		
	construct PlusOne [number]
		1
	% import schClobtain2ndSychStmtPassed [number]
	% construct NewCount [number]
		% schClobtain2ndSychStmtPassed [+ PlusOne]
	% export schClobtain2ndSychStmtPassed
		% NewCount
	import schClEntThObt1st2nd3rdSychStmtPassed [number]
	export schClEntThObt1st2nd3rdSychStmtPassed
		0

	construct NewCount [number]
		schClEntThObt1st2nd3rdSychStmtPassed [+ PlusOne]
	export schClEntThObt1st2nd3rdSychStmtPassed
		NewCount		
	
	construct SchedulerAnnotation1acpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1acpt2 [stringlit]
		", roleID=1ac, roleDescription='Critical section creation by synchronization of thread Role 1aa.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1acpt1 [+ NewCount] [+ SchedulerAnnotation1acpt2] */
	    'synchronized '( EX ')
		'{
			TransformedBL2  	
		'}
end rule

% //*** SchedulerPattern:  Role = 1aca(A loop within critical section Role 1ac to check if the new thread Role 1aa is NOT the same as the designated runningThread.  
% //							** If true proceed with Role 1acaa.
% //							** If false then new thread Role 1aa is allowed to continue to run and proceeds to Role 1ad.);
% //*** SchedulerPattern:  Role = 1acaa(New thread Role 1aa is placed in a waiting state until method Role 1b wakes it up using nofityAll().);
rule isWhileLpThreadChk 
	replace [while_statement]
	    'while '( EX [expression] ') 
			STMT [statement]                     

	construct neOp [equality_op]
		'!=

	import tmpSchThreadID [id]
	import tmpSchCurrThreadID [id]
	where all
		EX [matchesVarID tmpSchCurrThreadID] [matchesVarID tmpSchThreadID] [matchesEqOp neOp]
		
	construct waitID [id]
		'wait
	where all
		STMT [matchesVarID tmpSchCurrThreadID] [matchesVarID waitID]
		
	% construct InstanceFound [repeat declaration_or_statement]
		% BL [obtain3rdSychStmtfromBL WaitThrArrID WaitReqArrID currThreadID threadID MD]		

	construct PlusOne [number]
		1
	construct SchedulerAnnotation1acapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1acapt2 [stringlit]
		", roleID=1aca, roleDescription='A loop within critical section Role 1ac to check if the new thread Role 1aa is NOT the same as the designated runningThread.')"	
		
	construct SchedulerAnnotation1acaapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1acaapt2 [stringlit]
		", roleID=1acaa, roleDescription='New thread Role 1aa is placed in a waiting state until method Role 1b wakes it up using nofityAll().')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]
		
	by
		'MUTATED /* SchedulerAnnotation1acapt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1acapt2] */
	    'while '( EX ') 
		{
			/* SchedulerAnnotation1acaapt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1acaapt2] */
			STMT                     
		}
end rule

% //*** SchedulerPattern:  Role = 1aca(A loop within critical section Role 1ac to check if the new thread Role 1aa is NOT the same as the designated runningThread.  
% //							** If true proceed with Role 1acaa.
% //							** If false then new thread Role 1aa is allowed to continue to run and proceeds to Role 1ad.);
% //*** SchedulerPattern:  Role = 1acaa(New thread Role 1aa is placed in a waiting state until method Role 1b wakes it up using nofityAll().);
rule isDoWhileLpThreadChk 
	replace [do_statement]
		'do
			 STMT [statement]
		'while '( EX [expression] ') '; 			

	construct neOp [equality_op]
		'!=
	import tmpSchThreadID [id]
	import tmpSchCurrThreadID [id]
	where all
		EX [matchesVarID tmpSchCurrThreadID] [matchesVarID tmpSchThreadID] [matchesEqOp neOp]
		
	construct waitID [id]
		'wait
	where all
		STMT [matchesVarID tmpSchCurrThreadID] [matchesVarID waitID]
		
	% construct InstanceFound [repeat declaration_or_statement]
		% BL [obtain3rdSychStmtfromBL WaitThrArrID WaitReqArrID currThreadID threadID MD]		

	construct SchedulerAnnotation1acapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1acapt2 [stringlit]
		", roleID=1aca, roleDescription='A loop within critical section Role 1ac to check if the new thread Role 1aa is NOT the same as the designated runningThread.')"	
		
	construct SchedulerAnnotation1acaapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1acaapt2 [stringlit]
		", roleID=1acaa, roleDescription='New thread Role 1aa is placed in a waiting state until method Role 1b wakes it up using nofityAll().')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ 1]
		
	by
		'MUTATED /* SchedulerAnnotation1acapt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1acapt2] */
		'do
		{
			/* SchedulerAnnotation1acaapt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1acaapt2] */
			 STMT
		}
		'while '( EX ') '; 			
end rule

% //*** SchedulerPattern:  Role = 1ad(Critical section creation by synchronization of this Scheduler object Role 1.
% //							** Contains Role 1ada
% //							** Contains Role 1adb);
rule obtain3rdSychStmtfromBL MD [method_declarator] 
	construct  THIS [expression]
		'this		
	replace [synchronized_statement]
	    'synchronized '( EX [expression] ')
			BL2 [block] 		
	where 
		EX [isMethodSynchdUsingThis THIS]		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}	
		
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isIndCurrThrInWaitThrArr] [isCurThrRemFrmWaitThrArr]
		 [isCurThrRemFrmWaitReqArr MD]
		 
	% import schClisIndCurrThrInWaitThrArrPassed [number]
	% where
		% schClisIndCurrThrInWaitThrArrPassed [> 0]
	% export schClisIndCurrThrInWaitThrArrPassed 
		% 0
		 
	% import schClisCurThrRemFrmWaitThrArrPassed [number]
	% where
		% schClisCurThrRemFrmWaitThrArrPassed [> 0]
	% export schClisCurThrRemFrmWaitThrArrPassed 
		% 0
		 
	% import schClisCurThrRemFrmWaitReqArrPassed [number]
	% where
		% schClisCurThrRemFrmWaitReqArrPassed [> 0]
	% export schClisCurThrRemFrmWaitReqArrPassed 
		% 0
		
	import schClRDS3inObt3rdSychStmtfromBLPassed [number]
	where
		schClRDS3inObt3rdSychStmtfromBLPassed [> 0]
	export schClRDS3inObt3rdSychStmtfromBLPassed 
		0
		
	construct TransformedBL2 [block]
		'{                                        
			TransformedRDS3  
		'}	
		
	construct PlusOne [number]
		1
	% import schClobtain3rdSychStmtPassed [number]
	% construct NewCount [number]
		% schClobtain3rdSychStmtPassed [+ PlusOne]
	% export schClobtain3rdSychStmtPassed
		% NewCount
	import schClEntThObt1st2nd3rdSychStmtPassed [number]
	export schClEntThObt1st2nd3rdSychStmtPassed
		0

	construct NewCount [number]
		schClEntThObt1st2nd3rdSychStmtPassed [+ PlusOne]
	export schClEntThObt1st2nd3rdSychStmtPassed
		NewCount		
	
	construct SchedulerAnnotation1adpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1adpt2 [stringlit]
		", roleID=1ad, roleDescription='Critical section creation by synchronization of this Scheduler object Role 1.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1adpt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1adpt2] */
	    'synchronized '( EX ')
		'{
			TransformedBL2  	
		'}
end rule

rule isIndCurrThrInWaitThrArr 
	construct  VARTYPE [type_specifier]
		'int
	construct idIndexOf [id]
		'indexOf
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where 
		 TS [isVarOfType VARTYPE]
		 
	import tmpSchWaitThrArrID [id]
	import tmpSchCurrThreadID [id]
	where all
		VDS [matchesVarID tmpSchWaitThrArrID] [matchesVarID idIndexOf] [matchesVarID tmpSchCurrThreadID]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		intID [id] OGP [opt generic_parameter]    
		
	import tmpSchintID [id]
	export tmpSchintID
		intID
	% construct InstanceFound [repeat declaration_or_statement]
		% RDS3 [isCurThrRemFrmWaitThrArr RDS3 MD threadID WaitThrArrID WaitReqArrID intID]
	construct PlusOne [number]
		1
	% import schClisIndCurrThrInWaitThrArrPassed [number]
	% construct NewCount [number]
		% schClisIndCurrThrInWaitThrArrPassed [+ PlusOne]
	% export schClisIndCurrThrInWaitThrArrPassed
		% NewCount		 
	import schClRDS3inObt3rdSychStmtfromBLPassed [number]
	export schClRDS3inObt3rdSychStmtfromBLPassed 
		0
	
	construct NewCount [number]
		schClRDS3inObt3rdSychStmtfromBLPassed [+ PlusOne]
	export schClRDS3inObt3rdSychStmtfromBLPassed
		NewCount		 
		
	by
		'MUTATED RM TS VDS ';
end rule

% //*** SchedulerPattern:  Role = 1ada(Remove current thread (Role 1aa) from the arraylist of waiting threads.);
rule isCurThrRemFrmWaitThrArr 
	replace [expression_statement]
		EX [expression] '; 
		
	construct idRemove [id]
		'remove
	deconstruct EX
		AE [assignment_expression]

	import tmpSchWaitThrArrID [id]
	import tmpSchintID [id]
	where all
		AE [matchesVarID tmpSchWaitThrArrID] [matchesVarID idRemove] [matchesVarID tmpSchintID]
		
	% construct InstanceFound [repeat declaration_or_statement]
		% RDS3 [isCurThrRemFrmWaitReqArr MD threadID WaitThrArrID WaitReqArrID intID]
	construct PlusOne [number]
		1
	% import schClisCurThrRemFrmWaitThrArrPassed [number]
	% construct NewCount [number]
		% schClisCurThrRemFrmWaitThrArrPassed [+ PlusOne]
	% export schClisCurThrRemFrmWaitThrArrPassed
		% NewCount		 
	import schClRDS3inObt3rdSychStmtfromBLPassed [number]
	export schClRDS3inObt3rdSychStmtfromBLPassed 
		0
	
	construct NewCount [number]
		schClRDS3inObt3rdSychStmtfromBLPassed [+ PlusOne]
	export schClRDS3inObt3rdSychStmtfromBLPassed
		NewCount		 

	construct SchedulerAnnotation1adapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1adapt2 [stringlit]
		", roleID=1ada, roleDescription='Remove current thread (Role 1aa) from the arraylist of waiting threads.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1adapt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1adapt2] */
		EX '; 
end rule

% //*** SchedulerPattern:  Role = 1adb(Remove current instance of the requested ScheduleOrdering object (Role 3), that was passed into method 
%					Role 1a, from the arraylist of waiting SchedulingOrdering object requests.  Correspond to the list of waiting threads.); 
rule isCurThrRemFrmWaitReqArr MD [method_declarator] 
	replace [expression_statement]
		EX [expression] '; 
		
	construct idRemove [id]
		'remove
	deconstruct EX
		AE [assignment_expression]

	import tmpSchThreadID [id]
	import tmpSchWaitThrArrID [id]
	import tmpSchWaitReqArrID [id]
	import tmpSchintID [id]
	where all
		AE [matchesVarID tmpSchWaitReqArrID] [matchesVarID idRemove] [matchesVarID tmpSchintID]
		
	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]    
		
	construct PlusOne [number]
		1
		
	import schRunningThreadColl [repeat id]
	construct newRunningThreadIDs [repeat id]
		schRunningThreadColl [. tmpSchThreadID]
	export schRunningThreadColl
		newRunningThreadIDs		
		
	import schWaitThrArrsColl [repeat id]
	construct newWaitThrArrs [repeat id]
		schWaitThrArrsColl [. tmpSchWaitThrArrID]
	export schWaitThrArrsColl
		newWaitThrArrs		
		
	% import schWaitReqArrsColl [repeat id]
	% construct newWaitReqArrIDs [repeat id]
		% schWaitReqArrsColl [. tmpSchWaitReqArrID]
	% export schWaitReqArrsColl
		% newWaitReqArrIDs		
		
	import schEnterMethColl [repeat id]
	construct newEnterMethodIDs [repeat id]
		schEnterMethColl [. methodID]
	export schEnterMethColl
		newEnterMethodIDs		
		
	% import schCntRunningThread [number]
	% construct NewCount [number]
		% schCntRunningThread [+ PlusOne]
	% export schCntRunningThread
		% NewCount		 
		
	% import schCntWaitThrArrs [number]
	% construct NewCountb [number]
		% schCntWaitThrArrs [+ PlusOne]
	% export schCntWaitThrArrs
		% NewCountb		 		
		
	% import schCntWaitReqArrs [number]
	% construct NewCountc [number]
		% schCntWaitReqArrs [+ PlusOne]
	% export schCntWaitReqArrs
		% NewCountc		 
		
	% import schCntEnterMeth [number]
	% construct NewCountd [number]
		% schCntEnterMeth [+ PlusOne]
	% export schCntEnterMeth
		% NewCountd			
		
	import schCntRunThWaitThArWtRqArEntMth [number]
	construct NewCount [number]
		schCntRunThWaitThArWtRqArEntMth [+ PlusOne]
	export schCntRunThWaitThArWtRqArEntMth
		NewCount		  
		
	% import schClisCurThrRemFrmWaitReqArrPassed [number]
	% construct NewCounte [number]
		% schClisCurThrRemFrmWaitReqArrPassed [+ PlusOne]
	% export schClisCurThrRemFrmWaitReqArrPassed
		% NewCounte		 
	import schClRDS3inObt3rdSychStmtfromBLPassed [number]
	export schClRDS3inObt3rdSychStmtfromBLPassed 
		0

	construct NewCounte [number]
		schClRDS3inObt3rdSychStmtfromBLPassed [+ PlusOne]
	export schClRDS3inObt3rdSychStmtfromBLPassed
		NewCounte		 
		
	construct SchedulerAnnotation1adbpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1adbpt2 [stringlit]
		", roleID=1adb, roleDescription='Remove current instance of the requested ScheduleOrdering object (Role 3), that was passed into method "	
	construct SchedulerAnnotation1adbpt2b [stringlit]
		"Role 1a, from the arraylist of waiting SchedulingOrdering object requests.  Correspond to the list of waiting threads.')"	
		
	import CountSchedulerClasses [number]
	construct NewCountSchedulerClasses [number]
		CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1adbpt1 [+ NewCountSchedulerClasses] [+ SchedulerAnnotation1adbpt2] [+ SchedulerAnnotation1adbpt2b] */
		EX '; 
end rule

% //Call to the done method indicates current thread is finished with the resource
% //*** SchedulerPattern:  Role = 1b(Synchronized method called when the current thread is finished with resource.);
% //							** Contains Role 1ba.);
% First Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition 
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method to issue a read lock.
rule findDoneMthOfSch CH [class_header]
	construct  SYNCH [modifier]
		'synchronized		
	replace [method_declaration] 
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]		
	where 
		RM [isMethodModifier SYNCH]		
	deconstruct MB
        BL2 [block]  		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}			
		
	import schWaitThrArrsColl [repeat id]
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [getFirstIfStmtDone] 
		[isWaitCntDecld each schWaitThrArrsColl]
		[getSecondIfStmtDone]
		[getThirdIfStmtDone MD CH]
		
	% import schClgetFirstIfStmtDonePassed [number]
	% where
		% schClgetFirstIfStmtDonePassed [> 0]
	% export schClgetFirstIfStmtDonePassed 
		% 0
		
	% import schClisWaitCntDecldPassed [number]
	% where
		% schClisWaitCntDecldPassed [> 0]
	% export schClisWaitCntDecldPassed 
		% 0
		
	% import schClgetSecondIfStmtDonePassed [number]
	% where
		% schClgetSecondIfStmtDonePassed [> 0]
	% export schClgetSecondIfStmtDonePassed 
		% 0
		
	% import schClgetThirdIfStmtDonePassed [number]
	% where
		% schClgetThirdIfStmtDonePassed [> 0]
	% export schClgetThirdIfStmtDonePassed 
		% 0
		
	import schClfindDoneMthOfSchTransfRDS3Passed [number]
	where
		schClfindDoneMthOfSchTransfRDS3Passed [> 0]
	export schClfindDoneMthOfSchTransfRDS3Passed 
		0

	construct TransformedBL2 [block]
		'{                                        
			TransformedRDS3   
		'}	
	construct TransformedMB [method_body]
        TransformedBL2 		

	construct SchedulerAnnotation1bpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1bpt2 [stringlit]
		", roleID=1b, roleDescription='Synchronized method called when the current thread is finished with resource.')"	
		
	import CountSchedulerClasses [number]
	% construct NewCountSchedulerClasses [number]
		% CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1bpt1 [+ CountSchedulerClasses] [+ SchedulerAnnotation1bpt2] */ RM TS MD OT TransformedMB 
end rule

% //Call to the done method indicates current thread is finished with the resource
% //*** SchedulerPattern:  Role = 1b(Synchronized method called when the current thread is finished with resource.);
% //							** Contains Role 1ba.);
% Second Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition 
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method to issue a read lock.
rule findDoneMthOfSch2 CH [class_header]
	construct  THIS [expression]
		'this		
	replace [method_declaration] 
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]		
	deconstruct MB
        BL [block]  		
	deconstruct BL
	    '{                                       
			RDS [repeat declaration_or_statement] 
		'}			
	deconstruct RDS
		STMT [statement]
		RDS2 [repeat declaration_or_statement]		
	deconstruct STMT
		SSTMT [synchronized_statement]		
	deconstruct SSTMT
	    'synchronized '( EX [expression] ')
			BL2 [block] 		
	where 
		EX [isMethodSynchdUsingThis THIS]		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}	
		
	import schWaitThrArrsColl [repeat id]
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [getFirstIfStmtDone] 
		[isWaitCntDecld each schWaitThrArrsColl] 
		[getSecondIfStmtDone] 
		[getThirdIfStmtDone MD CH]
		
	% import schClgetFirstIfStmtDonePassed [number]
	% where
		% schClgetFirstIfStmtDonePassed [> 0]
	% export schClgetFirstIfStmtDonePassed 
		% 0
		
	% import schClisWaitCntDecldPassed [number]
	% where
		% schClisWaitCntDecldPassed [> 0]
	% export schClisWaitCntDecldPassed 
		% 0
		
	% import schClgetSecondIfStmtDonePassed [number]
	% where
		% schClgetSecondIfStmtDonePassed [> 0]
	% export schClgetSecondIfStmtDonePassed 
		% 0
		
	% import schClgetThirdIfStmtDonePassed [number]
	% where
		% schClgetThirdIfStmtDonePassed [> 0]
	% export schClgetThirdIfStmtDonePassed 
		% 0
		
	import schClfindDoneMthOfSchTransfRDS3Passed [number]
	where
		schClfindDoneMthOfSchTransfRDS3Passed [> 0]
	export schClfindDoneMthOfSchTransfRDS3Passed 
		0
		 
	construct TransformedBL2 [block]
		'{                                        
			TransformedRDS3   
		'}	
	construct TransformedSSTMT [synchronized_statement]
	    'synchronized '( EX ')
			TransformedBL2 		
	construct TransformedSTMT [statement]
		TransformedSSTMT		
	construct TransformedRDS [repeat declaration_or_statement]
		TransformedSTMT
		RDS2 		
	construct TransformedBL [block]
	    '{                                       
			TransformedRDS 
		'}			
	construct TransformedMB [method_body]	
        TransformedBL  		

	construct SchedulerAnnotation1bpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1bpt2 [stringlit]
		", roleID=1b, roleDescription='Synchronized method called when the current thread is finished with resource.')"	
		
	import CountSchedulerClasses [number]
	% construct NewCountSchedulerClasses [number]
		% CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1bpt1 [+ CountSchedulerClasses] [+ SchedulerAnnotation1bpt2] */ RM TS MD OT TransformedMB 
end rule

% Called from within findDoneSynchMeth2 to check if there is an if-statement
rule getFirstIfStmtDone    
	replace [if_statement]
		'if '( EX2 [expression] ')     
			ifExpSTMT [statement]
		OEC [opt else_clause] 		
		
	import schRunningThreadColl [repeat id]
	construct InstanceFound [expression]
		EX2 [isChkRunThdNotCurrThd EX2 each schRunningThreadColl] 
	
	import schClisChkRunThdNotCurrThdPassed [number]
	where
		schClisChkRunThdNotCurrThdPassed [> 0]
	export schClisChkRunThdNotCurrThdPassed 
		0
	
	construct PlusOne [number]
		1
	% import schClgetFirstIfStmtDonePassed [number]
	% construct NewCount [number]
		% schClgetFirstIfStmtDonePassed [+ PlusOne]
	% export schClgetFirstIfStmtDonePassed
		% NewCount
	import schClfindDoneMthOfSchTransfRDS3Passed [number]
	export schClfindDoneMthOfSchTransfRDS3Passed 
		0
		
	construct NewCount [number]
		schClfindDoneMthOfSchTransfRDS3Passed [+ PlusOne]
	export schClfindDoneMthOfSchTransfRDS3Passed
		NewCount

	by
		'MUTATED 
		'if '( EX2 ')     
		'{
			ifExpSTMT 
		'}
		OEC 		
end rule

function isChkRunThdNotCurrThd EX2 [expression] runningThdID [id]
	replace [expression]
		EX2
	construct threadID2 [id]
		'Thread
	construct threadID3 [id]
		'currentThread
	construct neOp [equality_op]
		'!=
	where all
		EX2 [matchesVarID runningThdID] [matchesEqOp neOp] [matchesVarID threadID2] [matchesVarID threadID3]
		
	import tmpRunningThdID [id]
	export tmpRunningThdID
		runningThdID
		
	construct PlusOne [number]
		1
	import schClisChkRunThdNotCurrThdPassed [number]
	construct NewCount [number]
		schClisChkRunThdNotCurrThdPassed [+ PlusOne]
	export schClisChkRunThdNotCurrThdPassed
		NewCount
	% import schWaitThrArrsColl [repeat id]
	% construct waitCntDeclFound [repeat declaration_or_statement]
		% RDS3 [isWaitCntDecld MD RDS3 runningThdID CH each schWaitThrArrsColl]
	
	by 
		EX2

end function

rule isWaitCntDecld WaitThrArrID [id]
	construct  VARTYPE [type_specifier]
		'int
	construct SIZE [id]
		'size
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where 
		 TS [isVarOfType VARTYPE]
	where all
		VDS [matchesVarID WaitThrArrID] [matchesVarID SIZE]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		waitCountID [id] OGP [opt generic_parameter]    
		
	import tmpWaitThrArrID [id]
	export tmpWaitThrArrID
		WaitThrArrID
		
	import tmpWaitCountID [id]
	export tmpWaitCountID
		waitCountID

	% construct InstanceFound [repeat declaration_or_statement]
		% RDS3 [getSecondIfStmtDone MD RDS3 runningThdID WaitThrArrID waitCountID CH]
		
	construct PlusOne [number]
		1
	% import schClisWaitCntDecldPassed [number]
	% construct NewCount [number]
		% schClisWaitCntDecldPassed [+ PlusOne]
	% export schClisWaitCntDecldPassed
		% NewCount
	import schClfindDoneMthOfSchTransfRDS3Passed [number]
	export schClfindDoneMthOfSchTransfRDS3Passed 
		0

	construct NewCount [number]
		schClfindDoneMthOfSchTransfRDS3Passed [+ PlusOne]
	export schClfindDoneMthOfSchTransfRDS3Passed
		NewCount
		
	by
		'MUTATED RM TS VDS ';

end rule

% Called from within findDoneSynchMeth2 to check if there is a 2nd if-statement
rule getSecondIfStmtDone   
	replace [if_statement]
		'if '( EX2 [expression] ')     
			ifExpSTMT [statement]
		OEC [opt else_clause] 		
		
	construct gtEqRelOp [relational_op]
		'<=
	construct numZero [number]
		'0

	import tmpWaitCountID [id]
	where all
		EX2 [matchesVarID tmpWaitCountID] [matchesRelOp gtEqRelOp] [hasNumber numZero]		
		
	construct InstanceFound [statement]
		ifExpSTMT [isRunThdAssdNull] 
		
	import schClisRunThdAssdNullPassed [number]
	where
		schClisRunThdAssdNullPassed [> 0]
	export schClisRunThdAssdNullPassed 
		0
	
	construct PlusOne [number]
		1
	% import schClgetSecondIfStmtDonePassed [number]
	% construct NewCount [number]
		% schClgetSecondIfStmtDonePassed [+ PlusOne]
	% export schClgetSecondIfStmtDonePassed
		% NewCount
	import schClfindDoneMthOfSchTransfRDS3Passed [number]
	export schClfindDoneMthOfSchTransfRDS3Passed
		0
		
	construct NewCount [number]
		schClfindDoneMthOfSchTransfRDS3Passed [+ PlusOne]
	export schClfindDoneMthOfSchTransfRDS3Passed
		NewCount

	by
		'MUTATED 
		'if '( EX2 ')     
		'{
			ifExpSTMT 
		'}
		OEC 		
end rule

rule isRunThdAssdNull 
	replace [expression_statement]
		EX [expression] '; 
	construct assignOp [assignment_operator]
		'=
	construct numZero [number]
		'0
	construct theNull [null_literal]
		'null		
	deconstruct EX
		AE [assignment_expression]
		
	import tmpRunningThdID [id]
	where all
		AE [matchesVarID tmpRunningThdID] [matchesAssignOp assignOp] [hasNull theNull]

	% construct InstanceFound [repeat declaration_or_statement]
		% RDS3 [getThirdIfStmtDone MD RDS3 runningThdID WaitThrArrID waitCountID CH]	
	construct PlusOne [number]
		1
	import schClisRunThdAssdNullPassed [number]
	construct NewCount [number]
		schClisRunThdAssdNullPassed [+ PlusOne]
	export schClisRunThdAssdNullPassed
		NewCount
 
	by
		'MUTATED 
		EX '; 
end rule

rule getThirdIfStmtDone MD [method_declarator] CH [class_header]
	replace [if_statement]
		'if '( EX [expression] ')     
			ifExpSTMT [statement]
		OEC [opt else_clause] 		
		
	construct eqOp [equality_op]
		'==
	construct numOne [number]
		'1

	import tmpWaitCountID [id]
	where all
		EX [matchesVarID tmpWaitCountID] [matchesEqOp eqOp] [hasNumber numOne]
		
	construct InstanceFound [statement]
		ifExpSTMT [getRunThdAssdWaitingThd]	[isWaitThRemove]
		
	% import schClgetRunThdAssdWaitingThdPassed [number]
	% where
		% schClgetRunThdAssdWaitingThdPassed [> 0]
	% export schClgetRunThdAssdWaitingThdPassed 
		% 0
		
	% import schClisWaitThRemovePassed [number]
	% where
		% schClisWaitThRemovePassed [> 0]
	% export schClisWaitThRemovePassed 
		% 0
	import schClget3rrdIfStmtDoneifExpSTMTPassed [number]
	where
		schClget3rrdIfStmtDoneifExpSTMTPassed [> 0]
	export schClget3rrdIfStmtDoneifExpSTMTPassed 
		0

	import SchOrdInterfacesIDColl [repeat id]
	% import schWaitReqArrsColl [repeat id]
	construct TransformedOEC [opt else_clause]
		OEC [isRunnThdSynch MD CH]
		% OEC [getLastElseDone]
		% [isSchOrdInstDecl each SchOrdInterfacesIDColl]	
		% [isNextRequAssigned each schWaitReqArrsColl]		
		% [isRunnThdAssigned]		
		% [isRunnThdSynch MD CH]
		
	import schClgetThirdIfStmtDoneTransfOEC [number]
	where
		schClgetThirdIfStmtDoneTransfOEC [> 0]
	export schClgetThirdIfStmtDoneTransfOEC 
		0

	% import schClgetLastElseDonePassed [number]
	% where
		% schClgetLastElseDonePassed [> 0]
	% export schClgetLastElseDonePassed 
		% 0
		
	% import schClisSchOrdInstDeclPassed [number]
	% where
		% schClisSchOrdInstDeclPassed [> 0]
	% export schClisSchOrdInstDeclPassed 
		% 0
		
	% import schClisNextRequAssignedPassed [number]
	% where
		% schClisNextRequAssignedPassed [> 0]
	% export schClisNextRequAssignedPassed 
		% 0
		
	% import schClisRunnThdAssignedPassed [number]
	% where
		% schClisRunnThdAssignedPassed [> 0]
	% export schClisRunnThdAssignedPassed 
		% 0
		
	% import schClisRunnThdSynchPassed [number]
	% where
		% schClisRunnThdSynchPassed [> 0]
	% export schClisRunnThdSynchPassed 
		% 0
	
	construct PlusOne [number]
		1
	% import schClgetThirdIfStmtDonePassed [number]
	% construct NewCount [number]
		% schClgetThirdIfStmtDonePassed [+ PlusOne]
	% export schClgetThirdIfStmtDonePassed
		% NewCount
	import schClfindDoneMthOfSchTransfRDS3Passed [number]
	export schClfindDoneMthOfSchTransfRDS3Passed 
		0
		
	construct NewCount [number]
		schClfindDoneMthOfSchTransfRDS3Passed [+ PlusOne]
	export schClfindDoneMthOfSchTransfRDS3Passed
		NewCount

	by
		'MUTATED 
		'if '( EX ')     
		'{
			ifExpSTMT 
		'}
		TransformedOEC 		
end rule

rule getRunThdAssdWaitingThd 
	replace [expression_statement]
		EX [expression] '; 
	construct assignOp [assignment_operator]
		'=
	construct threadID2 [id]
		'Thread
	construct idGet [id]
		'get
	construct numZero [number]
		'0
	deconstruct EX
		AE [assignment_expression]

	import tmpRunningThdID [id]
	import tmpWaitThrArrID [id]
	where all
		AE [matchesVarID tmpRunningThdID] [matchesAssignOp assignOp] [matchesVarID threadID2] [matchesVarID tmpWaitThrArrID] [matchesVarID idGet] [hasNumber numZero]

	% construct InstanceFound [statement]
		% ifExpSTMT [isWaitThRemove MD RDS3 runningThdID WaitThrArrID waitCountID OEC CH]		
	construct PlusOne [number]
		1
	% import schClgetRunThdAssdWaitingThdPassed [number]
	% construct NewCount [number]
		% schClgetRunThdAssdWaitingThdPassed [+ PlusOne]
	% export schClgetRunThdAssdWaitingThdPassed
		% NewCount
	import schClget3rrdIfStmtDoneifExpSTMTPassed [number]
	export schClget3rrdIfStmtDoneifExpSTMTPassed 
		0

	construct NewCount [number]
		schClget3rrdIfStmtDoneifExpSTMTPassed [+ PlusOne]
	export schClget3rrdIfStmtDoneifExpSTMTPassed
		NewCount
 
	by
		'MUTATED 
		EX '; 
end rule

rule isWaitThRemove 
	replace [expression_statement]
		EX [expression] '; 
	construct idRemove [id]
		'remove
	construct numZero [number]
		'0
	deconstruct EX
		AE [assignment_expression]
		
	import tmpWaitThrArrID [id]	
	where all
		AE [matchesVarID tmpWaitThrArrID] [matchesVarID idRemove] [hasNumber numZero]

	% construct InstanceFound [opt else_clause]
		% OEC [getLastElseDone MD runningThdID WaitThrArrID waitCountID OEC CH]	
 	construct PlusOne [number]
		1
	% import schClisWaitThRemovePassed [number]
	% construct NewCount [number]
		% schClisWaitThRemovePassed [+ PlusOne]
	% export schClisWaitThRemovePassed
		% NewCount
	import schClget3rrdIfStmtDoneifExpSTMTPassed [number]
	export schClget3rrdIfStmtDoneifExpSTMTPassed 
		0

	construct NewCount [number]
		schClget3rrdIfStmtDoneifExpSTMTPassed [+ PlusOne]
	export schClget3rrdIfStmtDoneifExpSTMTPassed
		NewCount

	by
		'MUTATED 
		EX '; 
end rule

% rule getLastElseDone 
	% import schClgetThirdIfStmtDoneTransfOEC [number]
	% export schClgetThirdIfStmtDoneTransfOEC 
		% 0
		
	% construct  VARTYPE [type_specifier]
		% 'int
	% construct numOne [number]
		% '1
	% replace [variable_declaration]
		% RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	% where 
		 % TS [isVarOfType VARTYPE]

	% import tmpWaitCountID [id]		 
	% where all
		% VDS [matchesVarID tmpWaitCountID] [hasNumber numOne]
	% deconstruct VDS
		% LVD [list variable_declarator+]
	% deconstruct LVD
		% VN [variable_name] OEVI [opt equals_variable_initializer]
	% deconstruct VN
		% DN [declared_name] RD [repeat dimension]
	% deconstruct DN
		% intID [id] OGP [opt generic_parameter]    
	
	% import tmpintID [id]
	% export tmpintID
		% intID
	% % import SchOrdInterfacesIDColl [repeat id]
	% % construct InstanceFound [opt else_clause]
		% % OEC [isSchOrdInstDecl MD runningThdID WaitThrArrID intID OEC CH each SchOrdInterfacesIDColl]	
 	% construct PlusOne [number]
		% 1
	% % import schClgetLastElseDonePassed [number]
	% % construct NewCount [number]
		% % schClgetLastElseDonePassed [+ PlusOne]
	% % export schClgetLastElseDonePassed
		% % NewCount
	% construct NewCount [number]
		% schClgetThirdIfStmtDoneTransfOEC [+ PlusOne]
	% export schClgetThirdIfStmtDoneTransfOEC
		% NewCount
		
	% by
		% 'MUTATED RM TS VDS ';
% end rule

% rule isSchOrdInstDecl soiID [id]
	% import schClgetThirdIfStmtDoneTransfOEC [number]
	% export schClgetThirdIfStmtDoneTransfOEC 
		% 0
		
	% replace [variable_declaration]
		% RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	% where 
		 % TS [matchesVarID soiID]
	% deconstruct VDS
		% LVD [list variable_declarator+]
	% deconstruct LVD
		% VN [variable_name] OEVI [opt equals_variable_initializer]
	% deconstruct VN
		% DN [declared_name] RD [repeat dimension]
	% deconstruct DN
		% soiLocalID [id] OGP [opt generic_parameter]    
	
	% import tmpsoiID [id]
	% export tmpsoiID
		% soiID
	
	% import tmpsoiLocalID [id]
	% export tmpsoiLocalID
		% soiLocalID
	% % import schWaitReqArrsColl [repeat id]
	% % construct InstanceFound [opt else_clause]
		% % OEC [isNextRequAssigned MD runningThdID WaitThrArrID intID OEC soiID soiLocalID CH each schWaitReqArrsColl]	
 	% construct PlusOne [number]
		% 1
	% % import schClisSchOrdInstDeclPassed [number]
	% % construct NewCount [number]
		% % schClisSchOrdInstDeclPassed [+ PlusOne]
	% % export schClisSchOrdInstDeclPassed
		% % NewCount
	% construct NewCount [number]
		% schClgetThirdIfStmtDoneTransfOEC [+ PlusOne]
	% export schClgetThirdIfStmtDoneTransfOEC
		% NewCount
		
	% by
		% 'MUTATED RM TS VDS ';
% end rule

% rule isNextRequAssigned WaitReqArrsID [id]
	% import schClgetThirdIfStmtDoneTransfOEC [number]
	% export schClgetThirdIfStmtDoneTransfOEC 
		% 0
	
	% replace [expression_statement]
		% EX [expression] '; 
	% construct idGet [id]
		% 'get
	% construct numZero [number]
		% '0
	% deconstruct EX
		% AE [assignment_expression]

	% import tmpsoiLocalID [id]
	% import tmpsoiID [id]
	% import tmpintID [id]		
	% where all
		% AE [matchesVarID tmpsoiLocalID] [matchesVarID tmpsoiID] [matchesVarID WaitReqArrsID] [matchesVarID idGet] [matchesVarID tmpintID]

	% % construct InstanceFound [opt else_clause]
		% % OEC [isRunnThdAssigned MD runningThdID WaitThrArrID intID OEC CH]	
 	% construct PlusOne [number]
		% 1
	% % import schClisNextRequAssignedPassed [number]
	% % construct NewCount [number]
		% % schClisNextRequAssignedPassed [+ PlusOne]
	% % export schClisNextRequAssignedPassed
		% % NewCount
	% construct NewCount [number]
		% schClgetThirdIfStmtDoneTransfOEC [+ PlusOne]
	% export schClgetThirdIfStmtDoneTransfOEC
		% NewCount
 
	% by
		% 'MUTATED 
		% EX '; 
% end rule

% rule isRunnThdAssigned 
	% import schClgetThirdIfStmtDoneTransfOEC [number]
	% export schClgetThirdIfStmtDoneTransfOEC 
		% 0
	
	% replace [expression_statement]
		% EX [expression] '; 
	% construct idGet [id]
		% 'get
	% construct numZero [number]
		% '0
	% construct threadID2 [id]
		% 'Thread
	% deconstruct EX
		% AE [assignment_expression]
		
		
	% import tmpRunningThdID [id]
	% import tmpWaitThrArrID [id]
	% import tmpintID [id]		
	% where all
		% AE [matchesVarID tmpRunningThdID] [matchesVarID threadID2] [matchesVarID tmpWaitThrArrID] [matchesVarID idGet] [matchesVarID tmpintID]

	% % construct InstanceFound [opt else_clause]
		% % OEC [isRunnThdSynch MD runningThdID CH]	
  	% construct PlusOne [number]
		% 1
	% % import schClisRunnThdAssignedPassed [number]
	% % construct NewCount [number]
		% % schClisRunnThdAssignedPassed [+ PlusOne]
	% % export schClisRunnThdAssignedPassed
		% % NewCount
	% construct NewCount [number]
		% schClgetThirdIfStmtDoneTransfOEC [+ PlusOne]
	% export schClgetThirdIfStmtDoneTransfOEC
		% NewCount

	% by
		% 'MUTATED 
		% EX '; 
% end rule

% //*** SchedulerPattern:  Role = 1ba(Critical section creation by synchronization of thread Role 1aa.)
rule isRunnThdSynch MD [method_declarator] CH [class_header] 
	replace [synchronized_statement]
	    'synchronized '( EX [expression] ')
			BL2 [block] 		
			
	import tmpRunningThdID [id]
	where 
		EX [matchesVarID tmpRunningThdID]		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}	
		
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isRunnThdNotifyAll MD CH]
		
	import schClisRunnThdNotifyAllPassed [number]
	where
		schClisRunnThdNotifyAllPassed [> 0]
	export schClisRunnThdNotifyAllPassed 
		0
		
	construct TranformedBL2 [block] 
		'{                                        
			TransformedRDS3   
		'}	

  	construct PlusOne [number]
		1
	% import schClisRunnThdSynchPassed [number]
	% construct NewCount [number]
		% schClisRunnThdSynchPassed [+ PlusOne]
	% export schClisRunnThdSynchPassed
		% NewCount
	import schClgetThirdIfStmtDoneTransfOEC [number]
	export schClgetThirdIfStmtDoneTransfOEC 
		0
		
	construct NewCount [number]
		schClgetThirdIfStmtDoneTransfOEC [+ PlusOne]
	export schClgetThirdIfStmtDoneTransfOEC
		NewCount
		
	construct SchedulerAnnotation1bapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1bapt2 [stringlit]
		", roleID=1ba, roleDescription='Critical section creation by synchronization of thread Role 1aa.')"	
		
	import CountSchedulerClasses [number]
	% construct NewCountSchedulerClasses [number]
		% CountSchedulerClasses [+ PlusOne]

	by
		'MUTATED /* SchedulerAnnotation1bapt1 [+ CountSchedulerClasses] [+ SchedulerAnnotation1bapt2] */
	    'synchronized '( EX ')
		'{
			TranformedBL2  	
		'}
end rule

% //*** SchedulerPattern:  Role = 1baa(NotifyAll to wake up other waiting threads.);
rule isRunnThdNotifyAll MD [method_declarator] CH [class_header]
	replace [expression_statement]
		EX [expression] '; 
	construct idNotifyAll [id]
		'notifyAll
	deconstruct EX
		AE [assignment_expression]
		
	import tmpRunningThdID [id]
	where all
		AE [matchesVarID tmpRunningThdID] [matchesVarID idNotifyAll] 
		
	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]    
		
	construct PlusOne [number]
		1
		
	import schDoneMethColl [repeat id]
	construct newDoneMethIDs [repeat id]
		schDoneMethColl [. methodID]
	export schDoneMethColl
		newDoneMethIDs		
		
	% import schCntDoneMeth [number]
	% construct NewCount [number]
		% schCntDoneMeth [+ PlusOne]
	% export schCntDoneMeth
		% NewCount		 
 
 
	% import schCntRunningThread [number]
	% import schCntWaitThrArrs [number]
	% import schCntWaitReqArrs [number]
	% import schCntEnterMeth [number]	
	import schCntRunThWaitThArWtRqArEntMth [number]
	
	construct numZero [number]
		'0

	% where not
		% schCntRunningThread [hasNumber numZero]
	% where not
		% schCntWaitThrArrs [hasNumber numZero]
	% where not
		% schCntWaitReqArrs [hasNumber numZero]
	% where not
		% schCntEnterMeth [hasNumber numZero]		
	where not
		schCntRunThWaitThArWtRqArEntMth [hasNumber numZero]		
		
	% export schCntDoneMeth
		% numZero		 
	% export schCntRunningThread
		% numZero		 
	% export schCntWaitThrArrs
		% numZero		 
	% export schCntWaitReqArrs
		% numZero		 
	% export schCntEnterMeth
		% numZero		 
	export schCntRunThWaitThArWtRqArEntMth
		numZero		 
		

	deconstruct CH
		RM2 [repeat modifier] 'class CN [class_name] OEC [opt extends_clause] OIC [opt implements_clause]
	deconstruct CN
		DN2 [declared_name]
	deconstruct DN2
	   classID [id] OGP2 [opt generic_parameter]     
		
	import SchedulerClassIDColl [repeat id]
	construct newSchedulerClassIDs [repeat id]
		SchedulerClassIDColl [. classID]
	export SchedulerClassIDColl
		newSchedulerClassIDs		
				
	import CountSchedulerClasses [number]
	construct NewCountb [number]
		CountSchedulerClasses [+ PlusOne]
	export CountSchedulerClasses
		NewCountb		 
		
 	import schClisRunnThdNotifyAllPassed [number]
	construct NewCount [number]
		schClisRunnThdNotifyAllPassed [+ PlusOne]
	export schClisRunnThdNotifyAllPassed
		NewCount

	construct SchedulerAnnotation1baapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation1baapt2 [stringlit]
		", roleID=1baa, roleDescription='NotifyAll to wake up other waiting threads.')"	

	by
		'MUTATED /* SchedulerAnnotation1baapt1 [+ CountSchedulerClasses] [+ SchedulerAnnotation1baapt2] */
		EX '; 
end rule


% //*** SchedulerPattern:  Role = 4(Processor object - delegates scheduling of the request objects processing to the Scheduler object one at a time. 
% //								** Contains Role 4a.
% //								** Contains Role 4b.); 
rule findProcessorClass
	replace [class_declaration]
	    CH [class_header] CB [class_body]
	import SchedulerClassIDColl [repeat id]
	construct TransformedCB [class_body]
		CB [findProcSchedInst each SchedulerClassIDColl] [findProcMethUsingSch CH]

	construct numZero [number]
		'0
	import CountProcessorObjs [number]
	import preCntProcessorObjs [number]
	where not
		CountProcessorObjs [hasNumber numZero]
	where
		CountProcessorObjs [> preCntProcessorObjs]		

	construct SchedulerAnnotation4pt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation4pt2 [stringlit]
		", roleID=4, roleDescription='Processor object - delegates scheduling of the request objects processing to the Scheduler object one at a time.')"	

	by
		'MUTATED /* SchedulerAnnotation4pt1 [+ CountProcessorObjs] [+ SchedulerAnnotation4pt2] */ CH TransformedCB
end rule

% ///*** SchedulerPattern:  Role = 4a(Creation of an instance of the Scheduler object (Role 1) outside of any method within Processor class(Role 4).);
rule findProcSchedInst schClassID [id]
	import CountProcessorObjs [number]
	import preCntProcessorObjs [number]
	export preCntProcessorObjs 
		CountProcessorObjs

	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where 
		 TS [matchesVarID schClassID]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		procSchInstID [id] OGP [opt generic_parameter]    
		
	export tmpprocSchInstID [id]
		procSchInstID
	
	% construct ProcMethUsingSchFound [class_body]
		% CB [findProcMethUsingSch CH procSchInstID] 
		
	construct SchedulerAnnotation4apt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation4apt2 [stringlit]
		", roleID=4a, roleDescription='Creation of an instance of the Scheduler object (Role 1) outside of any method within Processor class(Role 4).')"	
		
	construct NewCountProcessorObjs [number]
		CountProcessorObjs [+ 1]

	by
		'MUTATED /* SchedulerAnnotation4apt1 [+ NewCountProcessorObjs] [+ SchedulerAnnotation4apt2] */ RM TS VDS ';
end rule

% //*** SchedulerPattern:  Role = 4b(Method with a parameter that is an instance of the Request object (Role 2) that carries out the main required functionality. 
% //								** Contains Role 4ba.
% //								** Contains Role 4bb.); 
rule findProcMethUsingSch CH [class_header] 
	replace [method_declaration] 
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]    
	
	construct theMethUsingSchParams [list formal_parameter]
		LFP [getParamsInMethUsingSch]	
		
	construct numZero [number]
		'0
	import procClMethUsingSchParamCnt [number]
	where not
		procClMethUsingSchParamCnt [hasNumber numZero]
		
	construct TransformedMB [method_body]
		MB [findSchEnterMethUse] [findSchDoneMethUse CH]
		
	construct SchedulerAnnotation4bpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation4bpt2 [stringlit]
		", roleID=4b, roleDescription='Method with a parameter that is an instance of the Request object (Role 2) that carries out the main required functionality.')"	
		
	import CountProcessorObjs [number]

	by
		'MUTATED /* SchedulerAnnotation4bpt1 [+ CountProcessorObjs] [+ SchedulerAnnotation4bpt2] */ RM TS MD OT TransformedMB 
end rule

% //*** SchedulerPattern:  Role = 4b(Method with a parameter that is an instance of the Request object (Role 2).....cont'd
rule getParamsInMethUsingSch
	replace [formal_parameter]
		RA [repeat annotation] OF [opt 'final] TS [type_specifier] OV [opt var_arg_specifier] FPN [formal_parameter_name]	 
		
	deconstruct TS
        TN [type_name] 
	deconstruct TN
		QN [qualified_name]
	deconstruct QN
		REF [reference]
	deconstruct REF
		typeSpecID [id] RC [repeat component]  	

	import RqObjImplSchOrdIntsColl [repeat id]
	where
		 typeSpecID [matchesVarID each RqObjImplSchOrdIntsColl]
	
	deconstruct FPN
		VN [variable_name]
	deconstruct VN
	    DN [declared_name] RD [repeat dimension]
	deconstruct DN
	   paramID [id] OGP [opt generic_parameter]  
	
	import procClMethUsingSchParamIDColl [repeat id]
	construct newParamIDs [repeat id]
		procClMethUsingSchParamIDColl [. paramID]
	export procClMethUsingSchParamIDColl
		newParamIDs  	
		
	import procClMethUsingSchParamCnt [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		procClMethUsingSchParamCnt [+ PlusOne]
	export procClMethUsingSchParamCnt
		NewCount		 
	
	by
		'MUTATED RA OF TS OV FPN 
end rule

% //*** SchedulerPattern:  Role = 4ba(Call to the method (Role 1a) of the instance (Role 4a) of the Scheduler object (Role 1).  Occurs before any processing in method Role 4b.);
rule findSchEnterMethUse
	replace [expression_statement]
		EX [expression] '; 
	deconstruct EX
		AE [assignment_expression]
		
	import tmpprocSchInstID [id]	
	where 
		AE [matchesVarID tmpprocSchInstID] 
		
	import schEnterMethColl [repeat id]
	where
		AE [matchesVarID each schEnterMethColl]
		
	import procClMethUsingSchParamIDColl [repeat id]
	where
		AE [matchesVarID each procClMethUsingSchParamIDColl]

	% construct SchDoneMethUseFound [method_body]
		% MB [findSchDoneMethUse CH procSchInstID MB methodID]
	import CountProcessorObjs [number]
	construct NewCountProcessorObjs [number]
		CountProcessorObjs [+ 1]
	
	construct SchedulerAnnotation4bapt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation4bapt2 [stringlit]
		", roleID=4ba, roleDescription='Call to the method (Role 1a) of the instance (Role 4a) of the Scheduler object (Role 1).  Occurs before any processing in method Role 4b.')"	

	by
		'MUTATED /* SchedulerAnnotation4bapt1 [+ NewCountProcessorObjs] [+ SchedulerAnnotation4bapt2] */
		EX '; 

end rule

% //*** SchedulerPattern:  Role = 4bb(Call to the method (Role 1b) of the instance (Role 4a) of the Scheduler object (Role 1).  Occurs after all processing in method Role 4b.);
rule findSchDoneMethUse CH [class_header] 
	replace [expression_statement]
		EX [expression] '; 
	deconstruct EX
		AE [assignment_expression]
		
	import tmpprocSchInstID [id]	
	where 
		AE [matchesVarID tmpprocSchInstID] 
		
	import schDoneMethColl [repeat id]
	where
		AE [matchesVarID each schDoneMethColl]
		
	deconstruct CH
		RM2 [repeat modifier] 'class CN [class_name] OEC [opt extends_clause] OIC [opt implements_clause]
	deconstruct CN
		DN2 [declared_name]
	deconstruct DN2
	   classID [id] OGP2 [opt generic_parameter]     

	construct PlusOne [number]
		1
		
	% import procClMethUsingSchColl [repeat id]
	% construct newMethUsingSchIDs [repeat id]
		% procClMethUsingSchColl [. methodID]
	% export procClMethUsingSchColl
		% newMethUsingSchIDs
		
	% import procClCntMethUsingSch [number]
	% construct NewCount [number]
		% procClCntMethUsingSch [+ PlusOne]
	% export procClCntMethUsingSch
		% NewCount		 
		
	import ProcessorObjIDColl [repeat id]
	construct newProcObjIDs [repeat id]
		ProcessorObjIDColl [. classID]
	export ProcessorObjIDColl
		newProcObjIDs
		
	import CountProcessorObjs [number]
	construct NewCountb [number]
		CountProcessorObjs [+ PlusOne]
	export CountProcessorObjs
		NewCountb		 
		
	import CountSchedulerClasses [number]
	import CountRqObjImplSchOrdInts [number]
	import CountSchOrdInterfaces [number]
	construct numZero [number]
		'0
	where not
		CountSchedulerClasses [hasNumber numZero]
	where not
		CountRqObjImplSchOrdInts [hasNumber numZero]
	where not
		CountSchOrdInterfaces [hasNumber numZero]
		
	import Counter [number]
	construct NewCountc [number]
		Counter [+ PlusOne]
	export Counter
		NewCountc	
		
	construct SchedulerAnnotation4bbpt1 [stringlit]
		"@SchedulerPatternAnnotation(patternInstanceID="
	construct SchedulerAnnotation4bbpt2 [stringlit]
		", roleID=4bb, roleDescription='Call to the method (Role 1b) of the instance (Role 4a) of the Scheduler object (Role 1).  Occurs after all processing in method Role 4b.')"	

	by
		'MUTATED /* SchedulerAnnotation4bbpt1 [+ CountProcessorObjs] [+ SchedulerAnnotation4bbpt2] */
		EX '; 
end rule


% Function to check if it is a variable of a specific type.
function isVarOfType VARTYPE [type_specifier]
	match * [type_specifier]
		VARTYPE
end function

% Function to check if a specific modifier is being used.
function isMethodModifier MODIFIER [modifier]
	match * [modifier]
		MODIFIER
end function

% Function to check if the synchronized modifier is being used by the "this" keyword.
function isMethodSynchdUsingThis THIS [expression]
	match * [expression]
		THIS
end function

% Function to check if there is a match to a variable ID.
function matchesVarID theID [id]
	match * [id]
		theID
end function

% Function to check if there is a match to an assignment operator.
function matchesAssignOp theAssignOp [assignment_operator]
	match * [assignment_operator]
		theAssignOp
end function

% Function to check if there is a match to one of the equality operators ('== | '!=).
function matchesEqOp theEqOp [equality_op]
	match * [equality_op]
		theEqOp
end function

% Function to check if there is a match to one of the relational operators ('<  | '> | '<= | '>=).
function matchesRelOp theRelOp [relational_op]
	match * [relational_op]
		theRelOp
end function

% Function to check if there is a match to one of the post_inc_dec operators ('++ | '--).
function matchesPostIncDec theOp [post_inc_dec]
	match * [post_inc_dec]
		theOp
end function

% Function to check if there is a match to the keyword "null".
function hasNull theNull [null_literal]
	match * [null_literal]
		theNull
end function

% Function to check if the expression exists in the statment.
function hasExpression theExpression [expression]
	match * [expression]
		theExpression
end function

% Function to check if the statement is a match.
function hasStmt stmtToMatch [statement]
	match * [statement]
		stmtToMatch
end function

% Function to check if there is a match to a specific number.
function hasNumber theNumber [number]
	match * [number]
		theNumber
end function



