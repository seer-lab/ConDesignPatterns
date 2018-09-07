import java.util.ArrayList;

public class Client implements Runnable {
    private Queue myQueue;

    public Client (Queue myQueue) {
        this.myQueue = myQueue;}

    public void run () {
        TroubleTicket tkt = null;
        myQueue.push (tkt);}

}

private class Queue {
    private ArrayList data = new ArrayList ();

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    synchronized public void push (TroubleTicket tkt) {
        data.add (tkt);
        /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1a, roleDescription='Ensure there is a nofify() or notifyAll() statement.')"
        */
        notify ();}

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    synchronized public TroubleTicket pull () {

        /*
   "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='Ensuring there is a while 
          statement.')"*/
        while (data.size () == 0) {
        /*
 "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2aa, roleDescription='Ensuring there is a wait() 
          statement.')"*/
        {
            try {
                wait ();} catch (InterruptedException e) {
            }
        }} TroubleTicket tkt = (TroubleTicket) data.get (0);
        data.remove (0); return tkt;
    }

    public int size () {
        return data.size ();
    }

}

public class Dispatcher implements Runnable {
    private Queue myQueue;

    public Dispatcher (Queue myQueue) {
        this.myQueue = myQueue;}

    public void run () {
        TroubleTicket tkt = myQueue.pull ();
    }

}

