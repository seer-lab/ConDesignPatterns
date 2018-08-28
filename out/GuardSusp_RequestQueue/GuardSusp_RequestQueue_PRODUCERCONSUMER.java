import java.util.LinkedList;

public class RequestQueue {

    /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='List object to house the produced objects.')"
    */
    private final LinkedList queue = new LinkedList ();
    public synchronized Request getRequest () throws InterruptedException {
        while (queue.size () <= 0) {
            wait ();} return (Request) queue.removeFirst ();
    }

    public synchronized void putRequest (Request request) {
        queue.addLast (request); notifyAll ();}

}

