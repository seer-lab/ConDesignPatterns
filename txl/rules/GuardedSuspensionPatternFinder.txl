% Guarded Suspension Pattern (a Concurrency Design Pattern) Finder for Java Concurrent Software
% Martin Mwebesa
% UOIT, April 19, 2011

% include "Java.Grm"
include "../grammar/java5.grm"
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
end redefine

define variable_declaration2
    [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
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


function main
	export Counter [number]
		0
	export CountFirstSynchMethIDs [number]
		0
	export CountSecondSynchMethIDs [number]
		0
	export tmpRole1Passed [number]
		0
	export tmpRole2Passed [number]
		0
	export alreadyPrintedOutput [number]
		0
	export numVarsIDCollection [repeat id]
		_
 	export FirstSynchMethIDs [repeat id]
		_
 	export SecondSynchMethIDs [repeat id]
		_
  	export notifyCollection [repeat expression]
		_
	export waitCollection [repeat expression]
		_
	replace [program]
        P [program]
	construct TransformedProgram [stringlit]
		"TransformedForGuardSuspPatt.java"
	by
		P [findGuardedSuspensionPattern]
		[printOutput] [printOutput2] [printOutput3] [printFirstSynchMethIDs] [printSecondSynchMethIDs]
		[fput TransformedProgram]
		% P [findGuardedSuspensionPattern]
		% [printPatternNotFound] [printOutput] [printOutput2] [printOutput3] [printFirstSynchMethIDs] [printSecondSynchMethIDs] [printNotifyCollection] [printWaitCollection]
		% [fput TransformedProgram]
end function

function printPatternNotFound
	replace [program]
		P [program]

	import Counter [number]

	where
		Counter [= 0]

	construct InstanceFound [stringlit]
		"*** No complete instances of Guarded Suspension Pattern found. "

	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]

	by
		P
end function

% Function print out the number of Guarded Suspension design pattern instances found.
function printOutput
	replace [program]
		P [program]

	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountFirstSynchMethIDs [number]
	import CountSecondSynchMethIDs [number]

	where
		Counter [> 0]
	where
		Counter [= CountFirstSynchMethIDs]
	where
		Counter [= CountSecondSynchMethIDs]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Guarded Suspension Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]
	by
		P
end function

% Function print out the number of Guarded Suspension design pattern instances found.
function printOutput2
	replace [program]
		P [program]
	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountFirstSynchMethIDs [number]
	import CountSecondSynchMethIDs [number]
	where
		Counter [> CountFirstSynchMethIDs] [= CountFirstSynchMethIDs]
	where
		alreadyPrintedOutput [= 0]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Guarded Suspension Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ CountFirstSynchMethIDs] [print]
	by
		P
end function

% Function print out the number of Guarded Suspension design pattern instances found.
function printOutput3
	replace [program]
		P [program]
	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountFirstSynchMethIDs [number]
	import CountSecondSynchMethIDs [number]
	where
		Counter [> CountSecondSynchMethIDs] [= CountSecondSynchMethIDs]
	where
		alreadyPrintedOutput [= 0]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Guarded Suspension Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ CountSecondSynchMethIDs] [print]
	by
		P
end function

% Function to print out the names of the 1st synchronized method (ones with a nofity or notifyAll statement within)
% that are used within the Guarded Suspension design pattern.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printFirstSynchMethIDs
	replace [program]
		P [program]
	import Counter [number]
	import CountFirstSynchMethIDs [number]
	import FirstSynchMethIDs [repeat id]
	% where
		% Counter [> 0]
	where
		CountFirstSynchMethIDs [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 1.  Synchronized method instances with notifies within.  Used within the instance of the Guarded Suspension Design Pattern.  "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintFirstSynchMethIDs each FirstSynchMethIDs]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printFirstSynchMethIDs".
function thePrintFirstSynchMethIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function

% Function to print out the names of the 2nd synchronized method (ones with a while loop and wait statement within)
% that are used within the Guarded Suspension design pattern.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printSecondSynchMethIDs
	replace [program]
		P [program]
	import Counter [number]
	import SecondSynchMethIDs [repeat id]
	import CountSecondSynchMethIDs [number]
	% where
		% Counter [> 0]
	where
		CountSecondSynchMethIDs [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 2.  Synchronized methods instances with while loops and wait statements within.  Used within the instance of the Guarded Suspension Design Pattern:  "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintSecondSynchMethIDs each SecondSynchMethIDs]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printSecondSynchMethIDs".
function thePrintSecondSynchMethIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function

% Function to print out the names of the notify expressions used in the methods printed out in the "printFirstSynchMethIDs" function.
% The number of these expressions should equal the number of First Synchronized method names printed out in the "printFirstSynchMethIDs" function.
function printNotifyCollection
	replace [program]
		P [program]
	import Counter [number]
	import CountFirstSynchMethIDs [number]
	import notifyCollection [repeat expression]
	% where
		% Counter [> 0]
	where
		CountFirstSynchMethIDs [> 0]
	construct InstanceFound [stringlit]
		"** Methods above respectively use the following Notify expression statements:  "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintNotifyCollection each notifyCollection]
	by
		P
end function

% Function to aid in the printing of the names of the notify expressions in the function "printNotifyCollection".
function thePrintNotifyCollection theNotify [expression]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [expression]
		theNotify [print]
	replace [program]
		P [program]
	by
		P
end function

% Function to print out the names of the wait expressions used in the methods printed out in the "printSecondSynchMethIDs" function.
% The number of these expressions should equal the number of Second Synchronized method names printed out in the "printSecondSynchMethIDs" function.
function printWaitCollection
	replace [program]
		P [program]
	import Counter [number]
	import waitCollection [repeat expression]
	import CountSecondSynchMethIDs [number]
	% where
		% Counter [> 0]
	where
		CountSecondSynchMethIDs [> 0]

	construct InstanceFound [stringlit]
		"** The following expressions in the methods above respectively use wait statements:  "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintWaitCollection each waitCollection]
	by
		P
end function

% Function to aid in the printing of the names of the wait expressions in the function "printWaitCollection".
function thePrintWaitCollection theStmt [expression]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [expression]
		theStmt [print]
	replace [program]
		P [program]
	by
		P
end function


% //*****************************************************************************************//
% //*** Guarded Suspension pattern:                                                      ***//
% //*** If a condition that prevents a method from executing exists, this design pattern ***//
% //*** allows for the suspension of that method until that condition no longer exists . ***//
% //****************************************************************************************//
rule findGuardedSuspensionPattern
	replace [class_declaration]
	    CH [class_header] CB [class_body]
	construct NumVarInstancesFound [class_body]
		CB [findAllNumberVars]
	construct TransformedClassBody [class_body]
		CB [find1stSynchMethod1] [find1stSynchMethod2] [find2ndSynchMethod1] [find2ndSynchMethod2]

	% import Counter [number]
	% where
		% Counter [> 0]

	by
		'MUTATED CH TransformedClassBody
end rule

rule findAllNumberVars
	construct  VARTYPE [type_specifier]
		'short
	construct  VARTYPE2 [type_specifier]
		'int
	construct  VARTYPE3 [type_specifier]
		'long
	construct  VARTYPE4 [type_specifier]
		'float
	construct  VARTYPE5 [type_specifier]
		'double
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where
		 TS [isVarOfType VARTYPE] [isVarOfType VARTYPE2] [isVarOfType VARTYPE3] [isVarOfType VARTYPE4] [isVarOfType VARTYPE5]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		objectID [id] OGP [opt generic_parameter]
	import numVarsIDCollection [repeat id]
	construct newIDCollection [repeat id]
		numVarsIDCollection [. objectID]
	export numVarsIDCollection
		newIDCollection
	by
		'MUTATED RM TS VDS ';
end rule

% //***GuardedSuspensionPattern:  Role = 1(Ensuring a method in the class is synchronized - guarded.
% //								** Contains Role 1a.);
% First Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method does the nofifying
% that a condition that prevented execution no longer exists.
rule find1stSynchMethod1
	construct  SYNCH [modifier]
		'synchronized
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	where
		RM [isMethodSynchronized SYNCH]
	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [hasNotifyOrNofityAll MD]

	import tmpRole1Passed [number]
	where
		tmpRole1Passed [> 0]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}

	construct TransformedMB [method_body]
		TransformedBL2

	construct GuardedSuspensionAnnotation1pt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation1pt2 [stringlit]
		", roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"

	import CountFirstSynchMethIDs [number]

	export tmpRole1Passed
		0

	by
		'MUTATED /* GuardedSuspensionAnnotation1pt1 [+ CountFirstSynchMethIDs] [+ GuardedSuspensionAnnotation1pt2] */ RM TS MD OT TransformedMB
end rule

% //***GuardedSuspensionPattern:  Role = 1(Ensuring a method in the class is synchronized - guarded.
% //								** Contains Role 1a.);
% Second Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method does the nofifying
% that a condition that prevented execution no longer exists.
rule find1stSynchMethod2
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
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [hasNotifyOrNofityAll MD]

	import tmpRole1Passed [number]
	where
		tmpRole1Passed [> 0]

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

	construct GuardedSuspensionAnnotation1pt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation1pt2 [stringlit]
		", roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"

	import CountFirstSynchMethIDs [number]

	export tmpRole1Passed
		0

	by
		'MUTATED /* GuardedSuspensionAnnotation1pt1 [+ CountFirstSynchMethIDs] [+ GuardedSuspensionAnnotation1pt2] */ RM TS MD OT TransformedMB
end rule

% //***GuardedSuspensionPattern:  Role = 1a(Ensure there is a nofify() or notifyAll() statement.);
rule hasNotifyOrNofityAll MD [method_declarator]
	replace [expression_statement]
		EX [expression] ';
	construct idNotify [id]
		'notify
	construct idNotifyAll [id]
		'notifyAll
	construct idNotifyExpr [assignment_expression]
		'notify()
	construct idNotifyAllExpr [assignment_expression]
		'notifyAll()

	deconstruct EX
		AE [assignment_expression]
	where
		AE [isAssignmentExpr idNotifyExpr] [isAssignmentExpr idNotifyAllExpr]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	import FirstSynchMethIDs [repeat id]
	construct newMethodIDs [repeat id]
		FirstSynchMethIDs [. methodID]
	export FirstSynchMethIDs
		newMethodIDs

	import CountFirstSynchMethIDs [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		CountFirstSynchMethIDs [+ PlusOne]
	export CountFirstSynchMethIDs
		NewCount

	import notifyCollection [repeat expression]
	construct newNotifyCollection [repeat expression]
		notifyCollection [. EX]
	export notifyCollection
		newNotifyCollection

	import tmpRole1Passed [number]
	construct tmpCount [number]
		tmpRole1Passed [+ PlusOne]
	export tmpRole1Passed
		tmpCount

	construct GuardedSuspensionAnnotation1apt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation1apt2 [stringlit]
		", roleID=1a, roleDescription='Ensure there is a nofify() or notifyAll() statement.')"

	by
		'MUTATED
		/* GuardedSuspensionAnnotation1apt1 [+ CountFirstSynchMethIDs] [+ GuardedSuspensionAnnotation1apt2] */
		EX ';
end rule


% //***GuardedSuspensionPattern:  Role = 2(Ensuring a method in the class is synchronized - guarded.
% //								** Contains Role 2a.);
% First Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method does the nofifying
% that a condition that prevented execution no longer exists.
rule find2ndSynchMethod1
	construct  SYNCH [modifier]
		'synchronized
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	where
		RM [isMethodSynchronized SYNCH]
	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isWhileLpWait MD] [isDoWhileLpWait MD]

	import tmpRole2Passed [number]
	where
		tmpRole2Passed [> 0]

	% import CountFirstSynchMethIDs [number]
	% import CountSecondSynchMethIDs [number]
	% where
		% CountSecondSynchMethIDs [< CountFirstSynchMethIDs] [= CountFirstSynchMethIDs]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}

	construct TransformedMB [method_body]
		TransformedBL2

	construct GuardedSuspensionAnnotation2pt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation2pt2 [stringlit]
		", roleID=2, roleDescription='Ensuring a method in the class is synchronized - guarded')"

	import Counter [number]

	export tmpRole2Passed
		0

	by
		'MUTATED /* GuardedSuspensionAnnotation2pt1 [+ Counter] [+ GuardedSuspensionAnnotation2pt2] */ RM TS MD OT TransformedMB


end rule

% //***GuardedSuspensionPattern:  Role = 2(Ensuring a method in the class is synchronized - guarded.
% //								** Contains Role 2a.);
% Second Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method does the nofifying
% that a condition that prevented execution no longer exists.
rule find2ndSynchMethod2
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
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isWhileLpWait MD] [isDoWhileLpWait MD]

	import tmpRole2Passed [number]
	where
		tmpRole2Passed [> 0]

	% import CountFirstSynchMethIDs [number]
	% import CountSecondSynchMethIDs [number]
	% where
		% CountSecondSynchMethIDs [< CountFirstSynchMethIDs] [= CountFirstSynchMethIDs]

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

	construct GuardedSuspensionAnnotation2pt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation2pt2 [stringlit]
		", roleID=2, roleDescription='Ensuring a method in the class is synchronized - guarded')"

	import Counter [number]

	export tmpRole2Passed
		0

	by
		'MUTATED /* GuardedSuspensionAnnotation2pt1 [+ Counter] [+ GuardedSuspensionAnnotation2pt2] */ RM TS MD OT TransformedMB

end rule

% //***GuardedSuspensionPattern:  Role = 2a(Ensuring there is a while statement.
%//								** Contains Role 2aa.);
% //***GuardedSuspensionPattern:  Role = 2aa(Ensuring there is a wait() statement.);
rule isWhileLpWait MD [method_declarator]
	replace [while_statement]
	    'while '( EX [expression] ')
			STMT [statement]

	construct waitStmt [statement]
		'wait();
	import numVarsIDCollection [repeat id]
	where
		STMT [hasStmt waitStmt] [hasWaitStmt each numVarsIDCollection]

	construct GuardedSuspensionAnnotation2apt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation2apt2 [stringlit]
		", roleID=2a, roleDescription='Ensuring there is a while statement.')"

	construct GuardedSuspensionAnnotation2aapt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation2aapt2 [stringlit]
		", roleID=2aa, roleDescription='Ensuring there is a wait() statement.')"

	construct InstanceFound [method_declarator]
		MD [completeStats MD EX]

	import Counter [number]

	by
		'MUTATED /* GuardedSuspensionAnnotation2apt1 [+ Counter] [+ GuardedSuspensionAnnotation2apt2] */
	    'while '( EX ')
		{
			/* GuardedSuspensionAnnotation2aapt1 [+ Counter] [+ GuardedSuspensionAnnotation2aapt2] */
			STMT
		}
end rule

% //***GuardedSuspensionPattern:  Role = 2a(Ensuring there is a while statement.
%//								** Contains Role 2aa.);
% //***GuardedSuspensionPattern:  Role = 2aa(Ensuring there is a wait() statement.);
rule isDoWhileLpWait MD [method_declarator]
	replace [do_statement]
		'do
			 STMT [statement]
		'while '( EX [expression] ') ';

	construct waitStmt [statement]
		'wait();
	import numVarsIDCollection [repeat id]
	where
		STMT [hasStmt waitStmt] [hasWaitStmt each numVarsIDCollection]

	construct GuardedSuspensionAnnotation2apt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation2apt2 [stringlit]
		", roleID=2a, roleDescription='Ensuring there is a while statement.')"

	construct GuardedSuspensionAnnotation2aapt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation2aapt2 [stringlit]
		", roleID=2aa, roleDescription='Ensuring there is a wait() statement.')"

	construct InstanceFound [method_declarator]
		MD [completeStats MD EX]

	import Counter [number]

	by
		'MUTATED /* GuardedSuspensionAnnotation2apt1 [+ Counter] [+ GuardedSuspensionAnnotation2apt2] */
		'do
		{
			/* GuardedSuspensionAnnotation2aapt1 [+ Counter] [+ GuardedSuspensionAnnotation2aapt2] */
			STMT
		}
		'while '( EX ') ';
end rule

function completeStats MD [method_declarator]  EX [expression]
	replace [method_declarator]
		MD
	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	import SecondSynchMethIDs [repeat id]
	construct newMethodIDs [repeat id]
		SecondSynchMethIDs [. methodID]
	export SecondSynchMethIDs
		newMethodIDs

	import waitCollection [repeat expression]
	construct newWaitCollection [repeat expression]
		waitCollection [. EX]
	export waitCollection
		newWaitCollection

	import CountSecondSynchMethIDs [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		CountSecondSynchMethIDs [+ PlusOne]
	export CountSecondSynchMethIDs
		NewCount

	import CountFirstSynchMethIDs [number]
	construct numZero [number]
	'0

	where not
		CountFirstSynchMethIDs [hasNumber numZero]
	where not
		CountSecondSynchMethIDs [hasNumber numZero]

	import tmpRole2Passed [number]
	construct tmpCount [number]
		tmpRole2Passed [+ PlusOne]
	export tmpRole2Passed
		tmpCount

	% import CountFirstSynchMethIDs [number]
	% import CountSecondSynchMethIDs [number]
	% where
		% CountSecondSynchMethIDs [< CountFirstSynchMethIDs] [= CountFirstSynchMethIDs]

	import Counter [number]
	construct NewCountb [number]
		Counter [+ PlusOne]
	export Counter
		NewCountb

	by
		MD
end function

% Function to check if the synchronized modifier is being used.
function isMethodSynchronized SYNCH [modifier]
	match * [modifier]
		SYNCH
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

% Function to check if the assignment expression exists.
function isAssignmentExpr AE [assignment_expression]
	match * [assignment_expression]
		AE
end function

% Function to check if it is a variable of a specific type.
function isVarOfType VARTYPE [type_specifier]
	match * [type_specifier]
		VARTYPE
end function

function hasWaitStmt idToMatch [id]
	match * [statement]
		'wait( idToMatch ');
end function
