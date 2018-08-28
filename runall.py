import os
from subprocess import call

OUT_DIR = "./out/"
TXL_RULES_DIR = "./txl/rules/"
EXAMPLES_DIR = "./examples/"

call("rm " + OUT_DIR + "*.java", shell=True)

for example_filename in os.listdir(EXAMPLES_DIR):

    example_filename_root = os.path.splitext(example_filename)[0]
    CURR_OUT_DIR = OUT_DIR + example_filename_root

    call(["mkdir", CURR_OUT_DIR])

    for txl_filename in os.listdir(TXL_RULES_DIR):

        txl_filename_basic = os.path.splitext(txl_filename)[0].replace("Finder", "").replace("Pattern", "")

        call(["txl", os.path.join(EXAMPLES_DIR, example_filename), "-o", os.path.join(CURR_OUT_DIR, example_filename_root) + "_" + txl_filename_basic.upper() + ".java" , os.path.join(TXL_RULES_DIR, txl_filename)])

call("rm TransformedFor*.java", shell=True)