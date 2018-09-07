import java.util.*;

public class Scheduler {
    private Thread runningThread;

    /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='List object to house the produced objects.')"
    */
    @SuppressWarnings("unchecked")
    private ArrayList waitingRequests = new ArrayList ();

    /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=2, roleID=2a, roleDescription='List object to house the produced objects.')"
    */
    @SuppressWarnings("unchecked")
    private ArrayList waitingThreads = new ArrayList ();
    @SuppressWarnings("unchecked")
    public void enter (ScheduleOrdering s) throws InterruptedException {
        Thread thisThread = Thread.currentThread ();
        synchronized (this) {
            if (runningThread == null) {
                runningThread = thisThread; return;
            }
            waitingThreads.add (thisThread); waitingRequests.add (s);}
        synchronized (thisThread) {
            while (thisThread != runningThread) {
                thisThread.wait ();}}
        synchronized (this) {
            int i = waitingThreads.indexOf (thisThread);
            waitingThreads.remove (i); waitingRequests.remove (i);}
    }

    synchronized public void done () {
        if (runningThread != Thread.currentThread ()) throw new IllegalStateException ("Wrong Thread");

        int waitCount = waitingThreads.size ();
        if (waitCount <= 0) {
            runningThread = null;} else if (waitCount == 1) {
            runningThread = (Thread) waitingThreads.get (0); waitingThreads.remove (0);} else {
            int next = waitCount - 1;
            ScheduleOrdering nextRequest;
            nextRequest = (ScheduleOrdering) waitingRequests.get (next); for (int i = waitCount - 2;
            i >= 0; i --) {
                ScheduleOrdering r;
                r = (ScheduleOrdering) waitingRequests.get (i); if (r.scheduleBefore (nextRequest)) {
                    next = i; nextRequest = (ScheduleOrdering) waitingRequests.get (next);}
            }
            runningThread = (Thread) waitingThreads.get (next); synchronized (runningThread) {
                runningThread.notifyAll ();}
        }

    }

}

public class JournalEntry implements ScheduleOrdering {
    private Date time = new Date ();
    public Date getTime () {
        return time;
    }

    private boolean scheduleBefore (ScheduleOrdering s) {
        if (s instanceof JournalEntry) return getTime ().before (((JournalEntry) s).getTime ());

        return false;
    }

}

public interface ScheduleOrdering {
    public boolean scheduleBefore (ScheduleOrdering s);

}

public interface ScheduleOrdering2 {
    public boolean scheduleBefore2 (ScheduleOrdering2 s);

}

class Printer {
    private Scheduler scheduler = new Scheduler ();
    public void print (JournalEntry j) {
        try {
            scheduler.enter (j); try {
            } finally {
                scheduler.done ();}
        } catch (InterruptedException e) {
        }
    }

}

