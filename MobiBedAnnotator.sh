
#!/bin/bash      
#title           	:MobiBedAnnotator.sh
#description     	:This script will annotate a BED file with refSeq NM and exons positions
#author		 		: Henri Pégeot & David Baux
#date (dd/mm/yyyy)  :
#notes           	:
#bash_version   	:bash-3.2$-release
#==============================================================================

USAGE="
---
MobiBedAnnotator.sh: script to annotate a BED file for NGS experiments. requires bedtools to be installed
---

sh MobiBedAnnotator.sh -b /path/to/ROI.bed

Arguments:

	-r, 	--roi-bed:		Your ROI BED file to be annotated. Must contain 4 columns.
	
Options:
	
	-m, 	--master-bed:		Path to the provided master.bed file which contains annotations for all coding HGNC genes (05/2018). Default cwd.
	-b,	--bedtools-path:	Path to bedtools executables. Mandatory if bedtools not in path, optional otherwise

"
if [ "$#" -eq 0 ]; then
	echo "${USAGE}"
	echo "Error Message : No arguments provided"
	echo ""
	exit 1
fi



MASTER_PATH=master.bed
BEDTOOLS=$(command -v bedtools)

while [[ "$#" -gt 0 ]]
do
KEY="$1"
case "${KEY}" in
		-r|--roi-bed)
		ROI_PATH="$2"
		shift
		;;
		-m|--master-bed)
		MASTER_PATH="$2"
		shift
		;;
		-b|--bedtools-path)
		BEDTOOLS="$2"
		shift
		;;
		-h|--help)
		echo "${USAGE}"
		exit 1
		;;
		*)
		echo "Error Message : Unknown option ${KEY}" 	# unknown option
		exit
		;;
esac
shift
done

if [[ -e ${BEDTOOLS} && -e ${ROI_PATH} && -e ${MASTER_PATH} ]];then

	ROI_FILE=$(basename "${ROI_PATH}")
	
	sed '/^#/ d' ${ROI_PATH} | \
	${BEDTOOLS} intersect -a - -b master.bed -wa -wb | \
	awk 'OFS="\t" {print $1,$2,$3,$NF}' | \
	sort -k1,1 -k2,2n | \
	${BEDTOOLS} merge -i - -c 4 -o collapse > "tmp_annotated_merged_${ROI_FILE}"
	
	${BEDTOOLS} intersect -a ${ROI_PATH} -b ${MASTER_PATH} -v | \
	awk 'OFS="\t" {print $1,$2,$3,$NF}' > "tmp_not_annotated_${ROI_FILE}"
	
	cat "tmp_annotated_merged_${ROI_FILE}" "tmp_not_annotated_${ROI_FILE}" | \
	sort -k1,1 -k2,2n | \
	${BEDTOOLS} merge -i - -c 4 -o collapse > "Mobi_annotated_${ROI_FILE}"
	
	rm "tmp_annotated_merged_${ROI_FILE}" "tmp_not_annotated_${ROI_FILE}"
else
	echo "${USAGE}"
	echo "One condiion is not fullfilled"
	exit 1
fi


