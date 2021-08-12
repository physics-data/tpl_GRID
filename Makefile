.PHONY: all
all: spectrum.png light_curve.png all_response.png

spectrum.png: data/srv/srv_*.csv
	python3 energy_spectrum.py $< $@

light_curve.png: data/srv/srv_*.csv data/constant.json
	python3 source_generate.py $^ $@

cubesat_response/cubesat1_0.csv: data/matrix/Cube*_det*.rsp lightcurve_output/light_curve_*_*.csv data/constant.json
	python3 calculate_response.py $^ $@

all_response.png: cubesat*_*.csv
	python3 plot_signal.py $^ $@


# Delete partial files when the processes are killed.
.DELETE_ON_ERROR:
# Keep intermediate files around
.SECONDARY:
	

