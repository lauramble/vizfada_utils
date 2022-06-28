##### RNASEQ

# cd /path/to/species/rnaseq/salmon
exps=$(ls -d ERX*)
echo $exps
# data/species/SPECIES/rnaseq/salmon
root=/home/lmorel/VizFaDa/vizfada-app/Data/data
SPECIES=chicken
cd $root/species/$SPECIES/rnaseq/salmon
exps=$(ls -d ERX*)
for exp in $exps
do
    cd $exp
    [[ $exp =~ ERX(.{3})(.{2})(.{2}) ]]
    pathtoexp=$root/experiments/ERX/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}/$exp
    pathtosalmon=$root/species/$SPECIES/rnaseq/salmon/$exp
    rm -rf $pathtosalmon/fastqc $pathtosalmon/$exp $pathtoexp/pipeline_info/pipeline_info
    mkdir -p $pathtoexp/fastqc $pathtoexp/salmon $pathtoexp/pipeline_info
    cd $root/species/$SPECIES/rnaseq/fastqc
    fqc=$(ls $exp*)
    for f in $fqc
    do
        ln -rsvt $pathtoexp/fastqc $root/species/$SPECIES/rnaseq/fastqc/$f 
    done
    ln -rsvt  $pathtoexp/salmon $pathtosalmon/*
    ln -rvst $pathtoexp/pipeline_info $root/species/$SPECIES/rnaseq/pipeline_info/*
    cd ../salmon
done

exps=$(ls -d ERX*)
echo $exps

for exp in $exps
do
    rm -rf ../../../experiments/$exp
    ln -vs $PWD/$exp ../../../experiments/$exp
    ln -vs $PWD/pipeline_info ../../../experiments/$exp/pipeline_info
done

##### CHIPSEQ
# cd /path/to/species/chipseq
root=/home/lmorel/VizFaDa/vizfada-app/Data/data
SPECIES=chicken
chipseq=$root/species/$SPECIES/chipseq
experiments=$root/experiments

cd $chipseq
inputs=$(ls -d ERX*)
echo $inputs

for input in $inputs
do
    cd $input/results_$input/multiqc/narrowPeak
    exps=$(grep -Eo ERX[0-9]* ./multiqc_data/multiqc_data.json | sort | uniq)
    echo $exps
    for exp in $exps
    do
        [[ $exp =~ ERX(.{3})(.{2})(.{2}) ]]
        pathtoexp=$root/experiments/ERX/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}/$exp
        rm -rf $pathtoexp
        cp multiqc_report.html multiqc_report_$exp.html
        sed -i "s/^<\/head>$/<script type=\"text\/javascript\">\n\twindow.onload = function() {\n\t\tapply_mqc_hidesamples('show');\n\t};\n<\/script>\n\n<\/head>/" multiqc_report_$exp.html
        sed -i "s/value=\"hide\" checked>/value=\"hide\">/" multiqc_report_$exp.html
        sed -i "s/value=\"show\">/value=\"show\" checked>/" multiqc_report_$exp.html
        sed -i "s/\"mqc_switch re_mode off\">off/\"mqc_switch re_mode on\">on/" multiqc_report_$exp.html
        sed -i "s/<ul id=\"mqc_hidesamples_filters\" class=\"mqc_filters\"><\/ul>/<ul id=\"mqc_hidesamples_filters\" class=\"mqc_filters\">\n\t\t\t\t<li><input class=\"f_text\" value=\"^"$exp".*$\" tabindex=\"200\"><button type=\"button\" class=\"close\" aria-label=\"Close\"><span aria-hidden=\"true\">×<\/span><\/button><\/li>\n\t\t\t<\/ul>/" multiqc_report_$exp.html
        mkdir -p $pathtoexp/bigwig/scale $pathtoexp/macs/qc $pathtoexp/multiqc
        cd $chipseq/$input/macs/narrowPeak
        files=$(find . -name $exp"*" | sed 's/.\///')
        for file in $files
        do
            ln -rvs $PWD/$file $pathtoexp/macs/$file 
        done
        cd ../../bigwig
        files=$(find . -name $exp"*" | sed 's/.\///')
        for file in $files
        do
            ln -rvs $PWD/$file $pathtoexp/bigwig/$file
        done
        cd ..
        ln -rvs $PWD/results_$input/multiqc/narrowPeak/multiqc_data $pathtoexp/multiqc/multiqc_data
        ln -rvs $PWD/results_$input/multiqc/narrowPeak/multiqc_report_$exp.html $pathtoexp/multiqc/multiqc_report_$exp.html
        ln -rvs $PWD/results_$input/pipeline_info $pathtoexp/pipeline_info
        cd $chipseq/$input/results_$input/multiqc/narrowPeak
    done
    cd $chipseq
done

