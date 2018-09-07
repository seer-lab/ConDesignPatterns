public class Session implements Runnable {
    private Thread myThread;
    private Portfolio portfolio;
    private Socket mySocket;

    public Session (Socket s) {
        myThread = new Thread (this); mySocket = s;}

    public void run () {
        initialize (); while (! myThread.interrupted ()) {
            portfolio.sendTransactionsToClient (mySocket);} shutdown ();}

    public void interrupt () {
        myThread.interrupt ();}

    private void initialize () {
    }

    private void shutdown () {
        myThread.stop ();}

}

