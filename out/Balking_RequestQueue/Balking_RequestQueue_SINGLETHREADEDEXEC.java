import java.util.LinkedList;

public class RequestQueue {
    private final LinkedList queue = new LinkedList ();

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized Request getRequest () {
        while (queue.size () <= 0) {
            try {
                wait ();
            } catch (InterruptedException e) {
            }
        }
        return (Request) queue.removeFirst ();
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized void putRequest (Request request) {
        queue.addLast (request);
        notifyAll ();
    }

}

