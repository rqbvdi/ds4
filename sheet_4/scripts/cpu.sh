#!/bin/bash

# compile the testbench
EXE=build/tb_cpu
make ${EXE}
RETCODE=$?
if [[ "${RETCODE}" -ne 0 ]]; then
    echo "Error building ${EXE}, abort ..."
    exit 1
fi

#
DIRNAME=$1
if [ "${DIRNAME}" = "sort" ]; then
    HEADER=rv32i_sw/sort/sort.h
    INPUT=input_data
    NUM=15
    rm -f ${HEADER}
    rm -f ${INPUT}
    echo "const int size = ${NUM};" >> ${HEADER}
    echo "const int numbers[] = {" >> ${HEADER}
    for i in `seq 1 ${NUM}` ; do
        echo $RANDOM >> ${INPUT}
    done
    x=$(cat ${INPUT} | xargs | sed 's/ /, /g')
    echo $x >> ${HEADER}
    EXPECT=$(echo $x | sed 's/, /\n/g' | sort -n | xargs)
    echo "};" >> ${HEADER}
fi

# compile the code that should run on the CPU
CODEDIR=rv32i_sw/${DIRNAME}
make -C ${CODEDIR}
RETCODE=$?
if [[ "${RETCODE}" -ne 0 ]]; then
    echo "Error compiling code in ${CODEDIR}, abort ..."
    exit 1
fi

# copy memory files
cp ${CODEDIR}/data_mem.bin .
cp ${CODEDIR}/instruction_mem.bin .
if [ "${DIRNAME}" = "gauss" ]; then
    n=$(shuf -i 5-15 | head -n 1)
    x=$(echo ${n} | xargs printf '%x')
    echo -n -e "\x0${x}\x02\x03\x04" > data_mem.bin
    EXPECT=0
    for i in `seq 1 ${n}` ; do
        EXPECT=`expr ${EXPECT} + ${i}`
    done
    EXPECT=$(echo $EXPECT | xargs printf '%08X')
fi

# run the testbench
echo "Expected output is: ${EXPECT}"
OUTPUT=sim_output
${EXE} --unbuffered
RETCODE=$?
if [[ "$RETCODE" -ne 0 ]]; then
    echo "Failure during testbench execution"
    exit 1
fi

#