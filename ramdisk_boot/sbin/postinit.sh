#!/system/bin/sh

mount -o remount,rw /
mount -o rw,remount /system

chmod 666 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 1900000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 666 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 100000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

#
# Fast Random Generator (frandom) support on boot
#
if [ -c "/dev/frandom" ]; then
	# Redirect random and urandom generation to frandom char device
	chmod 0666 /dev/frandom
	chmod 0666 /dev/erandom
	mv /dev/random /dev/random.ori
	mv /dev/urandom /dev/urandom.ori
	rm -f /dev/random
	rm -f /dev/urandom
	ln /dev/frandom /dev/random
	chmod 0666 /dev/random
	ln /dev/frandom /dev/urandom
	chmod 0666 /dev/urandom
fi

#
# Init.d
#
if [ ! -d /system/etc/init.d ]; then
	mkdir -p /system/etc/init.d/;
	chown -R root.root /system/etc/init.d;
	chmod 777 /system/etc/init.d/;
fi;

busybox run-parts /system/etc/init.d


/sbin/busybox mount -t rootfs -o remount,ro rootfs
/sbin/busybox mount -o remount,ro /system /system
/sbin/busybox mount -o remount,rw /data

