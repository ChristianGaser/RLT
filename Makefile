# Personal Makefile variables
#
# $Id: Makefile 153 2018-02-18 22:15:57Z gaser $

VERSION=`svn info |grep Revision|sed -e 's/Revision: //g'`
DATE=`svn info |grep 'Last Changed Date: '|sed -e 's/Last Changed Date: //g'|cut -f1 -d' '`

TARGET=/Users/gaser/spm/spm12/toolbox/RLT
TARGET2=/Volumes/UltraMax/spm12/toolbox/RLT

STARGET_HOST=141.35.69.218
STARGET_HTDOCS=${STARGET_HOST}:/volume1/web/
STARGET_FOLDER=/volume1/web/rlt
STARGET=${STARGET_HOST}:${STARGET_FOLDER}

MATLAB_FILES=Contents.m spm_RLT.m rlt_* RLT.man tbx_cfg_RLT.m
TEMPLATE_FILES=Template_*.nii TPM_*.nii Brainmask_C57Bl6.nii
FILES=${MATLAB_FILES} ${TEMPLATE_FILES}

ZIPFILE=rlt_r$(VERSION).zip

install:
	-@echo install
	-@test ! -d ${TARGET} || rm -rf ${TARGET}
	-@mkdir ${TARGET}
	-@cp -RL ${FILES} ${TARGET}

install2:
	-@echo install2
	-@test ! -d ${TARGET2} || rm -rf ${TARGET2}
	-@mkdir ${TARGET2}
	-@cp -RL ${FILES} ${TARGET2}

help:
	-@echo Available commands:
	-@echo install zip scp update

update:
	-@svn update
	-@echo '% Rodent Longitudinal Toolbox (RLT)' > Contents.m
	-@echo '% Version ' ${VERSION} ' (RLT) ' ${DATE} >> Contents.m
	-@cat Contents_info.txt >> Contents.m
	-@cat RLT.txt > RLT.man
	-@echo '% Rodent Longitudinal Toolbox' > INSTALL.txt
	-@echo '% Version ' ${VERSION} ' (RLT) ' ${DATE} >> INSTALL.txt
	-@cat INSTALL_info.txt >> INSTALL.txt

zip: update
	-@echo zip
	-@test ! -d RLT || rm -r RLT
	-@mkdir RLT
	-@cp -rp ${FILES} RLT
	-@zip ${ZIPFILE} -rm RLT

scp: zip
	-@echo scp to http://${STARGET_HOST}/rlt/${ZIPFILE}
	-@scp -P 2222 CHANGES.txt ${ZIPFILE} ${STARGET}
	-@bash -c "ssh ${STARGET_HOST} ln -Fs ${STARGET_FOLDER}/${ZIPFILE} ${STARGET_FOLDER}/rlt_latest.zip"
