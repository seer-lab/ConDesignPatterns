public class Session implements Runnable {

    /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Thread(s) declaration - thread(s) that will be checked for an interrupt in Role 2.')"
    */
    private Thread myThread;
    private Portfolio portfolio;
    private Socket mySocket;

    public Session (Socket s) {
        myThread = new Thread (this); mySocket = s;}

    /* "@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Method running the process.')"*/
    public void run () {
        initialize ();
        /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='In a loop checking the latch - thread in Role 1 being checked for Role 2aa.')"
        */
        /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=2aa, roleDescription='Thread in Role 1 being checked if it has been interrupted.')"
        */
        while (! myThread.interrupted ()) {{
            portfolio.sendTransactionsToClient (mySocket);}}
        /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=2b, roleDescription='After the loop, a call to Role 4 that shuts down the thread.')"
        */
        shutdown ();}

    /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=3, roleDescription='Method that will contain functionality to set the latch - interrupt the thread in Role 1.')"
    */
    public void interrupt () {

        /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=3a, roleDescription='Actually setting the latch to true - interrupting the thread in Role 1.')"
        */
        myThread.interrupt ();}

    private void initialize () {
    }

    /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=4, roleDescription='Method that will contain functionality to stop the thread in Role 1.')"
    */
    private void shutdown () {

        /*
"@TwoPhaseTerminationPatternAnnotation(patternInstanceID=1, roleID=4a, roleDescription='Actually stopping of the thread in Role 1.')"
        */
        myThread.stop ();}

}

