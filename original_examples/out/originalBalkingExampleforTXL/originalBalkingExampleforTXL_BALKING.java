public class Flusher {
    private boolean justAnotherFlag = false;
    private boolean flushInProgress = false;
    private boolean justAnotherFlag2 = false;
    private string justAString = "just a string";
    void flushCompleted () {
        flushInProgress = false;
    }

    /* "@BalkingPatternAnnotation(patternInstanceID=2, roleID=1, roleDescription='Ensuring method is synchronized - 
      guarded')"*/
    public void flush () {
        synchronized (this) {
            private int testingotherstuff = 0;

            /*
"@BalkingPatternAnnotation(patternInstanceID=2, roleID=2, roleDescription='Ensure an if statement that tests a flag right at the start of the synchronized method')"
            */
            if (! flushInProgress) {
                flushInProgress = true;
            } else
            /*
"@BalkingPatternAnnotation(patternInstanceID=2, roleID=3, roleDescription='Ensuring one of the if or else tests of the flag in Role 2 does an immediate return - balking')"
            */
            {
                return;
            }
        }
    }

    void flushCompleted2 () {
        flushInProgress = false;
    }

    /* "@BalkingPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Ensuring method is synchronized - 
      guarded')"*/
    public synchronized void flush2 () {

        /*
"@BalkingPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Ensure an if statement that tests a flag right at the start of the synchronized method')"
        */
        if (flushInProgress == true)
        /*
"@BalkingPatternAnnotation(patternInstanceID=1, roleID=3, roleDescription='Ensuring one of the if or else tests of the flag in Role 2 does an immediate return - balking')"
        */
        return;

        flushInProgress = true;
    }

    void flushCompleted3 () {
        flushInProgress = false;
    }

}

