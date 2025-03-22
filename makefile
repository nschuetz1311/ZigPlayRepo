uefi:
	make -C uefi rebuild

all: uefi

clean:
	make -C uefi clean