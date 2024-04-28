"""Calculate frequency."""
import sys

fcinte = float(int(sys.argv[1], 16))
fcfrac = float(int(sys.argv[2], 16))
# npresc = int(sys.argv[3])
npresc = 2.0
# freq_xo = int(sys.argv[4])
freq_xo = 30000000.0
# outdiv = int(sys.argv[5])
outdiv = 8.0
fccss = float(int(sys.argv[3], 16))
step = (fccss * npresc * freq_xo) / (0b10000000000000000000 * outdiv)

step_size = int((0b10000000000000000000 * 400000.0 * outdiv) / (npresc * freq_xo))

modem_dev_freq = float(int(sys.argv[4], 16))
dev_freq = (modem_dev_freq * npresc * freq_xo) / (0b10000000000000000000 * outdiv)


f1 = fcfrac/float(pow(2,19)) + fcinte
f2 = (freq_xo * npresc) / outdiv

freq = f1 * f2

print("Frequency: %-10.3f" % freq)
print("Step:      %-10.3f" % step)
print("step_size: 0x%04.4X" % step_size)
print("Deviation: %-10.3f" % dev_freq)

