public class MTQueue {
    private Log log = LogFactory.getLog (MTQueue.class);
    private LinkedList list = new LinkedList ();
    private long defaultTimeout = 10000;

    public MTQueue () {
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized int size () {
        return list.size ();
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized Object remove () {
        while (true) {
            Object answer = removeNoWait ();
            if (answer != null) {
                return answer;
            }
            try {
                wait (defaultTimeout);
            } catch (InterruptedException e) {
                log.error ("Thread was interrupted: " + e, e);
            }
        }
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=3, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized void add (Object object) {
        list.add (object);
        notify ();
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=4, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized Object remove (long timeout) {
        Object answer = removeNoWait ();
        if (answer == null) {
            try {
                wait (timeout);
            } catch (InterruptedException e) {
                log.error ("Thread was interrupted: " + e, e);
            }
            answer = removeNoWait ();
        }
        return answer;
    }

    /*
"@SingleThreadedExecPatternAnnotation(patternInstanceID=5, roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
    */
    public synchronized Object removeNoWait () {
        if (! list.isEmpty ()) {
            return list.removeFirst ();
        }
        return null;
    }

}

