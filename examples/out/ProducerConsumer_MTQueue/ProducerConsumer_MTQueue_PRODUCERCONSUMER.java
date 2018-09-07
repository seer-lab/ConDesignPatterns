public class MTQueue {
    private Log log = LogFactory.getLog (MTQueue.class);

    /*
"@ProducerConsumerPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='List object to house the produced objects.')"
    */
    private LinkedList list = new LinkedList ();
    private long defaultTimeout = 10000;

    public MTQueue () {
    }

    public synchronized int size () {
        return list.size ();
    }

    public synchronized Object remove () {
        while (true) {
            Object answer = removeNoWait ();
            if (answer != null) {
                return answer;
            }
            try {
                wait (defaultTimeout);} catch (InterruptedException e) {
                log.error ("Thread was interrupted: " + e, e);}
        }}

    public synchronized void add (Object object) {
        list.add (object); notify ();}

    public synchronized Object remove (long timeout) {
        Object answer = removeNoWait ();
        if (answer == null) {
            try {
                wait (timeout);} catch (InterruptedException e) {
                log.error ("Thread was interrupted: " + e, e);}
            answer = removeNoWait ();}
        return answer;
    }

    public synchronized Object removeNoWait () {
        if (! list.isEmpty ()) {
            return list.removeFirst ();
        }
        return null;
    }

}

