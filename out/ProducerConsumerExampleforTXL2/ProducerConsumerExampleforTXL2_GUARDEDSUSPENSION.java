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
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    public synchronized Object remove () {

        /*
   "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='Ensuring there is a while 
          statement.')"*/
        while (true) {
        /*
 "@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=2aa, roleDescription='Ensuring there is a wait() 
          statement.')"*/
        {
            Object answer = removeNoWait ();
            if (answer != null) {
                return answer;
            }
            try {
                wait (defaultTimeout);} catch (InterruptedException e) {
                log.error ("Thread was interrupted: " + e, e);}
        }}}

    /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Ensuring a method in the class is synchronized - guarded')"
    */
    public synchronized void add (Object object) {
        list.add (object);
        /*
"@GuardedSuspensionPatternAnnotation(patternInstanceID=1, roleID=1a, roleDescription='Ensure there is a nofify() or notifyAll() statement.')"
        */
        notify ();}

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

