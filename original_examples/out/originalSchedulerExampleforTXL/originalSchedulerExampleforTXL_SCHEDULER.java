import java.util.*;

/* "@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Scheduler object/class.')"*/
public class Scheduler {
    private Thread runningThread;
    @SuppressWarnings("unchecked")
    private ArrayList waitingRequests = new ArrayList ();
    @SuppressWarnings("unchecked")
    private ArrayList waitingThreads = new ArrayList ();

    /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1a, roleDescription='Method with a parameter that is an instance of ScheduleOrdering object Role 3.')"
    */
    @SuppressWarnings("unchecked")
    public void enter (ScheduleOrdering s) throws InterruptedException {

        /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1aa, roleDescription='New thread creation outside of any critical section.')"
        */
        Thread thisThread = Thread.currentThread ();

        /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1ab, roleDescription='Critical section creation by synchronization of this Scheduler object Role 1.')"
        */
        synchronized (this) {
            {

                /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1aba, roleDescription='Within Role 1ab a check to whether the designated runningThread is null.')"
                */
                if (runningThread == null) {
                    {

                        /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1abaa, roleDescription='Assign thread Role 1aa (current thread) to the designated runningThread.')"
                        */
                        runningThread = thisThread;
                        /*
  "@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1abab, roleDescription='Return to calling Processor object Role 
                          4.')"*/
                        return;
                    }}

                /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1abac, roleDescription='Add thread Role 1aa to the list of waiting threads.')"
                */
                waitingThreads.add (thisThread);
                /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1abad, roleDescription='Add instance of ScheduleOrdering object Role 3 (that was passed into method Role 1a) into the list of waiting SchedulingOrdering object requests.')"
                */
                waitingRequests.add (s);}}

        /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1ac, roleDescription='Critical section creation by synchronization of thread Role 1aa.')"
        */
        synchronized (thisThread) {
            {

                /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1aca, roleDescription='A loop within critical section Role 1ac to check if the new thread Role 1aa is NOT the same as the designated runningThread.')"
                */
                while (thisThread != runningThread) {
                /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1acaa, roleDescription='New thread Role 1aa is placed in a waiting state until method Role 1b wakes it up using nofityAll().')"
                */
                {
                    thisThread.wait ();}}}}

        /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1ad, roleDescription='Critical section creation by synchronization of this Scheduler object Role 1.')"
        */
        synchronized (this) {
            {
                int i = waitingThreads.indexOf (thisThread);

                /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1ada, roleDescription='Remove current thread (Role 1aa) from the arraylist of waiting threads.')"
                */
                waitingThreads.remove (i);
                /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1adb, roleDescription='Remove current instance of the requested ScheduleOrdering object (Role 3), that was passed into method Role 1a, from the arraylist of waiting SchedulingOrdering object requests.  Correspond to the list of waiting threads.')"
                */
                waitingRequests.remove (i);}}
    }

    /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1b, roleDescription='Synchronized method called when the current thread is finished with resource.')"
    */
    synchronized public void done () {
        if (runningThread != Thread.currentThread ()) {
            throw new IllegalStateException ("Wrong Thread");
        }
        int waitCount = waitingThreads.size ();
        if (waitCount <= 0) {
            {
                runningThread = null;}} else if (waitCount == 1) {
            {
                runningThread = (Thread) waitingThreads.get (0); waitingThreads.remove (0);}} else {
            int next = waitCount - 1;
            ScheduleOrdering nextRequest;
            nextRequest = (ScheduleOrdering) waitingRequests.get (next); for (int i = waitCount - 2;
            i >= 0; i --) {
                ScheduleOrdering r;
                r = (ScheduleOrdering) waitingRequests.get (i); if (r.scheduleBefore (nextRequest)) {
                    next = i; nextRequest = (ScheduleOrdering) waitingRequests.get (next);}
            }
            runningThread = (Thread) waitingThreads.get (next);
            /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1ba, roleDescription='Critical section creation by synchronization of thread Role 1aa.')"
            */
            synchronized (runningThread) {
                {

                    /*
  "@SchedulerPatternAnnotation(patternInstanceID=1, roleID=1baa, roleDescription='NotifyAll to wake up other waiting 
                      threads.')"*/
                    runningThread.notifyAll ();}}
        }

    }

}

/*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Request object - implements the ScheduleOrdering interface Role 3.')"
*/
public class JournalEntry implements ScheduleOrdering {
    private Date time = new Date ();
    public Date getTime () {
        return time;
    }

    /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='Private boolean method that helps in determining the order in which the request objects will occur.')"
    */
    private boolean scheduleBefore (ScheduleOrdering s) {
        if (s instanceof JournalEntry) return getTime ().before (((JournalEntry) s).getTime ());

        return false;
    }

}

/*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=3, roleDescription='Schedule Ordering interface implemented by the Role 2 Request object.')"
*/
public interface ScheduleOrdering {

    /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=3a, roleDescription='Public boolean method that helps in determining the order in which the request objects will occur.')"
    */
    public boolean scheduleBefore (ScheduleOrdering s);

}

/*
"@SchedulerPatternAnnotation(patternInstanceID=2, roleID=3, roleDescription='Schedule Ordering interface implemented by the Role 2 Request object.')"
*/
public interface ScheduleOrdering2 {

    /*
"@SchedulerPatternAnnotation(patternInstanceID=2, roleID=3a, roleDescription='Public boolean method that helps in determining the order in which the request objects will occur.')"
    */
    public boolean scheduleBefore2 (ScheduleOrdering2 s);

}

/*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=4, roleDescription='Processor object - delegates scheduling of the request objects processing to the Scheduler object one at a time.')"
*/
class Printer {

    /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=4a, roleDescription='Creation of an instance of the Scheduler object (Role 1) outside of any method within Processor class(Role 4).')"
    */
    private Scheduler scheduler = new Scheduler ();

    /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=4b, roleDescription='Method with a parameter that is an instance of the Request object (Role 2) that carries out the main required functionality.')"
    */
    public void print (JournalEntry j) {
        try {

            /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=4ba, roleDescription='Call to the method (Role 1a) of the instance (Role 4a) of the Scheduler object (Role 1).  Occurs before any processing in method Role 4b.')"
            */
            scheduler.enter (j); try {
            } finally {

                /*
"@SchedulerPatternAnnotation(patternInstanceID=1, roleID=4bb, roleDescription='Call to the method (Role 1b) of the instance (Role 4a) of the Scheduler object (Role 1).  Occurs after all processing in method Role 4b.')"
                */
                scheduler.done ();}
        } catch (InterruptedException e) {
        }
    }

}

