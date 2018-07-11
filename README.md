# MobiBedAnnotator
This script will annotate a BED file with refSeq NM and exons positions


MobiBedAnnotator.sh: script to annotate a BED file for NGS experiments. Requires bedtools to be installed
```
sh MobiBedAnnotator.sh -r /path/to/ROI.bed
```
Arguments:

	-r, 	--roi-bed:		Your ROI BED file to be annotated. Must contain 4 columns.
	
Options:
	
	-m, 	--master-bed:		Path to the provided master.bed file which contains annotations for all coding HGNC genes (05/2018). Default cwd.
	-b,	--bedtools-path:	Path to bedtools executables. Mandatory if bedtools not in path, optional otherwise
