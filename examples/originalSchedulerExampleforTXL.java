import java.util.*;

//*** SchedulerPattern:  Role = 1(Scheduler object/class.
//								** Contains Role 1a.
//								** Contains Role 1b.
//								** Contains Role 1c.  
//								** Contains Role 1d.  
//								** Contains Role 1e.);
//		ID = 1.
public class Scheduler 
{
	//*** SchedulerPattern:  Role = 1a(Thread creation outside of any methods within Role 1 (will be null when not busy and when busy will contain a reference to the thread using the resource).); 
	//		ID = 1.
      private Thread runningThread;
      
      //*** SchedulerPattern:  Role = 1b(Arraylist declaration outside of any methods within Role 1 (will contain all requests for the resource).); 
      //	ID = 1.
      @SuppressWarnings("unchecked")
	private ArrayList waitingRequests = new ArrayList();
      
      //*** SchedulerPattern:  Role = 1c(Arraylist declaration outside of any methods within Role 1 (will contain all the waiting threads corresponding to role 1b).); 
      //	ID = 1.
      @SuppressWarnings("unchecked")
	private ArrayList waitingThreads = new ArrayList();

      //The enter method is called before the thread starts using a managed resource and does not return 
      //until the managed resource is not busy.
      //*** SchedulerPattern:  Role = 1d(Method with a parameter that is an instance of ScheduleOrdering object Role 3.
      //							** Contains Role 1da
      //							** Contains Role 1db
      //							** Contains Role 1dc
      //							** Contains Role 1dd);
      //	ID = 1. 
      //*** SchedulerPattern:  Role = 1da(New thread creation outside of any critical section.); 
      //	ID = 1.      
      //*** SchedulerPattern:  Role = 1db(Critical section creation by synchronization of this Scheduler object Role 1.
      //							** Contains Role 1dba);
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1dba(Within Role 1db a check to whether Role 1a object is null.  
      //							** If true proceed with Role 1dbaa and 1dbab.
      //							** If false proceed with Role 1dbac and 1dbad);
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1dbaa(Assign thread Role 1da (current thread) to thread Role 1a.);
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1dbab(Return to calling Processor object Role 4.); 
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1dbac(Add thread Role 1da to arraylist Role 1c.); 
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1dbad(Add instance of ScheduleOrdering object Role 3 (that was passed into method Role 1d) into arraylist Role 1b.); 
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1dc(Critical section creation by synchronization of thread Role 1da.
      //							** Contains Role 1dca);
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1dca(A loop within critical section Role 1dc to check if the new thread Role 1da is NOT the same as thread Role 1a.  
      //							** If true proceed with Role 1dcaa.
      //							** If false then new thread Role 1da is allowed to continue to run and proceeds to Role 1dd.);
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1dcaa(New thread Role 1da is placed in a waiting state until method Role 1e wakes it up using nofityAll().); 
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1dd(Critical section creation by synchronization of this Scheduler object Role 1.
      //							** Contains Role 1dda
      //							** Contains Role 1ddb);
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1dda(Remove current thread (Role 1da) from the arraylist of waiting threads (Role 1c).); 
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1ddb(Remove current instance of the requested ScheduleOrdering object (Role 3), that was passed into method Role 1d, from the arraylist of waiting SchedulingOrdering object requests (Role 1b).  Correspond to the waiting threads (Role 1c).); 
      //	ID = 1.
      @SuppressWarnings("unchecked")
	public void enter (ScheduleOrdering s) throws InterruptedException {
           Thread thisThread = Thread.currentThread();
           synchronized (this) {
                if  (runningThread == null) {
                     runningThread = thisThread;
                     return;
                }
                waitingThreads.add(thisThread);
                waitingRequests.add(s);
           }
           synchronized (thisThread) {
                while (thisThread != runningThread) {
                     thisThread.wait();
                }
           }
           synchronized (this) {
                int i = waitingThreads.indexOf(thisThread);
                waitingThreads.remove(i);
                waitingRequests.remove(i);
           }
      }

      
      //Call to the done method indicates current thread is finished with the resource
      //*** SchedulerPattern:  Role = 1e(Synchronized method called when the current thread is finished with resource.);
      //							** Contains Role 1ea.);
      //	ID = 1. 
      //*** SchedulerPattern:  Role = 1ea(Critical section creation by synchronization of thread Role 1da.
      //							** Contains Role 1eaa.);
      //	ID = 1.
      //*** SchedulerPattern:  Role = 1eaa(NotifyAll to wake up other waiting threads.);
      //	ID = 1.
      synchronized public void done () {
    	  if (runningThread != Thread.currentThread())
    		  throw new IllegalStateException ("Wrong Thread");
    	  int waitCount = waitingThreads.size();
    	  if (waitCount <= 0){
    		  runningThread = null;
    	  }else if(waitCount == 1){
    		  runningThread = (Thread)waitingThreads.get(0);
    		  waitingThreads.remove(0);
    	  }else {
    		  int next = waitCount - 1;
    		  ScheduleOrdering nextRequest;
    		  nextRequest = (ScheduleOrdering)waitingRequests.get(next);
    		  for (int i = waitCount - 2; i>=0; i--){
    			  ScheduleOrdering r;
    			  r = (ScheduleOrdering)waitingRequests.get(i);
    			  if (r.scheduleBefore(nextRequest)){
    				  next = i;
    				  nextRequest = (ScheduleOrdering)waitingRequests.get(next);
    			  }//if
    		  }//for
    		  runningThread = (Thread)waitingThreads.get(next);
    		  synchronized (runningThread){
    			  runningThread.notifyAll();
    		  }// synchronized (runningThread)
    	  }//if waitCount
      }// done()
      
 }// class Scheduler

//*** SchedulerPattern:  Role = 2(Request object - implements the ScheduleOrdering interface Role 3); 
//		ID = 1.
//*** SchedulerPattern:  Role = 2a(Private boolean method that helps in determining the order in which the request objects will occur.); 
//		ID = 1.
public class JournalEntry implements ScheduleOrdering 
{ 
    private Date time = new Date();

    public Date getTime() { return time; } //Returns time this journalEntry was created.

    //Returns true if given request should be scheduled before this one.
    private boolean scheduleBefore (ScheduleOrdering s) {
         if  (s instanceof JournalEntry)
              return getTime().before(((JournalEntry)s).getTime());
         return false;
    }
}

//*** SchedulerPattern:  Role = 3(Schedule Ordering interface implemented by the Role 2 Request object
//							** Contains Role 3a.); 
//		ID = 1.
//*** SchedulerPattern:  Role = 3a(Public boolean method that helps in determining the order in which the request objects will occur.); 
//		ID = 1.
public interface ScheduleOrdering {
    public boolean scheduleBefore (ScheduleOrdering s);
}
public interface ScheduleOrdering2 {
    public boolean scheduleBefore2 (ScheduleOrdering2 s);
}

//*** SchedulerPattern:  Role = 4(Processor object - delegates scheduling of the request objects processing to the Scheduler object one at a time. 
//								** Contains Role 4a.
//								** Contains Role 4b.); 
//		ID = 1.
//*** SchedulerPattern:  Role = 4a(Creation of an instance of the Scheduler object (Role 1) outside of any method within Processor class(Role 4).); 
//		ID = 1.
//*** SchedulerPattern:  Role = 4b(Method with a parameter that is an instance of the Request object (Role 2) that carries out the main required functionality. 
//								** Contains Role 4ba.
//								** Contains Role 4bb.); 
//		ID = 1.
//*** SchedulerPattern:  Role = 4ba(Call to the method (Role 1d) of the instance (Role 4a) of the Scheduler object (Role 1).  Occurs before any processing in method Role 4b.); 
//		ID = 1.
//*** SchedulerPattern:  Role = 4bb(Call to the method (Role 1e) of the instance (Role 4a) of the Scheduler object (Role 1).  Occurs after all processing in method Role 4b.); 
//		ID = 1.
class Printer 
{
    private Scheduler scheduler = new Scheduler();          
    public void print (JournalEntry j) {
    	try {
          scheduler.enter(j);
      		try {
      			//....
      		} finally {
      			scheduler.done();
      		}
         } catch (InterruptedException e) {
         }
    }
 }
    
    