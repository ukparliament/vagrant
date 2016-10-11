.dummy: build-image

build-image:
	pushd packer && \
		rm -rf output-virtualbox-iso && \
		packer build -color=false template.json && \
		popd

push-image:
	aws s3 cp \
		packer/packer_virtualbox-iso_virtualbox.box \
		s3://ukpds.common/vagrant_images/ubuntu-1604-baseline.box \
		--grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers