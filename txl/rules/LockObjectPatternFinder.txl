% Lock Object Pattern (a Concurrency Design Pattern) Finder for Java Concurrent Software
% Martin Mwebesa
% UOIT, April 20, 2011

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


function main
	export Counter [number]
		0
	export CountRole1 [number]
		0
	export CountGetLockObjectMethIDs [number]
		0
	export CountMethIDsUsingLockObjs [number]
		0
	export tmpRole2Passed [number]
		0
	export tmpRole3Passed [number]
		0
	export alreadyPrintedOutput [number]
		0
 	export getLockObjectMethIDs [repeat id]
		_
	export objectIDCollection [repeat id]
		_
	export methIDsUsingLockObj [repeat id]
		_
	replace [program]
        P [program]
	construct TransformedProgram [stringlit]
		"TransformedForLockObjPatt.java"
	by
		P [findLockObjectPattern]
		[printOutput] [printOutput1] [printOutput2] [printOutput3] [printLockObjectIDs] [printLockObjectMethIDs] [printMethIDsUsingLockObj]
		[fput TransformedProgram]
		% P [findLockObjectPattern]
		% [printPatternNotFound] [printOutput] [printOutput1] [printOutput2] [printOutput3] [printLockObjectIDs] [printLockObjectMethIDs] [printMethIDsUsingLockObj]
		% [fput TransformedProgram]
end function


function printPatternNotFound
	replace [program]
		P [program]

	import Counter [number]

	where
		Counter [= 0]

	construct InstanceFound [stringlit]
		"*** No instances of Lock Object Pattern found. "

	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]

	by
		P
end function

% Function print out the number of Lock Object design pattern instances found.
function printOutput
	replace [program]
		P [program]

	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountRole1 [number]
	import CountGetLockObjectMethIDs [number]
	import CountMethIDsUsingLockObjs [number]

	where
		Counter [> 0]
	where
		Counter [= CountRole1]
	where
		Counter [= CountGetLockObjectMethIDs]
	where
		Counter [= CountMethIDsUsingLockObjs]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Lock Object Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]
	by
		P
end function

% Function print out the number of Lock Object design pattern instances found.
function printOutput1
	replace [program]
		P [program]

	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountRole1 [number]
	import CountGetLockObjectMethIDs [number]
	import CountMethIDsUsingLockObjs [number]

	where
		alreadyPrintedOutput [= 0]
	where
		CountRole1 [< Counter] [= Counter]
	where
		CountRole1 [< CountGetLockObjectMethIDs] [= CountGetLockObjectMethIDs]
	where
		CountRole1 [< CountMethIDsUsingLockObjs] [= CountMethIDsUsingLockObjs]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Lock Object Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]
	by
		P
end function

% Function print out the number of Lock Object design pattern instances found.
function printOutput2
	replace [program]
		P [program]

	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountRole1 [number]
	import CountGetLockObjectMethIDs [number]
	import CountMethIDsUsingLockObjs [number]

	where
		alreadyPrintedOutput [= 0]
	where
		CountGetLockObjectMethIDs [< Counter] [= Counter]
	where
		CountGetLockObjectMethIDs [< CountRole1] [= CountRole1]
	where
		CountGetLockObjectMethIDs [< CountMethIDsUsingLockObjs] [= CountMethIDsUsingLockObjs]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Lock Object Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]
	by
		P
end function

% Function print out the number of Lock Object design pattern instances found.
function printOutput3
	replace [program]
		P [program]

	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountRole1 [number]
	import CountGetLockObjectMethIDs [number]
	import CountMethIDsUsingLockObjs [number]

	where
		alreadyPrintedOutput [= 0]
	where
		CountMethIDsUsingLockObjs [< Counter] [= Counter]
	where
		CountMethIDsUsingLockObjs [< CountGetLockObjectMethIDs] [= CountGetLockObjectMethIDs]
	where
		CountMethIDsUsingLockObjs [< CountRole1] [= CountRole1]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Lock Object Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]
	by
		P
end function

% Function to print out the potential lock object ids - Role 1.
function printLockObjectIDs
	replace [program]
		P [program]
	import objectIDCollection [repeat id]
	% import Counter [number]
	% where
		% Counter [> 0]
	import CountRole1 [number]
	where
		CountRole1 [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 1:  Lock objects. "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintLockObjIDs each objectIDCollection]
	by
		P
end function

% Function to aid in the printing of the lock object IDs in the function "printLockObjectIDs".
function thePrintLockObjIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function

% Function to print out the lock object methods that return the lock object.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printLockObjectMethIDs
	replace [program]
		P [program]
	import getLockObjectMethIDs [repeat id]
	% import Counter [number]
	% where
		% Counter [> 0]
	import CountGetLockObjectMethIDs [number]
	where
		CountGetLockObjectMethIDs [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 2:  Lock object methods - methods returning the lock object. "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintLockObjMethIDs each getLockObjectMethIDs]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printLockObjectMethIDs".
function thePrintLockObjMethIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function

% Function to print out the names of the methods that actually used the lock object.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printMethIDsUsingLockObj
	replace [program]
		P [program]
	import methIDsUsingLockObj [repeat id]
	% import Counter [number]
	% where
		% Counter [> 0]
	import CountMethIDsUsingLockObjs [number]
	where
		CountMethIDsUsingLockObjs [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 3:  Method instances where the lock object is actually used:  "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintMethIDsUsingLockObj each methIDsUsingLockObj]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printInterruptMethIDs".
function thePrintMethIDsUsingLockObj theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function


% //************************************************************************************************//
% //*** Lock Object pattern:                                                                     ***//
% //*** This design pattern is a refinement of the Single Threaded Executio design pattern.      ***//
% //*** It enables a single thread to have exclusive access to multiple objects.                 ***//
% //*** To avoid a thread having to obtain a lock on every single object it needs                ***//
% //*** (consuming lots of overhead), the solution offered by this design pattern is to          ***//
% //*** have threads acquire a synchronization lock on an object created for the sole            ***//
% //*** purpose of being the subject of locks, before continuing with any operations.            ***//
% //*** This object is referred to as a lock object hence the name of the pattern.               ***//
% //*** NB:  For the purposes of our experiment we will focus on one common method.              ***//
% //*** 		creating a static method in the class e.g. getLockObject() that returns a lock     ***//
% //*** 		(the sole lock).  Subclasses of this class call this method to get the lock object ***//
% //*** 		to synchronize operations in the program.                                          ***//
% //************************************************************************************************//
% rule findLockObjectPattern
	% replace [class_declaration]
	    % CH [class_header] CB [class_body]
	% construct ObjectInstancesFound [class_body]
		% CB [findObjectInstances]
	% construct GetLockObjectMethodsFound [class_body]
		% CB [findGetLockObjectMethods]
	% construct SynchCallsToGetLockObjMethsFound [class_body]
		% CB [findSynchCallsToGetLockObjMeths]
	% by
		% 'MUTATED CH CB
% end rule
rule findLockObjectPattern
	replace [class_declaration]
	    CH [class_header] CB [class_body]
	construct TransformedClassBody [class_body]
		CB [findObjectInstances] [findGetLockObjectMethods] [findSynchCallsToGetLockObjMeths]
	by
		'MUTATED CH TransformedClassBody
end rule


% //***LockObjectPattern:  Role = 1(Creation of static object in a class - lock object.);
rule findObjectInstances
	construct  VARTYPE [type_specifier]
		'Object
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
		objectID [id] OGP [opt generic_parameter]
	import objectIDCollection [repeat id]
	construct newIDCollection [repeat id]
		objectIDCollection [. objectID]
	export objectIDCollection
		newIDCollection

	import CountRole1 [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		CountRole1 [+ PlusOne]
	export CountRole1
		NewCount

	construct LockObjectAnnotation1pt1 [stringlit]
		"@LockObjectPatternAnnotation(patternInstanceID="
	construct LockObjectAnnotation1pt2 [stringlit]
		", roleID=1, roleDescription='Creation of static object in a class - lock object.')"

	by
		'MUTATED /* LockObjectAnnotation1pt1 [+ CountRole1] [+ LockObjectAnnotation1pt2] */ RM TS VDS ';
end rule


% //***LockObjectPattern:  Role = 2(Creation of static method in the same class are Role 1 - getLockObject().
% //								** Contains Role 2a.);
rule findGetLockObjectMethods
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}
	import objectIDCollection [repeat id]
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isReturnLockObj MD each objectIDCollection]

	import tmpRole2Passed [number]
	where
		tmpRole2Passed [> 0]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}
	construct TransformedMB [method_body]
        TransformedBL2

	construct LockObjectAnnotation2pt1 [stringlit]
		"@LockObjectPatternAnnotation(patternInstanceID="
	construct LockObjectAnnotation2pt2 [stringlit]
		", roleID=2, roleDescription='Creation of static method in the same class as Role 1 - getLockObject().')"

	import CountGetLockObjectMethIDs [number]

	export tmpRole2Passed
		0

	by
		'MUTATED /* LockObjectAnnotation2pt1 [+ CountGetLockObjectMethIDs] [+ LockObjectAnnotation2pt2] */ RM TS MD OT TransformedMB
end rule

% //***LockObjectPattern:  Role = 2a(Return of lock object, Role 1.);
rule isReturnLockObj MD [method_declarator] objectID [id]
	replace [return_statement]
		'return OE [opt expression] ';

	where all
		OE [matchesVarID objectID]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	import getLockObjectMethIDs [repeat id]
	construct newMethodIDs [repeat id]
		getLockObjectMethIDs [. methodID]
	export getLockObjectMethIDs
		newMethodIDs

	import CountGetLockObjectMethIDs [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		CountGetLockObjectMethIDs [+ PlusOne]
	export CountGetLockObjectMethIDs
		NewCount

	import tmpRole2Passed [number]
	construct NewCountb [number]
		tmpRole2Passed [+ PlusOne]
	export tmpRole2Passed
		NewCountb

	construct LockObjectAnnotation2apt1 [stringlit]
		"@LockObjectPatternAnnotation(patternInstanceID="
	construct LockObjectAnnotation2apt2 [stringlit]
		", roleID=2a, roleDescription='Return of lock object, Role 1.')"

	by
		'MUTATED /* LockObjectAnnotation2apt1 [+ CountGetLockObjectMethIDs] [+ LockObjectAnnotation2apt2] */
		'return OE ';

end rule


% //***LockObjectPattern:  Role = 3(Synchronized calls to method Role 2.);
rule findSynchCallsToGetLockObjMeths
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}
	import getLockObjectMethIDs [repeat id]
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isCallToGetLockObjMeth MD each getLockObjectMethIDs]

	import tmpRole3Passed [number]
	where
		tmpRole3Passed [> 0]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}
	construct TransformedMB [method_body]
        TransformedBL2

	export tmpRole3Passed
		0

	by
		'MUTATED RM TS MD OT TransformedMB
end rule

rule isCallToGetLockObjMeth MD [method_declarator] getLockObjectMethID [id]
	replace [synchronized_statement]
		'synchronized '( EX [expression] ')
			STMT [statement]
	where
		EX [matchesVarID getLockObjectMethID]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	import methIDsUsingLockObj [repeat id]
	construct newMethodIDs [repeat id]
		methIDsUsingLockObj [. methodID]
	export methIDsUsingLockObj
		newMethodIDs

	construct PlusOne [number]
		1
	import CountMethIDsUsingLockObjs [number]
	construct NewCount [number]
		CountMethIDsUsingLockObjs [+ PlusOne]
	export CountMethIDsUsingLockObjs
		NewCount


	import CountGetLockObjectMethIDs [number]
	construct numZero [number]
		'0
	where not
		CountMethIDsUsingLockObjs [hasNumber numZero]
	where not
		CountGetLockObjectMethIDs [hasNumber numZero]

	import Counter [number]
	construct NewCountb [number]
		Counter [+ PlusOne]
	export Counter
		NewCountb

	import tmpRole3Passed [number]
	construct NewCountc [number]
		tmpRole3Passed [+ PlusOne]
	export tmpRole3Passed
		NewCountc

	construct LockObjectAnnotation3pt1 [stringlit]
		"@LockObjectPatternAnnotation(patternInstanceID="
	construct LockObjectAnnotation3pt2 [stringlit]
		", roleID=3, roleDescription='Synchronized calls to method Role 2.')"

	by
		'MUTATED /* LockObjectAnnotation3pt1 [+ CountMethIDsUsingLockObjs] [+ LockObjectAnnotation3pt2] */
		'synchronized '( EX ')
			STMT
end rule


% Function to check if there is a match to a variable ID.
function matchesVarID theID [id]
	match * [id]
		theID
end function

% Function to check if there is a match to a specific number.
function hasNumber theNumber [number]
	match * [number]
		theNumber
end function

% Function to check if it is a variable of a specific type.
function isVarOfType VARTYPE [type_specifier]
	match * [type_specifier]
		VARTYPE
end function



