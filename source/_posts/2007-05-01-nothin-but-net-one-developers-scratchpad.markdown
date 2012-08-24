---
layout: post
title: "Nothin But .Net - One Developers Scratchpad"
comments: true
date: 2007-05-01 09:00
categories:
- training
---

Just got back last Friday from another week of 'Nothin But .Net'. This proved to be the most intense iteration of the course yet. One of the developers who attended provided me with his 'scratchpad' of personal take aways from the course. It is a raw account, but I appreciated him taking the time to share it with me. I am posting it here as a means to give people an idea of what sort of topics are actually covered over the course of the week. It is interesting to see/hear what different ideas he took directly from the course, and others that he formulated over the course of the week:

<font color="#0000ff">Day 5</font>

<font color="#0000ff">Unit Of Work
- </font>

<font color="#0000ff">Aggregate Roots
- good for boundaries, protects the leaf items from rest of domain, that is its responsibility
- some add persistence coordination to aggregate roots, not JP's prefered strategy</font>

<font color="#0000ff">Tests document code, should read like a book
- refactoring tests too much can hurt readability, show reader </font>

<font color="#0000ff">UI Strategies for security etc
- Realize what the higher level of abstraction.
- Make some ui pieces role aware
- Ask how can I test this without running the app</font>

<font color="#0000ff">Threading
- don't use method implementations [MethodImpl(MethodImplOptions.Syncronized)], not good, see clr via c# for more
- proxies around your classes is better for threading  
- delegates</font>

<font color="#0000ff">Top down or bottom up
- higher level components should be driving contracts/interfaces for lower level
components, advantageous to flush out a better design
- so go ui to db 
- still, other approaches work too, go from db up to ui, domain layer and out etc.
- with traditional state based TDD, it is easier to start at the bottom layer and then work up</font>

<font color="#0000ff">Interfaces that Differ only by the types their methods call
- good candidate for generics</font>

<font color="#0000ff">Marker Interfaces/ Layer Supertype
- no member definitions
- can encompass the plumbing for persistence</font>

<font color="#0000ff">public interface ICartItemMapper : IDomainItemMapper...
- good trick for readability, ICartItemMapper doesn't have any methods defined</font>

<font color="#0000ff">AA analogy for how much we all still have to learn
- first step is admiting you have a prob
- then you are on your way to getting better :)</font>

<font color="#0000ff">Test Setup/Teardowns
- tempting to create setup bases, favour composition over inheritance, decorate with attributes to get the same effect</font>

<font color="#0000ff">Inheritance
- favour comp over inheritance
- avoid starting out using inheritance as the first approach, prefer refactoring towards inheritance & only if it really makes sense</font>

<font color="#0000ff">TableDefinitions class for all db types and column names
- as it get's bigger, it could be changed to a namespace quite easily
- shoppingCart.RequiredFields could be one strategy</font>

<font color="#0000ff">Insert vs Saves 
- Generic Saves that insert/update are a dangerous path to go down, wrong place to put this responsibility</font>

<font color="#0000ff">Constructors & Exceptions
- generally bad
- better to push responsibility for throwing to a factory</font>

<font color="#0000ff">Event Aggregators
- useful for pushing stuff up to aggregator from separate controls to then re-notify other controls on page</font>


<font color="#0000ff">Console2
- tabbed cmd prompt for xp</font>

<font color="#0000ff">Day 4</font>

<font color="#0000ff">Real World Issues
- work within you're circle of control
- TDD is part of being a professional software developer, its how to design code and specify contracts, not worthy of debate with other devs/mgt so avoid it
- life and careers are too short, do your due diligence before taking on projects and contracts
- don't insult other dev's by saying you'll code to lesser standards to ease complexity etc. not doing anyone favours, help them by pairing and getting them up to speed on better approaches than what they are used to
- ultimate agile goal is to deliver value quickly, never lose sight of that, esp when considering design approaches
- don't let mgr's and other devs label you, provide lots of details and be enthusiastic to describe specifically what you are doing, don't just tell them you're doing it the TDD way etc, this doesn't help anyone
- can't change your job...</font>

<font color="#0000ff">Pairing
- takes humility, can be painful to ego but very worthwhile in terms of speed, intensity and learning potential</font>

<font color="#0000ff">Ping Ponging
- SR dev writes test, junior writes implementation</font>

<font color="#0000ff">Learning strategies
- don't waste time at work, ditch the email, msn etc, deliver number one priority, 
use spare time to ramp and add even more value to employer
- set aside dedicated time
- jp's book list, 
- follow the order of the books in the lists
- MIT & Waterloo are producing grads that already know this stuff, follow them and invest time going through the MIT Open CourseWare
- study group
- ask lot's o questions
- get fast on the keyboard
- reading books is great and necessary but coding is better
- avoid re-using your older solutions, instead evolve and try 
to get better, besides IP can't be ported to new contracts</font>

<font color="#0000ff"></font> 

<font color="#0000ff">Refactoring
- ESSENTIAL
- can't be done without tests backing it up</font>

<font color="#0000ff">Table definitions
- system.codedom  to iterate and build a class per table etc...</font>

<font color="#0000ff">Simplest thing that makes sense is very relative to dev skill/experience</font>

<font color="#0000ff">Web Stuff
- firebug for js
- watin/water</font>

<font color="#0000ff">Exception Handling
- if you can handle it, do so, never just try catch for the sake of it
- tdd helps define better and drive out where they should be handled</font>

<font color="#0000ff">Mapper tests
- should be integration tests, if they reference columns etc, they do need to hit the db and fail if columns etc change</font>

<font color="#0000ff">Good Way to learn a true OO project is to look at the tests
- collaborations are tough to figure out just by browsing classes and interfaces.
- goood tests show collabs and interactions</font>

<font color="#0000ff">How to be a good developer
- lots o info here, 
- discipline, focus, time and hard work, nothing untennable</font>

<font color="#0000ff">Day 3</font>

<font color="#0000ff">NOD32 - nice virus protection</font>


<font color="#0000ff">Duplicating Code in TestMethods
- not necessarily a bad thing
- too much refactoring to common methods can lead 
to readability issues which should trump the need for removing duplication</font>

<font color="#0000ff">State vs Dependency
- black vs white box testing
- dependency based with mocks starts to define the contract with other mocked 
objects but it doesn't dictate the external dependent object's behaviour</font>

<font color="#0000ff">Teams 
- Break up responsibilities by layer
- have them work on it independently of each other
and come together to determine the interface needed</font>


<font color="#0000ff">JP's Dev approach
- JP will work on UI first on most projects, get it signed off</font>

<font color="#0000ff">MVP - Passive view
- presenter is an observer of UI
- by having it as an observer, it eliminates the coupling between the presenter and UI</font>

<font color="#0000ff">Ajax
Prototype
Script.aculo.us </font>

<font color="#0000ff">Service Layer
- really a facade
- course grained</font>

<font color="#0000ff">DTO's
- dumb ojbects serialization
- little lightweight objects to pass back and forth
- ProductBrowserDisplayDTO - very specific to the UI
- UI, Service, Presentation know about DTO's
- good candidates for code gen
- no tests needed in this layer</font>

<font color="#0000ff">Mocking and Order 
-surround with using(mocker.Ordered)
{
 - expectations inside here must be met in this order
}</font>


<font color="#0000ff">Integration Testing
- stuff that hits files/db etc
- more end to end through silos
- mapping from db should be tested here too because database changes could happen and not 
be caught with dependency based testing
- random get people up and type call outs are quite effective at making people pay attention</font>

<font color="#0000ff">Why TDD Fails
- get's frustrating that you realize quickly how much you need to learn/re-learn, exposes weak OOA&D skills</font>


<font color="#0000ff">Day 2
Check.Condition(numberOne>0) - design by contract
- pre and post conditions
- used to reveal intention
- fail fast as oposed to fail later</font>

<font color="#0000ff">Readable code trumps a lot of other design choices 
- comments are a smell</font>

<font color="#0000ff">Test Coverage 
- 80% a decent goal</font>

<font color="#0000ff">Method Naming
- LivingIn(Country country) better than LivingInCountry(Country country)</font>

<font color="#0000ff">Domain should drive out all yer code, except maybe logging
 - Utility should be only project that most other projects references
 - logging ok too
 - lots of utilities are a smell that you didn't assign resposibilities properly & poor design</font>

<font color="#0000ff">Refactor to patterns, don't start with them...</font>

<font color="#0000ff">User Stories
- ID stories, identify tasks for each story, estimate on tasks
- Pre Iteration Meeting
 - iteration mgr and biz analysts have time to take docs and extract key stories to focus on for an iteration
 - they try to break down into tasks</font>

<font color="#0000ff">- Iteration Meeting
 - Stories with tasks
 - Team identifies tasks that are too big that might be candidates for stories
 - Estimate tasks
 - Dev's sign up for tasks 
 - 8 hour workday translates to about 5 hours a day of real work 
 - Don't factor pairing etc into plan
 - any task over five hours deserves a separate story
 
- Each day
 - update prj mgr's where you're at
 - get done early, go help other devs finish their work
 
- Availability of SME's is key to success on agile and really any other projects</font>

<font color="#0000ff">Typically you only test external public methods
- could have internal public methods in an assembly, these could be tested by using assemblyinfo attribute: InternalVisibleTo="testassemblyname"
- or a post compile for prod could lock them down...</font>

<font color="#0000ff">Tracing & Logging
- instrumentation - tracing, affects performance
- aspect type logging, pre/post method execution, aspects on classes, goes further than decorators or proxies, waste of time to write this into your code
- logging get's into the methods internals
- good as a debugging tool
- avoid the slow debugger!
- expand on tests in logging factory
- so that we don't depend on </font>


<font color="#0000ff">Domain Classes Candidates
 - an exercise to identify classes. </font>

<font color="#0000ff">Primary Keys
- insist on surrogate keys, keys that are meaningless </font>


<font color="#0000ff">BDD/TDD
- primarily a difference in naming, bdd is tdd done right</font>

<font color="#0000ff">NSpec - bdd for .net </font>

<font color="#0000ff">Dependency based testing
        
  // we want to test that Log was called on some class
  // returned by Current
  [Test]
        public void Log_ShouldLogMessage()
        {
            Logger.Current.Log(this, "message");
        }
 
 
         [Test]
        public void Current_ShouldLeverageFactoryToCreateLoggingComponent()
        {
            // How To write a dependency test: 
   // start from the bottom (#5) up!
            // 1. Create mocks and fake results
            // 2. Setup expectations for methods to be called on your mocks
            // 3. Prepare mocks object to expect real calls form the object under test
            // 4. Invoke the method under test
            // 5. Make assertions if necessary
        }</font>

<font color="#0000ff">First Implemenation once test runs:
- The simplest thing that makes sense, returning a hard coded 1 etc doesn't add much value
- don't waste your time running something you absolutely know will fail</font>

<font color="#0000ff">UAMTC for SVN
update add merge test commit</font>

<font color="#0000ff">Day 1</font>

<font color="#0000ff">- wpf nice, good support for design pats
- MBUnit - leaner meaner more dev than nunit
- createing a shortcut to create a new blank sln in the explorer new dialogue, see "Solution in New dialogue.zip"
- visualsvn good ide svn add-in
- myuninstaller - keyboard driven, ctrl U to uninstall selected program
- keyboard link firefox for mouseless browsing
- snippet compiler</font>

<font color="#0000ff">Test naming convention 
$TestedMethod$_Should$Name_Conditions$
 - roy osherove
 - </font><a href="http://weblogs.asp.net/rosherove/archive/2005/04/03/TestNamingStandards.aspx"><font color="#0000ff">http://weblogs.asp.net/rosherove/archive/2005/04/03/TestNamingStandards.aspx</font></a>

<font color="#0000ff">JP the IAxeMan 
- interfaces for everything except DAO's, ValueObjects
- code classes inside test exactly as how you would use it in real app
- how do you want it to behave, how would you want to use it
- simplest thing possible
- get the red compiler errors before red test fail errors
- doesn't use I for Interface, consumer shouldn't know they are talking to abstractions...
- remove refactor so resharper is only R option in alt clicking - right click on tool bar, customize, re-arrange...
- try to minimize number of assertions to one per test
- mbunit RowTest with Row and params in sig for nTest scenarios
- check out mbunit.org, rollbacks, decorators
 - drill Assert.*
 
- assertions - heavyweight guard clauses, using exceptions instead of debug.assert makes it a biz rule rather than just a debug helper</font>

<font color="#0000ff">- TestFixtureSetUp/TearDown - only runs once per test class vs setup and teardown which run once per test method
- SetUp is a good candidate for doing things as you don't want to maintain state between tests, don't want to have some tests affecting behaviour of other tests</font>

<font color="#0000ff">Automate anything that needs to be clicked more than once
- VS for building is too slow
- prefer logging to debugging, a good presentation layer test suite,  
- TDD minimizes the sheer horror of click driven development</font>

<font color="#0000ff">Partial Classes
- good for tool gen code
- null objects -- see missing person example, an object creates a null object to return in casses where null is needed to be usable by client, Person frees person class from being cluttered up.</font>

<font color="#0000ff">Delegate
- type safe function pointer, reference to an event</font>

<font color="#0000ff">Constructor Overloading
- the one that takes the most params should do the work, don't have all your constructors doing stuff when they are overloaded
- when you get an object back you should just be able to call stuff on it without any client initialization needed</font>

<font color="#0000ff">Decorator
- have to be same type as class they are decorating, implement interface, inherit from base</font>

<font color="#0000ff">Events
Creating 
        // step 1 - create an EventArgs derivative (if necessary) it inherits from Event Args
        // step 2 - create the delegate sig for the event handlers
        // step 3 - Create the calss that will raise the event (subject)
        // step 4 - Raise the event to notify the subscribers
- you need to test to see that you're object under test does what it is supposed to do to the mocks, you're not testing the mocks though!
- be careful when raising events </font>


<font color="#0000ff">StateBaseTestDrivenDevelopment
- setup state and assert </font>

<font color="#0000ff">DataDynamics good for reporting</font>


<font color="#0000ff">Lose the Mouse...
- alt d - get's you to the address bar in explorer
- alt s c - constant
- alt F W = new folder
- backspace = up folder
- alt F D = new project
 - alt N - edit project name
 - alt P - project Type
- alt P R - add reference
- alt R N - add new file type from template
- alt W L - close all open text editor tabs
- f2 - rename
- ctrl shift enter - fullscreen text editor
- ctrl e - recent files
- f12 - next error
- alt enter - available fixes
- alt ins - gen code
- alt ins, i,  ctrl a, space, enter - gen code, select all, select, to gen interface implementations
- never checks off "remove redundant qualifiers"
- ctrl shift alt f - reformat without dialogue
- .. Enter - in file dialogue, goes up a dir
ctrl shift v - clibboard ring
ctrl shift uparrow - moves method up
ctrl shift downarrow - moves method down
pull members up - ctrl shift r b - brings a member up to the base to define it
alt-delete - will delete it safely and make sure that no one is using it(no other references)
f6, alt f - move a type to another file
alt f12 - next error in soln.
ctrl n - find by type, case sensitive to get the right one
ctrl alt n - inline variable
alt s r - add a reference when inside a web project</font>

 

 

 




