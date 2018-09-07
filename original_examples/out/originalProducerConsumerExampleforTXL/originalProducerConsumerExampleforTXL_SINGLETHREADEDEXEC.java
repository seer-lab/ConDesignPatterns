import java.util.ArrayList;

public class Client implements Runnable {
    private Queue myQueue;

    public Client (Queue myQueue) {
        this.myQueue = myQueue;
    }

    public void run () {
        TroubleTicket tkt = null;
        myQueue.push (tkt);
    }

}

private class Queue {
    private ArrayList data = new ArrayList ();

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    synchronized public void push (TroubleTicket tkt) {
        data.add (tkt);
        notify ();
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    synchronized public TroubleTicket pull () {
        while (data.size () == 0) {
            try {
                wait ();
            } catch (InterruptedException e) {
            }
        }
        TroubleTicket tkt = (TroubleTicket) data.get (0);
        data.remove (0);
        return tkt;
    }

    public int size () {
        return data.size ();
    }

}

public class Dispatcher implements Runnable {
    private Queue myQueue;

    public Dispatcher (Queue myQueue) {
        this.myQueue = myQueue;
    }

    public void run () {
        TroubleTicket tkt = myQueue.pull ();
    }

}

