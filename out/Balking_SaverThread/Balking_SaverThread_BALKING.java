import java.io.IOException;

public class SaverThread extends Thread {
    private Data data;

    public SaverThread (String name, Data data) {
        super (name);
        this.data = data;
    }

    public void run () {
        try {
            while (true) {
                data.save ();
                Thread.sleep (1000);
            }
        } catch (IOException e) {
            e.printStackTrace ();
        } catch (InterruptedException e) {
            e.printStackTrace ();
        }
    }

}

