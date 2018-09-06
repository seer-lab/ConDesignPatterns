public class MTQueue {
    private Log log = LogFactory.getLog (MTQueue.class);
    private LinkedList list = new LinkedList ();
    private long defaultTimeout = 10000;

    public MTQueue () {
    }

    public synchronized int size () {
        return list.size ();
    }

    /*
"@LockObjectPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Creation of static method in the same class as Role 1 - getLockObject().')"
    */
    public synchronized Object remove () {
        while (true) {

            /*
"@LockObjectPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Creation of static object in a class - lock object.')"
            */
            Object answer = removeNoWait ();
            if (answer != null) {

                /*
                "@LockObjectPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='Return of lock object, Role 
                  1.')"*/
                return answer;
            }
            try {
                wait (defaultTimeout);} catch (InterruptedException e) {
                log.error ("Thread was interrupted: " + e, e);}
        }}

    public synchronized void add (Object object) {
        list.add (object); notify ();}

    /*
"@LockObjectPatternAnnotation(patternInstanceID=2, roleID=2, roleDescription='Creation of static method in the same class as Role 1 - getLockObject().')"
    */
    public synchronized Object remove (long timeout) {

        /*
"@LockObjectPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Creation of static object in a class - lock object.')"
        */
        Object answer = removeNoWait ();
        if (answer == null) {
            try {
                wait (timeout);} catch (InterruptedException e) {
                log.error ("Thread was interrupted: " + e, e);}
            answer = removeNoWait ();}

        /* "@LockObjectPatternAnnotation(patternInstanceID=2, roleID=2a, roleDescription='Return of lock object, Role 1.')"*/
        return answer;
    }

    public synchronized Object removeNoWait () {
        if (! list.isEmpty ()) {
            return list.removeFirst ();
        }
        return null;
    }

}

