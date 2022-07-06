PKG = check_pflogsumm
PATHDIR= check-pflogsumm
CONTAINER = checkmk-${PKG}
IMAGE = checkmk/check-mk-raw:2.0.0p24
DIRS = $(shell ls -d ${PWD}/${PATHDIR}/*/)
MKP = $(shell docker exec -u cmk checkmk-${PKG} bash -c "ls -1 ~/*mkp")
DEBUG = "-D"

.DEFAULT: check_pflogsumm
.PHONY: _docker_run _docker_stop _copy_files _create _pack _copy_mkp check_pflogsumm

_docker_run:
	docker run --detach --rm --name=${CONTAINER} ${IMAGE} && sleep 10

_docker_stop:
	docker stop -t 0 checkmk-${PKG}

_copy_files:
	for dir in $$(ls -d $$PWD/${PATHDIR}/*/); do docker ${DEBUG} cp $$dir ${CONTAINER}:/omd/sites/cmk/local/share/check_mk/; done

_copy_info:
	docker ${DEBUG} cp ${PWD}/${PATHDIR}/info ${CONTAINER}:/omd/sites/cmk/var/check_mk/packages/${PKG}

_create:
	docker ${DEBUG} exec -u cmk ${CONTAINER} bash -l -c "cd ~ && mkp create ${PKG}"

_pack:
	docker ${DEBUG} exec -u cmk ${CONTAINER} bash -l -c "cd ~ && mkp pack ${PKG}"

_copy_mkp:
	docker ${DEBUG} cp ${CONTAINER}:${MKP} ./

check_pflogsumm: _docker_run _copy_files _copy_info _create _pack _copy_mkp _docker_stop
