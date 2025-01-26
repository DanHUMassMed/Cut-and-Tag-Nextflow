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
        Nextflow.log.info("INFO: Path= $path ")
        File dir = new File(path);
        return dir.exists() && dir.isDirectory();
    }

    public static boolean fileExists(String path) {
        File file = new File(path);
        return file.exists() && file.isFile();
    }

    public static String fastqToTrimmedDir(String fastq_paired) {
        String original_dir = '/data/fastq'
        String trimmed_dir = '/results/trimmed'
        if (!fastq_paired.contains(original_dir)) {
            throw new IllegalArgumentException("Error: Expected $original_dir to be in the fastq_paired path .");
        }
        Nextflow.log.info("INFO: fastq_paired = $fastq_paired")
        return fastq_paired.replace(original_dir, trimmed_dir);
    }

    public static String waitOnCollect(Object collected) {
        Nextflow.log.info("INFO: waitOnCollect is returning. Process continues")
        return collected;
    }

    public static fileCount(String dirPath) {
        def dir = new File(dirPath)
        if (!dir.exists() || !dir.isDirectory()) {
            throw new IllegalArgumentException("Invalid directory path: $dirPath")
        }
        
        def fileCounter = 0
        // Recursively go through all files and subdirectories
        dir.eachFileRecurse { file ->
            if (file.isFile()) {
                fileCounter++
            }
        }
        Nextflow.log.info("INFO: Counted $fileCounter files in $dirPath ")
        return fileCounter
    }


}