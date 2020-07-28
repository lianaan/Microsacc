# Microsacc
Processing and preparation of eye traces for microsaccade analysis

The resulting output from the last script `prep_for_BMD_and_preprocess.m` is a `.txt` file that is ready to be run with the [Bayesian microsaccade detection algorithm](https://github.com/basvanopheusden/bmd), directly as input to `./bmd`


## Data 
Sample data of one condition from one participant from  [Mihali et al, 2018] (https://www.mitpressjournals.org/doi/abs/10.1162/cpsy_a_00018), who performed the task verion with eye-tracking.  
 


##  Scripts

* `eye_script_1.sh` acts on the raw Eyelink output and selects the trials that were completed without breaking fixation
* `eye_script_2.sh` acts on `S1ORI10_parsed.txt` and parses the trials into the trial periods and also provides time stamps for the beginning and ends of each
* `prep_for_BMD_and_preprocess.m`selects the trial periods of interest and glues the time series together accordingly to prepare for microsaccade analysis with [BMD](https://github.com/basvanopheusden/bmd) 

