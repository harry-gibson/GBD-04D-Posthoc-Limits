# This Bash script is for writing the run_metadata.txt file manually,
# where this step cannot be included in the code (e.g. R), or the stage
# does not use code, such as the PR export (04b_PR_DB_Import_Export)

# R code for this step is available here https://map.ox.ac.uk/wiki/index.php/Guides:_GBD_Coding_Standards#R_code_to_include_in_all_stage_code,
# in addition to more details about this process

# Set the checkpoint output directory
CHECKPOINT_OUTPUTS="Checkpoint_Outputs"

## Run after writing outputs
# Write the date and Git code version to a run metadata file
DATE=$(date '+20%y_%m_%d_%H_%M_%S')
GIT_VERSION=$(git rev-parse --short=7 HEAD 2>/dev/null)

if [ -n "$GIT_VERSION" ]
then echo -e "$DATE\n$GIT_VERSION" > "$CHECKPOINT_OUTPUTS/run_metadata.txt"
else echo -e "$DATE\nNO_TAG" > "$CHECKPOINT_OUTPUTS/run_metadata.txt"
fi
