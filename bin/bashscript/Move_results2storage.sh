#!/bin/bash -l
#
# Script to run jSNPmania
##SBATCH --qos=short 
#SBATCH -p core  -n 1
#SBATCH -t 01:00:00


#Include functions
. $SERA_PATH/includes/logging.sh;

SuccessLog $SAMPLEID "Starts copying files to STORAGE ...";

# Check if the directory exists, if not create it
if [[ ! -d ${STORAGE_PATH} ]]; then
    mkdir ${STORAGE_PATH};
fi
    
# If STORAGE_PATH ends with a / remove the /
if [[ ${STORAGE_PATH} == */ ]]; then
    STORAGE_PATH=${STORAGE_PATH:0:-1}
fi
# If ROOT_PATH ends with a / remove the /
if [[ ${ROOT_PATH} == */ ]]; then
    ROOT_PATH=${ROOT_PATH:0:-1}
fi

if  [[ ! -d ${STORAGE_PATH}/BamFiles ]]; then
    mkdir ${STORAGE_PATH}/BamFiles;
fi

# Copy AmpliconMapped
if [[ -d ${ROOT_PATH}/AmpliconMapped ]]; then
    cp -p ${ROOT_PATH}/AmpliconMapped/* ${STORAGE_PATH}/BamFiles;
    cp -p ${ROOT_PATH}/Bwa/*alignmentStats.txt ${STORAGE_PATH}/BamFiles;
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/AmpliconMapped does not exist!";
fi

# Go through all bwa files in the Bwa folder
for bwaFile in `ls ${ROOT_PATH}/Bwa/*bam`
do
    echo "Bwafile: ${bwaFile}"
    parts=($(echo $bwaFile | tr "/" " "));
    partsLen=${#parts[@]}; # Calculate array length
    sampleFile=${parts[($partsLen-1)]}; # Extract filename from path
    fileParts=($(echo $sampleFile | tr "." " "));
    sample=${fileParts[0]}; # Extract sample name
    if [[ ! -e "${ROOT_PATH}/AmpliconMapped/${sample}.*" ]]; then # Check if the sample is not ampliconmapped
            cp -p $bwaFile* ${STORAGE_PATH}/BamFiles/ # Copy the bwa file for the non-ampliconmapped sample
        echo "cp -p $bwaFile* ${STORAGE_PATH}/BamFiles/"
        cp -p ${ROOT_PATH}/Bwa/*alignmentStats.txt ${STORAGE_PATH}/BamFiles; # Copy the alignment statistics
    fi
done

# Copy FilteredMutations
if [[ -d "${ROOT_PATH}/FilteredMutations" ]]; then
    #rsync -carv ${ROOT_PATH}/FilteredMutations ${STORAGE_PATH};
    cp -pr  ${ROOT_PATH}/FilteredMutations ${STORAGE_PATH}
    echo "cp -pr  ${ROOT_PATH}/FilteredMutations ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/FilteredMutations does not exist!";
fi

# Copy FilteredAnnovarOutput
if [[ -d "${ROOT_PATH}/FilteredAnnovarOutput" ]]; then
cp -pr  ${ROOT_PATH}/FilteredAnnovarOutput ${STORAGE_PATH};
echo "cp -pr  ${ROOT_PATH}/FilteredAnnovarOutput ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/FilteredAnnovarOutput does not exist!";
fi

# Copy ClinicalPositions
if [[ -d "${ROOT_PATH}/ClinicalPositions" ]]; then
    cp -pr  ${ROOT_PATH}/ClinicalPositions ${STORAGE_PATH};
    echo "cp -pr  ${ROOT_PATH}/ClinicalPositions ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/ClinicalPositions does not exist!";
fi

# Copy AnnovarOutput
if [[ -d "${ROOT_PATH}/AnnovarOutput" ]]; then
    cp -pr  ${ROOT_PATH}/AnnovarOutput ${STORAGE_PATH};
    echo "cp -pr  ${ROOT_PATH}/AnnovarOutput ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/AnnovarOutput does not exist!";
fi

# Copy PindelAnnovarOutput
if [[ -d "${ROOT_PATH}/PindelAnnovarOutput" ]]; then
    cp -pr  ${ROOT_PATH}/PindelAnnovarOutput ${STORAGE_PATH};
    echo "cp -pr  ${ROOT_PATH}/PindelAnnovarOutput ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/PindelAnnovarOutput does not exist!";
fi

# Copy vcfOutput
if [[ -d "${ROOT_PATH}/vcfOutput" ]]; then
    cp -pr  ${ROOT_PATH}/vcfOutput ${STORAGE_PATH};
    echo "cp -pr  ${ROOT_PATH}/vcfOutput ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/vcfOutput does not exist!";
fi

# Copy MSIanalysis
if [[ -d "${ROOT_PATH}/MSIanalysis" ]]; then
    cp -pr  ${ROOT_PATH}/MSIanalysis ${STORAGE_PATH};
    echo "cp -pr  ${ROOT_PATH}/MSIanalysis ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/MSIanalysis does not exist!";
fi

# Copy ExtractedSNPs
if [[ -d "${ROOT_PATH}/ExtractedSNPs" ]]; then
    cp -pr  ${ROOT_PATH}/ExtractedSNPs ${STORAGE_PATH};
    echo "cp -pr  ${ROOT_PATH}/ExtractedSNPs ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/ExtractedSNPs does not exist!";
fi

# Copy ExtractedEGFR
if [[ -d "${ROOT_PATH}/ExtractedEGFR" ]]; then
    cp -pr  ${ROOT_PATH}/ExtractedEGFR ${STORAGE_PATH};
    echo "cp -pr  ${ROOT_PATH}/ExtractedEGFR ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/ExtractedEGFR does not exist!";
fi

# Copy Amplification
if [[ -d "${ROOT_PATH}/Amplification" ]]; then
    cp -pr  ${ROOT_PATH}/Amplification ${STORAGE_PATH};
    echo "cp -pr  ${ROOT_PATH}/Amplification ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/Amplification does not exist!";
fi

# Copy FastQC
if [[ -d "${ROOT_PATH}/FastQC" ]]; then
    cp -pr  ${ROOT_PATH}/FastQC ${STORAGE_PATH};
    echo "cp -pr  ${ROOT_PATH}/FastQC ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/FastQC does not exist!";
fi

if [[ -d "${ROOT_PATH}/SNPmania" ]]; then
    cp -pr  ${ROOT_PATH}/SNPmania ${STORAGE_PATH};
    echo "cp -pr  ${ROOT_PATH}/SNPmania ${STORAGE_PATH}";
else
    ErrorLog "$SAMPLEID" "${ROOT_PATH}/SNPmania does not exist!";
fi

if [[ "$?" != "0" ]]; then
    ErrorLog "$SAMPLEID" "Failed in copying results to STORAGE";
else
    SuccessLog "$SAMPLEID" "Passed copying results to STORAGE";
fi