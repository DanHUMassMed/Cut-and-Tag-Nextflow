import nextflow.Nextflow
import java.util.UUID
import java.text.SimpleDateFormat
import java.util.Date

class WorkflowUtils {

    public static void initialize(params, log) {
        // Nothing is being initialized for this pipeline.
         Nextflow.log.info("INFO: Nothing is being initialized for this pipeline.")
    }

    public static Object generateUUIDs(int numberOfUUIDs) {
        List<String> uuidList = []
        for (int i = 0; i < numberOfUUIDs; i++) {
            UUID uuid = UUID.randomUUID()
            uuidList.add(uuid.toString())
        }
        return numberOfUUIDs == 1 ? uuidList[0] : uuidList
    }

    public static String getStageDirName() {
        Date currentDate = new Date()
        String desiredDateFormat = "MMM-dd-yyyy"

        SimpleDateFormat formatter = new SimpleDateFormat(desiredDateFormat)
        String formattedDate = formatter.format(currentDate)
        String retVal = "Results-$formattedDate"
        Nextflow.log.info("INFO: Stage Directory Name: $retVal")
        return retVal
    }

    public static boolean directoryExists(String path) {
        File dir = new File(path);
        return dir.exists() && dir.isDirectory();
    }

}