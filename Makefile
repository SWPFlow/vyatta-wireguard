all: deb-e50 deb-e100 deb-e200 deb-e300 deb-e1000

clean:
	rm -rf package

define gen_deb
	mkdir -p package/scratch
        tar --owner=root:0 --group root:0 -czf package/scratch/data.tar.gz -C generic . -C ../$(1) .
	cp -a debian package/scratch/
	sed -i "s/Architecture: .*/Architecture: $(2)/" package/scratch/debian/control
        tar --owner=root:0 --group root:0 -czf package/scratch/control.tar.gz -C package/scratch/debian .
        echo 2.0 > package/scratch/debian-binary
        ar -rcs package/$(shell sed -n 's/Version: \(.*\)/wireguard-$(1)-\1.deb/p' debian/control) package/scratch/debian-binary package/scratch/data.tar.gz package/scratch/control.tar.gz
        rm -rf package/scratch
endef

deb-e50: clean
	$(call gen_deb,e50,mipsel)

deb-e100: clean
	$(call gen_deb,e100,mips)

deb-e200: clean
	$(call gen_deb,e200,mips)

deb-e300: clean
	$(call gen_deb,e300,mips)

deb-e1000: clean
	$(call gen_deb,e1000,mips)
