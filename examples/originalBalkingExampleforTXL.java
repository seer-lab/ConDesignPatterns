public class Flusher {

	private boolean justAnotherFlag = false;
	private boolean flushInProgress = false;
	private boolean justAnotherFlag2 = false;
	private string justAString = "just a string";
	
    /* This method is called to notify object that a flush has completed. */
    void flushCompleted() {
        flushInProgress = false;
    } // flushCompleted()

	//***BalkingPattern:  Role = 1(Ensuring method is synchronized - guarded); ID = 1.
    //***BalkingPattern:  Role = 2(Ensure an if statement  that tests a flag right at 
    //						the start of the synchronized method); ID = 1.
    //***BalkingPattern:  Role = 3(Ensuring one of the if or else tests of the flag in 
    //						Role 2 does an immediate return - balking ); ID = 1.
	/* This method is called to start a flush. */
    public void flush() {
        synchronized (this) {
        	private int testingotherstuff = 0;
        	if (!flushInProgress){
                flushInProgress = true;        		
        	}else{
              return;
        	}
        }         
    }
    /* This method is called to notify object that a flush has completed. */
    void flushCompleted2() {
        flushInProgress = false;
    } // flushCompleted()

    public synchronized void flush2() {
        	if (flushInProgress == true)
              return;
            flushInProgress = true;
        // code to start flush goes here.
    }
    
    /* This method is called to notify object that a flush has completed. */
    void flushCompleted3() {
        flushInProgress = false;
    } // flushCompleted()
} // class Flusher
