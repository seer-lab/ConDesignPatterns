//*************************************************************************//
//*** Producer Consumer pattern:                                        ***//
//*** This design pattern allows for objects or information to be       ***//
//*** produced or consumed asynchronously in a coordinated manner.      ***//
//*************************************************************************//

/**
 * A multithreaded blocking queue which is very useful for
 * implementing producer-consumer style threading patterns.
 * <p>
 * Multiple blocking threads can wait for items being added
 * to the queue while other threads add to the queue.
 * <p>
 * Non blocking and timout based modes of access are possible as well.
 *
 * @author <a href="mailto:jstrachan@apache.org">James Strachan</a>
 * @version $Revision$
 */
public class MTQueue {

    /** The Log to which logging calls will be made. */
    private Log log = LogFactory.getLog(MTQueue.class);


    private LinkedList list = new LinkedList();
    private long defaultTimeout = 10000;

    public MTQueue() {
    }

    /**
     * Returns the current number of object in the queue
     */
    public synchronized int size() {
        return list.size();
    }

    /**
     * Removes the first object from the queue, blocking until one is available.
     * Note that this method will never return null and could block forever.
     */
    public synchronized Object remove() {
        while (true) {
            Object answer = removeNoWait();
            if ( answer != null ) {
                return answer;
            }
            try {
                wait( defaultTimeout );
            }
            catch (InterruptedException e) {
                log.error( "Thread was interrupted: " + e, e );
            }
        }
    }

    /**
     * adds a new object to the end of the queue.
     * At least one thread will be notified.
     */
    public synchronized void add(Object object) {
        list.add( object );
        notify();
    }

    /**
     * Removes the first object from the queue, blocking only up to the given
     * timeout time.
     */
    public synchronized Object remove(long timeout) {
        Object answer = removeNoWait();
        if (answer == null) {
            try {
                wait( timeout );
            }
            catch (InterruptedException e) {
                log.error( "Thread was interrupted: " + e, e );
            }
            answer = removeNoWait();
        }
        return answer;
    }

    /**
     * Removes the first object from the queue without blocking.
     * This method will return immediately with an item from the queue or null.
     *
     * @return the first object removed from the queue or null if the
     * queue is empty
     */
    public synchronized Object removeNoWait() {
        if ( ! list.isEmpty() ) {
            return list.removeFirst();
        }
        return null;
    }

}

