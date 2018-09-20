import java.util.LinkedList;

public class RequestQueue {
    private final LinkedList queue = new LinkedList ();

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    public synchronized Request getRequest () {

        /*
   "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='Ensuring there is a while 
          statement.')"*/
        while (queue.size () <= 0) {
        /*
 "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2aa, roleDescription='Ensuring there is a wait() 
          statement.')"*/
        {
            try {
                wait ();} catch (InterruptedException e) {
            }
        }} return (Request) queue.removeFirst ();
    }

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    public synchronized void putRequest (Request request) {
        queue.addLast (request);
        /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1a, roleDescription='Ensure there is a nofify() or notifyAll() statement.')"
        */
        notifyAll ();}

}

