# Microsacc
Processing and preparation of eye traces for microsaccade analysis

The resulting output from the last script `prep_for_BMD_and_preprocess.m` is a `.txt` file that is ready to be run with the BMD inference algorithm, directly as input to `./bmd`, as shown in 
[BMD](https://github.com/basvanopheusden/bmd) 

Sample data of one condition from participant who performed the task from this paper, with eye-tracking: 
 
 [Mihali, A, Young, AG, Adler, L, Halassa, MM, Ma, WJ. A low-level perceptual correlate of behavioral and clinical deficits in ADHD. 2018, Computational Psychiatry](https://www.mitpressjournals.org/doi/abs/10.1162/cpsy_a_00018)


##  Scripts

* `eye_script_1.sh` selects the trials that were completed without breaking fixation
* `eye_script_2.sh` parses the trials into the trial periods and also provides time stamps for the beginning and ends of each
* `prep_for_BMD_and_preprocess.m`selects the trial periods of interest and glues the time series together accordingly to prepare for microsaccade analysis with [BMD](https://github.com/basvanopheusden/bmd) 

