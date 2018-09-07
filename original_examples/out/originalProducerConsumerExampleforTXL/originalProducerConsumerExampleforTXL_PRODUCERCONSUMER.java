import java.util.ArrayList;

/*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Producer class - supply objects to be consumed by the Role 3, the Consumer class.')"
*/
public class Client implements Runnable {

    /*
   "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1a, roleDescription='Local instance of Role 2, the 
      Queue.')"*/
    private Queue myQueue;

    public Client (Queue myQueue) {
        this.myQueue = myQueue;}

    public void run () {

        /*
     "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1b, roleDescription='Local instance of produced 
          object.')"*/
        TroubleTicket tkt = null;

        /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=1c, roleDescription='Call to push method of Role 1a, the local instance of the Queue.  Pushes Role 1b, the produced object.')"
        */
        myQueue.push (tkt);}

}

/*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Queue class - buffer between producer and consumer classes.')"
*/
private class Queue {

    /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='List object to house the produced objects.')"
    */
    private ArrayList data = new ArrayList ();

    /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2b, roleDescription='Synchronized method to push the produced objects into queue.')"
    */
    /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2ba, roleDescription='One of the parameters of Role 2b must have produced object.')"
    */
    synchronized public void push (TroubleTicket tkt) {

        /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2bb, roleDescription='Adding the produced object, Role 2ba to Role 2a, the arraylist.')"
        */
        data.add (tkt);
        /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2bc, roleDescription='Nofification that the thread has completed.')"
        */
        notify ();}

    /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2c, roleDescription='Synchronized method to pull the produced objects from queue to be consumed.')"
    */
    synchronized public TroubleTicket pull () {
        while (
        /*
    "@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2ca, roleDescription='Check size of the queue of Role 
          2a.')"*/
        data.size () == 0) {
            try {

                /* "@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2caa, roleDescription='Wait statement.')"*/
                wait ();} catch (InterruptedException e) {
            }
        }
        /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=2cb, roleDescription='Creating instance of produced object and assigning it the 1st value in the arraylist Role 2a.')"
        */
        TroubleTicket tkt = (TroubleTicket) data.get (0);

        /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2cc, roleDescription='Remove the assigned value in Role 2cb from the arraylist Role 2a.')"
        */
        data.remove (0);
        /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2cd, roleDescription='Returning the produced object - to be consumed by Role 3.')"
         * / return tkt;
    }

    public int size () {
        return data.size ();
    }

}

/*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=3, roleDescription='Consumer class - use objects produced by the Role 1, the Producer class.')"
*/
public class Dispatcher implements Runnable {

    /*
   "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=3a, roleDescription='Local instance of Role 2, the 
      Queue.')"*/
    private Queue myQueue;

    public Dispatcher (Queue myQueue) {
        this.myQueue = myQueue;}

    public void run () {

        /*
     "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=3b, roleDescription='Local instance of consumed 
          object.')"*/
        /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=3c, roleDescription='Call to pull method of Role 3a, the local instance of the Queue.  Pulls Role 3b, the object to be consumed.')"
        */
        TroubleTicket tkt = myQueue.pull ();
    }

}

